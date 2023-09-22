abstract class GetMealLogByDateEvent {}

class GetMealLogByDateData extends GetMealLogByDateEvent {
  String date;
  GetMealLogByDateData({required this.date});
}
