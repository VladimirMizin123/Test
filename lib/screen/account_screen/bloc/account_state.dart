import 'package:gymeats_mobile/screen/account_screen/model/get_all_programs_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/programs_info_model.dart';

abstract class AccountState {}

class InitialState extends AccountState {}

class ErrorState extends AccountState {}

/// Get All Program State ===============================================================

class GetAllProgramSuccessState extends AccountState {
  final List<ProgramModel> programModelData;

  GetAllProgramSuccessState({required this.programModelData});
}

class GetAllProgramLoadingState extends AccountState {}

class GetAllProgramErrorState extends AccountState {
  final String message;
  GetAllProgramErrorState({required this.message});
}

/// Get All Program State ===============================================================

class GetProgramInfoSuccessState extends AccountState {
  final ProgramInfo programInfo;

  GetProgramInfoSuccessState({required this.programInfo});
}

class GetProgramInfoLoadingState extends AccountState {}

class GetProgramInfoErrorState extends AccountState {
  final String message;
  GetProgramInfoErrorState({required this.message});
}
