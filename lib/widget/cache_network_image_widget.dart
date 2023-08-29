import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  final String imgURL;
  const CachedNetworkImageWidget({super.key, required this.imgURL});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imgURL,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
        color: AppColors.lightGrey,
      )),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
