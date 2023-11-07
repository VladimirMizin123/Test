import 'dart:async';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/user_sign_up_info/user_sign_up_info_event.dart';
import 'package:gymeats_mobile/bloc/user_sign_up_info/user_sign_up_info_state.dart';
import 'package:gymeats_mobile/repository/add_address.dart';

import '../../app/sharedPrefrence.dart';
import '../../repository/sign_up.dart';
import '../../widget/app_widget.dart';

class UserSignUpInfoBloc
    extends Bloc<UserSignUpInfoEvent, UserSignUpInfoState> {
  UserSignUpInfoBloc() : super(InitialState()) {
    on<LatLogEvent>(_onLatLog);
    on<SignUpApiEvent>(_onSignUpApi);
  }

  _onLatLog(LatLogEvent event, Emitter<UserSignUpInfoState> emit) {
    getCurrentPosition();
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      debugPrint('position data--> $position');

      emit(LatLogState(currentPosition: position));
    }).catchError((e) async {
      debugPrint(e.toString());
      await Geolocator.requestPermission();
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings().then((value) async {
        permission = await Geolocator.checkPermission();
        debugPrint('permission--> $permission');
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            showToast(
                message: 'Location permissions are denied', isSuccess: false);
            return false;
          }
        }
        if (permission == LocationPermission.deniedForever) {
          showToast(
              message:
                  'Location permissions are permanently denied, we cannot request permissions.',
              isSuccess: false);
          return false;
        }
      });
      return false;
    }

    return true;
  }

  final SignUpRepository _repository = SignUpRepository();
  final AddAddressRepository _addressRepository = AddAddressRepository();
  String userID = '';
  _onSignUpApi(SignUpApiEvent event, Emitter<UserSignUpInfoState> emit) async {
    try {
      emit(SignUpLoadingState());
      await _repository.signUp(model: event.model).fold((left) {
        showToast(isSuccess: false, message: left.message!);
        emit(SignUpErrorState());
      }, (right) async {
        showToast(isSuccess: true, message: right.message!);

        userID = right.data!.userId!;

        await PreferenceUtils.setString(prefUserData, right.data!.userId!);
        await PreferenceUtils.setString(
            prefUserEmail, event.model.email?.trim() ?? "");
        await PreferenceUtils.setString(
            prefUserMobile, event.model.phoneNumber?.trim() ?? "");

        // try {
        //   await _addressRepository
        //       .addAddress(
        //     userId: userID,
        //     state: 'Gujarat',
        //     zipcode: event.model.addAddressModel?.zipcode ?? '',
        //     longitude: event.model.addAddressModel?.longitude ?? 0,
        //     streetName: event.model.addAddressModel?.streetName ?? '',
        //     city: event.model.addAddressModel?.city ?? '',
        //     streetNum: event.model.addAddressModel?.streetNum ?? '4',
        //     addressType: event.model.addAddressModel?.addressType ?? '',
        //     country: event.model.addAddressModel?.country ?? '',
        //     isPrimary: true,
        //     latitude: event.model.addAddressModel?.latitude ?? 0,
        //   )
        //       .fold((left) {
        //     showToast(isSuccess: false, message: left.message!);
        //   }, (right) async {});
        // } catch (e) {
        //   debugPrint('CATCH ERROR WHILE FETCH MEAL PLAN');
        // }

        try {
          await _repository.fetchMealPlan(right.data!.userId!).fold((left) {
            showToast(isSuccess: false, message: left.message!);
          }, (right) async {});
        } catch (e) {
          debugPrint('CATCH ERROR WHILE FETCH MEAL PLAN');
        }

        print(
            'event.model.restrictionID.LENGTH ----- ${event.model.restrictionID.length}');
        if (event.model.restrictionID.isNotEmpty) {
          try {
            await _repository
                .addUserRestriction(
              restrictionList: event.model.restrictionID,
              userid: userID,
            )
                .fold((left) {
              showToast(isSuccess: false, message: left.message!);
            }, (right) {
              // Get.toNamed('/GenderScreen', arguments: event.model.gender);
            });
          } catch (e) {
            showToast(isSuccess: false, message: e.toString());
          }
        } else {
          // Get.toNamed('/GenderScreen', arguments: event.model.gender);
        }

        emit(SignUpSuccessState());
        Get.offAllNamed('/GenderScreen', arguments: event.model);
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(SignUpErrorState());
    }
  }
}
