class ApiUrls {
  static const String baseUrl = 'https://gymeats.azurewebsites.net/';
  static const String apiKey = 'peONDsofens8dfs6sfYi4RvtTwlEXpQBwo==';
  static const String login = '${baseUrl}api/Auth/login';
  static const String register = '${baseUrl}api/Auth/signup-form';
  // static const String register = '${baseUrl}api/Auth/register';
  static const String genMealPlan = '${baseUrl}api/Suggestic/GenMealPlan';
  static const String getMealPlan = '${baseUrl}api/Suggestic/GetMealPlan';
  static const String skipMeal = '${baseUrl}api/Suggestic/SkipMeal';
  static const String addToShoppingList = '${baseUrl}api/Suggestic/AddToShoppingList';
  static const String getSwapMeal = '${baseUrl}api/Suggestic/GetSwapMeal';
  static const String getRecipeDetailById = '${baseUrl}api/Suggestic/GetRecipeDetailById';
  static const String productRestaurantSearch = '${baseUrl}api/MealMe/product-restaurantSearch-byName';
  static const String requestPass = '${baseUrl}api/Auth/request-pass';
  static const String resetPass = '${baseUrl}api/Auth/reset-pass';
  static const String getSurvey = '${baseUrl}api/Survey/GetSurvey';

  //Grocery Flow
  static const String addGroceryToShoppingListFromSuggestic = '${baseUrl}api/MealMe/AddGroceryToShoppingListFromSuggestic';
  static const String getShoppingList = '${baseUrl}api/ShoppingList/GetShoppingList';
  static const String addItemShoppingList = '${baseUrl}api/ShoppingList/AddItemShoppingList';

  //For dashboard use apis
  static const String getDashboardData = '${baseUrl}api/Dashboard/GetDashboardData';
  static const String getTotalIntakeWater = '${baseUrl}api/Dashboard/GetTotalIntakeWater';
  static const String getTotalCaloriesBurnedByExercise = '${baseUrl}api/Dashboard/GetTotalCaloriesBurnedByExercise';
  static const String addExercise = '${baseUrl}api/Dashboard/AddExercise';
  static const String addWater = '${baseUrl}api/Dashboard/AddWater';
  static const String addEatenMeal = '${baseUrl}api/Suggestic/AddEatenMeal';
  static const String getMealTrackerData = '${baseUrl}api/Suggestic/GetMealTrackerData';

  //For journal use apis
  static const String getUserJournalData = '${baseUrl}api/Dashboard/GetUserJournalData';
  static const String getWaterLogDetails = '${baseUrl}api/Dashboard/GetWaterLogDetails';
  static const String getExerciseLogDetails = '${baseUrl}api/Dashboard/GetExerciseLogDetails';
}
