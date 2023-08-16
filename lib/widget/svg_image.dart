import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgImage extends StatelessWidget {
  final String image;
  final BoxFit fit;

  const SvgImage({super.key, required this.image, this.fit = BoxFit.fill});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      image,
      fit: fit,
    );
  }
}
