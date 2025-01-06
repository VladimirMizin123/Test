// ignore_for_file: depend_on_referenced_packages
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/bloc/subscription/subscription_repository.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/subscription_status_model.dart';
import 'package:gymeats_mobile/service/in_app_purchase_service.dart';
part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(SubscriptionInitial()) {
    on<SubscriptionEvent>((event, emit) {});
    on<FetchSubscriptionEvent>(_fetchSubscriptionStatus);
    on<AddReceiptDetailsEvent>(_onReceiptDetailAdd);
  }

  final SubscriptionRepository _repo = SubscriptionRepository();

  Future<void> _fetchSubscriptionStatus(
      FetchSubscriptionEvent event, Emitter<SubscriptionState> emit) async {
    try {
      emit(SubStatusLoader(loader: true));
      Either<ErrorModel, SubscriptionStatusModel> status =
          await _repo.fetchSubscriptionStatus();

      if (status.isRight) {
        log("Response ${status.right.data}");
        emit(SubscriptionStatusState(status: status.right));
      } else {
        emit(SubscriptionStatusErrorState(
            message: status.left.errorMessage ?? ""));
      }
    } catch (e) {
      log(e.toString());
      emit(SubscriptionStatusErrorState(message: ""));
    } finally {
      emit(SubStatusLoader(loader: false));
    }
  }

  Future<void> _onReceiptDetailAdd(
      AddReceiptDetailsEvent event, Emitter<SubscriptionState> emit) async {
    try {
      emit(ReceiptDetailsLoadingState(isLoading: true));
      Either<ErrorModel, bool> res =
          await _repo.receiptDetailAdd(event.requestData);
      if (res.isLeft) {
        log(res.left.errorMessage ?? "");
        emit(
            SubscriptionStatusErrorState(message: res.left.errorMessage ?? ""));
      } else {
        IapService.i.fetchStatus();
        emit(ReceiptDetailsSuccessState());
      }
    } catch (e) {
      log(e.toString());
    } finally {
      emit(ReceiptDetailsLoadingState(isLoading: false));
    }
  }
}
