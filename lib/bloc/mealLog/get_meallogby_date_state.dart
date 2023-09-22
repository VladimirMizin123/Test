import '../../models/get_meallogby_date_model.dart';

abstract class GetMealLogByDateState {}

class GetMealLogByDateInitial extends GetMealLogByDateState {}

class LoadGetMealLogByDateData extends GetMealLogByDateState {
  GetMealLogByDate modelData;

  LoadGetMealLogByDateData({required this.modelData});
}

class ErrorByDateStateData extends GetMealLogByDateState {
  String errMessage;
  ErrorByDateStateData({required this.errMessage});
}
