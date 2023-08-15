import 'package:flutter/material.dart';

class BinaryScreen extends StatefulWidget {
  const BinaryScreen({super.key});

  @override
  State<BinaryScreen> createState() => _BinaryScreenState();
}

class _BinaryScreenState extends State<BinaryScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height.h,
      ),
    );
  }
}
