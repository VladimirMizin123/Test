abstract class UnitsState {}

class InitialUnitState extends UnitsState {}

class RadioOnTapState extends UnitsState {
  final String? selectedState;

  RadioOnTapState({this.selectedState});
}
