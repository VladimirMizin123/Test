
abstract class AddWaterEvent {}

class SaveClickEvent extends AddWaterEvent {
  final String waterML;
  SaveClickEvent({required this.waterML});
}
