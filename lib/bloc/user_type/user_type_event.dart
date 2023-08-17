abstract class UserTypeEvent{}

class UserTypeClickEvent extends UserTypeEvent{
 final bool isMale;
 final bool isFemale;
 final bool isNon;
  UserTypeClickEvent({required this.isNon, required this.isFemale, required this.isMale});
}

class TextChangeEvent extends UserTypeEvent{
 final String age;
 final String height;
 final String weight;
 TextChangeEvent({required this.age, required this.height, required this.weight});
}