import 'package:gymeats_mobile/screen/account_screen/model/get_all_programs_model.dart'
    as gapm;
import 'package:gymeats_mobile/screen/account_screen/model/programs_info_model.dart'
    as pim;

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
