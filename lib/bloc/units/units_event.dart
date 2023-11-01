abstract class UnitsEvent {}

class UnitsLoadEvent extends UnitsEvent {
  final String? selectedOption;

  UnitsLoadEvent({
    this.selectedOption,
  });
}
