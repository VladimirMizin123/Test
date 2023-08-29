class ApiUrls{
  static const String baseUrl = 'https://gymeats.azurewebsites.net/';
  static const String apiKey = 'peONDsofens8dfs6sfYi4RvtTwlEXpQBwo==';
  static const String login = '${baseUrl}api/Auth/login';
  static const String register = '${baseUrl}api/Auth/signup-form';
  // static const String register = '${baseUrl}api/Auth/register';
  static const String genMealPlan = '${baseUrl}api/Suggestic/GenMealPlan';
  static const String getMealPlan = '${baseUrl}api/Suggestic/GetMealPlan';
  static const String skipMeal = '${baseUrl}api/Suggestic/SkipMeal';
  static const String requestPass = '${baseUrl}api/Auth/request-pass';
  static const String resetPass = '${baseUrl}api/Auth/reset-pass';
  static const String getSurvey = '${baseUrl}api/Survey/GetSurvey';
  static const String getDashboardData = '${baseUrl}api/Dashboard/GetDashboardData';
}