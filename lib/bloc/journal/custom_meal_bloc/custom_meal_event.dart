import 'dart:io';

abstract class AddNewMealEvent {}

class GetSelectedImagePath extends AddNewMealEvent {
  final File? imagePath;
  GetSelectedImagePath({required this.imagePath});
}

class AddNewMeal extends AddNewMealEvent {
  final String name;
  final File? imageUrl;
  final String protein;
  final String fat;
  final String carbs;
  final String calorie;
  final String type;
  final String userId;
  final String quantity;
  final String? id;

  AddNewMeal({
    required this.name,
    this.imageUrl,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.calorie,
    required this.type,
    required this.userId,
    required this.quantity,
    this.id,
  });
}

/// Get Grocery Event ===============================================================
class GetCustomListEvent extends AddNewMealEvent {}
