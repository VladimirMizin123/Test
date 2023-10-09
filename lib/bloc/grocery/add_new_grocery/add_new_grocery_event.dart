abstract class AddNewGroceryItemEvent {}

class AddNewGroceryItem extends AddNewGroceryItemEvent {
  final String userId;
  final List<Map<String, dynamic>> groceryItems;

  // final String itemName;
  // final int quantity;
  // final String measurementType;
  // final String measurementValue;

  AddNewGroceryItem({required this.userId, required this.groceryItems
      // required this.quantity,
      // required this.measurementType,
      // required this.measurementValue,
      // required this.userId,
      });
}

class GetGroceryItemEvent extends AddNewGroceryItemEvent {}

class RemoveGroceryItemEvent extends AddNewGroceryItemEvent {
  final String? userGroceryListId;

  RemoveGroceryItemEvent({required this.userGroceryListId});
}
