//convert weight gram to pound

String? weightQuantity;
String? weightGramToPound({num? textValue, int? weightValue}) {
  num? value =
      weightValue == 1 ? ((textValue ?? 0) * 0.00220462) : (textValue ?? 0);
  weightQuantity =
      weightValue == 1 ? value.toStringAsFixed(2).toString() : value.toString();
  return weightQuantity;
}
