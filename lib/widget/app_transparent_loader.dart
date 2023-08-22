import 'package:flutter/material.dart';

class AppTransparentLoader extends StatelessWidget {
  final Widget child;
  const AppTransparentLoader({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.5),
      child: Stack(
        children: [

        ],
      ),
    );
  }
}
