abstract class ProfileEvent {}

class ShowDateEvent extends ProfileEvent {}

class ClickDateEvent extends ProfileEvent {
  String? date;
  ClickDateEvent({this.date});

  _onClickDate() {}
}
