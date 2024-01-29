import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    super.key,
    required this.url,
    this.height,
    this.width,
  });
  final String url;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: BoxFit.contain,
      errorWidget: (context, url, error) =>
          const Center(child: Icon(Icons.error)),
      placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
        color: AppColors.lightGrey,
      )),
    );
  }
}
