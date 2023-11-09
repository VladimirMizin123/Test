import 'dart:io';

import 'package:gymeats_mobile/screen/account_screen/model/get_all_programs_model.dart'
    as gapm;
import 'package:gymeats_mobile/screen/account_screen/model/get_current_program_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/get_profile_details_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/get_unit_info_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/programs_info_model.dart'
    as pim;
import 'package:gymeats_mobile/screen/account_screen/model/update_profile_details_model.dart';

abstract class AccountState {}

class InitialState extends AccountState {}

class ErrorState extends AccountState {}

/// Get All Program State ===============================================================

class GetAllProgramSuccessState extends AccountState {
  final List<gapm.ProgramModel> programModelData;

  GetAllProgramSuccessState({required this.programModelData});
}

class GetAllProgramLoadingState extends AccountState {}

class GetAllProgramErrorState extends AccountState {
  final String message;
  GetAllProgramErrorState({required this.message});
}

/// Get Current Program State ===============================================================

class GetCurrentProgramSuccessState extends AccountState {
  final MyProgram myProgram;

  GetCurrentProgramSuccessState({required this.myProgram});
}

class GetCurrentProgramLoadingState extends AccountState {}

class GetCurrentProgramErrorState extends AccountState {
  final String message;
  GetCurrentProgramErrorState({required this.message});
}

/// Get All Program State ===============================================================

class GetProgramInfoSuccessState extends AccountState {
  final pim.ProgramInfo programInfo;

  GetProgramInfoSuccessState({required this.programInfo});
}

class GetProgramInfoLoadingState extends AccountState {}

class GetProgramInfoErrorState extends AccountState {
  final String message;
  GetProgramInfoErrorState({required this.message});
}

/// Update Diet Program State ===============================================================

class UpdateDietProgramSuccessState extends AccountState {
  final String message;

  UpdateDietProgramSuccessState({required this.message});
}

class UpdateDietProgramLoadingState extends AccountState {}

class UpdateDietProgramErrorState extends AccountState {
  final String message;
  UpdateDietProgramErrorState({required this.message});
}

/// Get Profile Image State ===============================================================

class GetProfileImageSuccessState extends AccountState {
  final String? imageUrl;

  GetProfileImageSuccessState({required this.imageUrl});
}

class GetProfileImageLoadingState extends AccountState {}

class GetProfileImageErrorState extends AccountState {
  final String message;
  GetProfileImageErrorState({required this.message});
}

/// Get Profile Details State ===============================================================

class GetProfileDetailsSuccessState extends AccountState {
  final ProfileDetails? profileDetails;

  GetProfileDetailsSuccessState({required this.profileDetails});
}

class GetProfileDetailsLoadingState extends AccountState {}

class GetProfileDetailsErrorState extends AccountState {
  final String message;
  GetProfileDetailsErrorState({required this.message});
}

/// Update Profile Details State ===============================================================

class UpdateProfileDetailsSuccessState extends AccountState {
  final UpdatedProfileDetails? profileDetails;

  UpdateProfileDetailsSuccessState({required this.profileDetails});
}

class UpdateProfileDetailsLoadingState extends AccountState {}

class UpdateProfileDetailsErrorState extends AccountState {
  final String message;
  UpdateProfileDetailsErrorState({required this.message});
}

/// Update Profile Image State ===============================================================

class UpdateProfileImageSuccessState extends AccountState {
  final UpdatedProfileDetails? profileDetails;

  UpdateProfileImageSuccessState({required this.profileDetails});
}

class UpdateProfileImageLoadingState extends AccountState {}

class UpdateProfileImageErrorState extends AccountState {
  final String message;
  UpdateProfileImageErrorState({required this.message});
}

///SELECT IMAGE FOR Profile ===============================================================

class SelectedImagePathState extends AccountState {
  final File? imgPath;

  SelectedImagePathState({required this.imgPath});
}

/// Change Password State ===============================================================

class ChangePasswordSuccessState extends AccountState {
  final String message;

  ChangePasswordSuccessState({required this.message});
}

class ChangePasswordLoadingState extends AccountState {}

class ChangePasswordErrorState extends AccountState {
  final String message;
  ChangePasswordErrorState({required this.message});
}

/// Get Unit info State ===============================================================

class GetUnitInfoSuccessState extends AccountState {
  final UnitData? unitData;

  GetUnitInfoSuccessState({required this.unitData});
}

class GetUnitInfoLoadingState extends AccountState {}

class GetUnitInfoErrorState extends AccountState {
  final String message;
  GetUnitInfoErrorState({required this.message});
}

/// Update Unit info State ===============================================================

class UpdateUnitInfoSuccessState extends AccountState {
  final String message;

  UpdateUnitInfoSuccessState({required this.message});
}

class UpdateUnitInfoLoadingState extends AccountState {}

class UpdateUnitInfoErrorState extends AccountState {
  final String message;
  UpdateUnitInfoErrorState({required this.message});
}
