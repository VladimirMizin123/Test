// water convert oz to milli

String? waterQuantity;

String? convertMilliToOz({num? textValue, isWatervalue}) {
  int? isWater = isWatervalue;
  num? value = isWater == 1 ? ((textValue ?? 0) * 0.033814) : (textValue ?? 0);
  return waterQuantity =
      isWater == 1 ? value.toStringAsFixed(2).toString() : value.toString();
}
