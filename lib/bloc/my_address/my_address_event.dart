abstract class MyAddressEvent {}

class MyAddressLoadEvent extends MyAddressEvent {
  final String? firstOption;
  MyAddressLoadEvent({this.firstOption});
}
