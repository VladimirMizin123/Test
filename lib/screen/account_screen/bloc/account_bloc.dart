import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/repository/get_account_details.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_event.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_state.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(InitialState()) {
    on<GetAllProgramEvent>(_onGetAllProgram);
    on<GetCurrentProgramEvent>(_onGetCurrentProgram);
    on<GetProgramInfoEvent>(_onGetProgramInfo);
    on<UpdateProgramDietEvent>(_onUpdateDietProgramInfo);
    on<GetSelectedImagePathEvent>(_onGetSelectedImagePath);
    on<GetProfileImageEvent>(_onGetProfileImage);
    on<GetProfileDetailsEvent>(_onGetProfileDetails);
    on<UpdateProfileDetailsEvent>(_onUpdateProfileDetails);
    on<UpdateProfileImageEvent>(_onUpdateProfileImage);
    on<ChangeProfilePasswordEvent>(_onChangeProfilePassword);
    on<GetUnitInfoEvent>(_onGetUnitInfo);
    on<UpdateUnitInfoEvent>(_onUpdateUnitInfo);
  }

  final AccountRepository _repository = AccountRepository();

  /// Get All Program =================================================================
  _onGetAllProgram(GetAllProgramEvent event, Emitter<AccountState> emit) async {
    emit(GetAllProgramLoadingState());

    try {
      await _repository.getAllProgramData().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(GetAllProgramSuccessState(
            programModelData: right.data?.edges ?? []));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetAllProgramErrorState(message: e.toString()));
    }
  }

  /// Get All Program =================================================================
  _onGetCurrentProgram(
      GetCurrentProgramEvent event, Emitter<AccountState> emit) async {
    emit(GetCurrentProgramLoadingState());

    try {
      try {
        await _repository.apiServices.get(ApiUrls
            .addIngredientsToUserGroceryList
            .replaceAll("{userId}", userId));
      } catch (e) {
        log(e.toString());
      }
      await _repository.getCurrentProgramData().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(GetCurrentProgramSuccessState(myProgram: right.data!.myProfile!));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetCurrentProgramErrorState(message: e.toString()));
    }
  }

  /// Get Program Info =================================================================
  _onGetProgramInfo(
      GetProgramInfoEvent event, Emitter<AccountState> emit) async {
    emit(GetProgramInfoLoadingState());

    try {
      await _repository.getProgramInfo(programId: event.programId).fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(GetProgramInfoSuccessState(programInfo: right.data!.program!));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetProgramInfoErrorState(message: e.toString()));
    }
  }

  /// Update Diet Program =================================================================
  _onUpdateDietProgramInfo(
      UpdateProgramDietEvent event, Emitter<AccountState> emit) async {
    emit(UpdateDietProgramLoadingState());

    try {
      await _repository
          .updateDietProgramInfo(
        dietId: event.programId,
      )
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        if (right.success ?? false) {
          emit(UpdateDietProgramSuccessState(message: right.message ?? ''));
        } else {
          showToast(isSuccess: false, message: right.errorMessage.toString());
          emit(UpdateDietProgramErrorState(
              message: right.errorMessage.toString()));
        }
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(UpdateDietProgramErrorState(message: e.toString()));
    }
  }

  /// Get Profile Image =================================================================

  _onGetProfileImage(
      GetProfileImageEvent event, Emitter<AccountState> emit) async {
    emit(GetProfileImageLoadingState());

    try {
      await _repository.getProfileImage().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(GetProfileImageSuccessState(imageUrl: right.data?.imageUrl ?? ''));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetProfileImageErrorState(message: e.toString()));
    }
  }

  /// Get Profile Details =================================================================

  _onGetProfileDetails(
      GetProfileDetailsEvent event, Emitter<AccountState> emit) async {
    emit(GetProfileDetailsLoadingState());

    try {
      await _repository.getProfileDetails().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(GetProfileDetailsSuccessState(profileDetails: right.data));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetProfileDetailsErrorState(message: e.toString()));
    }
  }

  /// Update Profile Details =================================================================

  _onUpdateProfileDetails(
      UpdateProfileDetailsEvent event, Emitter<AccountState> emit) async {
    emit(UpdateProfileDetailsLoadingState());

    try {
      await _repository
          .updateProfileDetails(
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
        goal: event.goal,
        weight: event.weight,
        targetWeight: event.targetWeight,
        heightInCm: event.heightInCm,
        birthDate: event.birthDate,
        gender: event.gender,
      )
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        showToast(isSuccess: true, message: right.message.toString());
        emit(UpdateProfileDetailsSuccessState(profileDetails: right.data));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(UpdateProfileDetailsErrorState(message: e.toString()));
    }
  }

  /// Update Profile Image =================================================================

  _onUpdateProfileImage(
      UpdateProfileImageEvent event, Emitter<AccountState> emit) async {
    emit(UpdateProfileImageLoadingState());

    try {
      await _repository.updateProfileImage(imageFile: event.imageFile).fold(
          (left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        showToast(isSuccess: true, message: right.data.toString());
        emit(UpdateProfileImageSuccessState(profileDetails: null));
        add(GetProfileImageEvent());
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(UpdateProfileImageErrorState(message: e.toString()));
    }
  }

  /// Select Image from device =================================================================

  _onGetSelectedImagePath(
      GetSelectedImagePathEvent event, Emitter<AccountState> emit) async {
    emit(SelectedImagePathState(imgPath: event.imagePath));
  }

  /// Change password

  _onChangeProfilePassword(
      ChangeProfilePasswordEvent event, Emitter<AccountState> emit) async {
    emit(ChangePasswordLoadingState());

    try {
      await _repository
          .changeProfilePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
        email: event.email,
      )
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        if (right.success ?? false) {
          showToast(isSuccess: true, message: right.message.toString());
          emit(ChangePasswordSuccessState(message: right.message ?? ""));
        } else {
          showToast(isSuccess: false, message: right.errorMessage.toString());
          emit(
              ChangePasswordErrorState(message: right.errorMessage.toString()));
        }
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(ChangePasswordErrorState(message: e.toString()));
    }
  }

  /// Get Unit Info

  _onGetUnitInfo(GetUnitInfoEvent event, Emitter<AccountState> emit) async {
    emit(GetUnitInfoLoadingState());

    try {
      await _repository.getUnitInfo().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        if (right.success ?? false) {
          emit(GetUnitInfoSuccessState(unitData: right.data));
        } else {
          showToast(isSuccess: false, message: right.errorMessage.toString());
          emit(GetUnitInfoErrorState(message: right.errorMessage.toString()));
        }
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetUnitInfoErrorState(message: e.toString()));
    }
  }

  /// Update unit info

  _onUpdateUnitInfo(
      UpdateUnitInfoEvent event, Emitter<AccountState> emit) async {
    emit(UpdateUnitInfoLoadingState());

    try {
      await _repository
          .updateUnitInfo(
        unitId: event.unitId,
        weightType: event.weightType,
        heightType: event.heightType,
        energyType: event.energyType,
        waterType: event.waterType,
      )
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        if (right.success ?? false) {
          emit(UpdateUnitInfoSuccessState(message: right.message ?? ""));
        } else {
          showToast(isSuccess: false, message: right.errorMessage.toString());
          emit(
              UpdateUnitInfoErrorState(message: right.errorMessage.toString()));
        }
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(UpdateUnitInfoErrorState(message: e.toString()));
    }
  }

  onFailError({required String text, required Emitter<AccountState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(ErrorState());
  }
}
