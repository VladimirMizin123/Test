import 'dart:ui';

class GetSurveyModel{
  String question;
  List<Options> options;
  GetSurveyModel({required this.options, required this.question});
}

class Options {
  String label;
  Color color;
  bool isSelect;
  Options({required this.color, required this.label, required this.isSelect});
}