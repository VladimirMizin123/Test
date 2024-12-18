class CardRequestModel {
  final String? id;
  final String name;
  final String number;
  final int expMonth;
  final int expYear;
  final String cvc;
  final String addressCity;
  final String addressLine1;
  final String addressLine2;
  final String addressState;
  final String addressCountry;
  final String addressZip;

  CardRequestModel({
    required this.id,
    required this.name,
    required this.number,
    required this.expMonth,
    required this.expYear,
    required this.cvc,
    required this.addressCity,
    required this.addressLine1,
    required this.addressLine2,
    required this.addressState,
    required this.addressCountry,
    required this.addressZip,
  });
}
