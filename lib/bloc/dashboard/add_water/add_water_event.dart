abstract class AddWaterEvent {}

class SaveClickEvent extends AddWaterEvent {
  final String waterML;
  SaveClickEvent({required this.waterML});
}

class UpdateWaterEvent extends AddWaterEvent {
  final String waterML;
  UpdateWaterEvent({required this.waterML});
}
