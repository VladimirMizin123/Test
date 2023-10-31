import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/repository/get_account_details.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_event.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_state.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(InitialState()) {
    on<GetAllProgramEvent>(_onGetAllProgram);
    on<GetProgramInfoEvent>(_onGetProgramInfo);
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

  onFailError({required String text, required Emitter<AccountState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(ErrorState());
  }
}
