import 'package:flutter/material.dart';

extension ExtOnNumber on num {
  SizedBox get height => SizedBox(height: toDouble());
  SizedBox get width => SizedBox(width: toDouble());

  String formatAmount() {
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String mathFunc(Match match) => '${match[1]},';

    return "$this".replaceAllMapped(reg, mathFunc);
  }
}
