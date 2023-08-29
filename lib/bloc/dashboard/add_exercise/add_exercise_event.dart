abstract class AddWaterEvent {}

class SaveClickEvent extends AddWaterEvent {
  final String caloriesBurned;
  final String exerciseName;
  final String userId;
  final String workoutTime;
  final String createdBy;

  SaveClickEvent({
    required this.caloriesBurned,
    required this.exerciseName,
    required this.userId,
    required this.workoutTime,
    required this.createdBy,
  });
}
