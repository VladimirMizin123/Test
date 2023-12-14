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

class UpdateExerciseEvent extends AddWaterEvent {
  final String? id;
  final String? exerciseName;
  final int? workOutTime;
  final int? calorieBurned;
  final String? userId;

  UpdateExerciseEvent({
    this.id,
    this.exerciseName,
    this.workOutTime,
    this.calorieBurned,
    this.userId,
  });
}

class DeleteExerciseEvent extends AddWaterEvent {
  final String? exerciseName;

  DeleteExerciseEvent({
    this.exerciseName,
  });
}
