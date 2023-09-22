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
  final String? calorieBurnedPerMinute;

  UpdateExerciseEvent({
    this.id,
    this.calorieBurnedPerMinute,
    this.exerciseName,
  });
}

class DeleteExerciseEvent extends AddWaterEvent {
  final String? exerciseName;

  DeleteExerciseEvent({
    this.exerciseName,
  });
}
