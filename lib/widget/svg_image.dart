import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgImage extends StatelessWidget {
  final String image;
  final BoxFit fit;
  final Color color;

  const SvgImage({super.key, required this.image, this.fit = BoxFit.fill,this.color = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return color == Colors.transparent ? SvgPicture.asset(
      image,
      fit: fit,

    ):SvgPicture.asset(
      image,
      fit: fit,
      colorFilter:  ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
