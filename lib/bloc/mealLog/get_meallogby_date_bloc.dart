import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/get_meallogby_date_model.dart';
import '../../repository/get_dashboard.dart';
import 'get_meallogby_date_event.dart';
import 'get_meallogby_date_state.dart';

class GetMealLogByDateBloc
    extends Bloc<GetMealLogByDateEvent, GetMealLogByDateState> {
  GetMealLogByDateBloc() : super(GetMealLogByDateInitial()) {
    on<GetMealLogByDateData>(_onGetMealLogByDate);
  }

  final GetDashboardDataRepository _dashboardRepository =
      GetDashboardDataRepository();

  _onGetMealLogByDate(
      GetMealLogByDateData event, Emitter<GetMealLogByDateState> emit) async {
    try {
      final response = await _dashboardRepository.getMealLogByDate(event.date);
      print('response3434343434 : $response');
      response.fold((left) {
        emit(ErrorByDateStateData(errMessage: left.errorMessage!));
        emit(LoadGetMealLogByDateData(modelData: GetMealLogByDate(
          data: [],
        )));
      }, (right) {
        emit(LoadGetMealLogByDateData(modelData: right));
      });
    } catch (e) {
      emit(ErrorByDateStateData(errMessage: e.toString()));
    }
  }
}
