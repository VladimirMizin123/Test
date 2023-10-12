abstract class AddNewGroceryItemEvent {}

/// Add Grocery Event ===============================================================
class AddNewGroceryItem extends AddNewGroceryItemEvent {
  final String userId;
  final String? id;
  final List<Map<String, dynamic>> groceryItems;

  AddNewGroceryItem({
    required this.userId,
    required this.groceryItems,
    this.id,
  });
}

/// Update Add Grocery Event ===============================================================
class UpdateAddNewGroceryItem extends AddNewGroceryItemEvent {
  final String userId;
  final String id;
  final String itemName;
  final int quantity;
  final String measurementType;
  final String measurementValue;

  UpdateAddNewGroceryItem({
    required this.userId,
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.measurementType,
    required this.measurementValue,
  });
}

/// Update Remove Grocery Event ===============================================================
class UpdateRemoveNewGroceryItem extends AddNewGroceryItemEvent {
  final String userId;
  final String id;
  final String itemName;
  final int quantity;
  final String measurementType;
  final String measurementValue;

  UpdateRemoveNewGroceryItem({
    required this.userId,
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.measurementType,
    required this.measurementValue,
  });
}

/// Get Grocery Event ===============================================================
class GetGroceryItemEvent extends AddNewGroceryItemEvent {}

/// Remove Grocery Item Event ===============================================================
class RemoveGroceryItemEvent extends AddNewGroceryItemEvent {
  final String? userGroceryListId;

  RemoveGroceryItemEvent({required this.userGroceryListId});
}

/// Clear Grocery Event ===============================================================
class ClearGroceryEvent extends AddNewGroceryItemEvent {}
