import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/models/default_card_model.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/stripe_card_model.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';
import 'package:gymeats_mobile/service/toast_service.dart';
part 'card_event.dart';
part 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  CardBloc() : super(CardInitial()) {
    on<ListAllCardEvent>(_onListAllCard);
    on<CreateOrEditCardEvent>(_onCardAdd);
    on<RemoveCardEvent>(_onRemoveCard);
    on<SetDefaultCardEvent>(_onSetDefaultCard);
  }

  final ApiServices _api = ApiServices();

  _onListAllCard(ListAllCardEvent event, Emitter<CardState> emit) async {
    try {
      emit(CardLoadingState(isLoading: true));
      log("Api : ${ApiUrls.listAllCard}");

      final responses = await Future.wait(
        [
          _api.get(ApiUrls.listAllCard),
          _api.get(ApiUrls.getDefaultCard),
        ],
      );
      final response = responses[0];

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('RESPONSE ${jsonDecode(response.body)}');
        StripeCardModel card = StripeCardModel.fromJson(jsonDecode(response.body));
        try {
          final cardResponse = responses[1];
          final raw = jsonDecode(cardResponse.body) as Map<String, dynamic>;

          final data = raw['data'] as Map<String, dynamic>?;
          final dynamic rawId = data?['defaultSourceId'] ?? data?['id'];
          final String? defaultId = (rawId is String && rawId.isNotEmpty) ? rawId : null;

          print('DEFAULT CARD ID: $defaultId');

          if (defaultId != null) {
            for (final c in (card.data ?? [])) {
              c.isPrimary = (c.id == defaultId);
            }
          } else {
            for (final c in (card.data ?? [])) {
              c.isPrimary = false;
            }
          }
        } catch (e, st) {
          print('ERROR $e');
          log(e.toString());
        }

        if (card.success ?? false) {
          emit(CardFetchSuccessState(cardList: card.data ?? []));
        }
      } else {
        emit(CardFetchSuccessState(cardList: []));
      }
    } catch (e) {
      emit(CardFetchSuccessState(cardList: []));
    } finally {
      emit(CardLoadingState(isLoading: false));
    }
  }

  _onCardAdd(CreateOrEditCardEvent event, Emitter<CardState> emit) async {
    try {
      emit(CardAddLoadingState(isLoad: true));

      final url = event.isAdd ? ApiUrls.createCard : ApiUrls.updateCard;
      final requestBody = jsonEncode(event.card);

      print("API URL: $url");
      log("Request Body: $requestBody");
      print(event.card);
      final response = event.isAdd
          ? await _api.post(url, event.card)
          : await _api.put(url, event.card);

      print('Raw Response Object: $response');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      log("Status Code: ${response.statusCode}");
      log("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        add(ListAllCardEvent());
        emit(CardSuccessState());
      } else {
        ErrorModel error = ErrorModel.fromJson(jsonDecode(response.body));
        ToastService.showToast(
          (error.errorMessage?.isNotEmpty ?? false)
              ? error.errorMessage!
              : "Unable to create the card. Please try again later.",
        );
      }
    } catch (e, stacktrace) {
      log('Exception: $e');
      log('Stacktrace: $stacktrace');
    } finally {
      emit(CardAddLoadingState(isLoad: false));
    }
  }

  _onRemoveCard(RemoveCardEvent event, Emitter<CardState> emit) async {
    try {
      emit(CardRemoveLoadingState(isLoad: true));

      final response = await _api.delete(
        ApiUrls.removeCard.replaceAll("{cardId}", event.id),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        add(ListAllCardEvent());
        emit(CardRemoveSuccessState());
      } else {
        ErrorModel error = ErrorModel.fromJson(jsonDecode(response.body));
        if (error.errorMessage?.isNotEmpty ?? false) {
          ToastService.showToast(error.errorMessage!);
        }
      }
    } catch (e) {
      log(e.toString());
    } finally {
      event.onSuccess?.call();
      emit(CardRemoveLoadingState(isLoad: false));
    }
  }

  _onSetDefaultCard(SetDefaultCardEvent event, Emitter<CardState> emit) async {
    try {
      emit(SetDefaultCardLoader(isLoad: true));
      print(event.id);
      final response = await _api.post(
          ApiUrls.setDefaultCard.replaceAll("{cardId}", event.id),
          {"id": event.id});
          print(response.statusCode);
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        event.onComplete?.call();
        add(ListAllCardEvent());
      } else {
        ErrorModel error = ErrorModel.fromJson(jsonDecode(response.body));
        print(error.errorMessage);
        if (error.errorMessage?.isNotEmpty ?? false) {
          ToastService.showToast(error.errorMessage!);
        }
      }
    } catch (e) {
      log(e.toString());
    } finally {
      emit(SetDefaultCardLoader(isLoad: false));
    }
  }
}
