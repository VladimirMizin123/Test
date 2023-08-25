
abstract class GetDashboardState{}

class InitialState extends GetDashboardState{}

class LoadSurveyData extends GetDashboardState{
  bool isAPIData;
  LoadSurveyData({ this.isAPIData = false});
}
class ErrorStateData extends GetDashboardState{
  String errMessage;
  ErrorStateData({required this.errMessage});
}

class LoadingSurveyData extends GetDashboardState{}
class NextScreenState extends GetDashboardState{
  String dietId;
  NextScreenState({required this.dietId});
}
