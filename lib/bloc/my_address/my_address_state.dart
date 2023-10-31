abstract class MyAddressState {}

// class InitialState extends MyAddressState {}

class RadioClickState extends MyAddressState {
  final String? selectedState;

  RadioClickState({this.selectedState = 'Home'});
}
