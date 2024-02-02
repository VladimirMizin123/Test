// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.fit,
  });
  final String url;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      errorWidget: (context, url, error) => SvgPicture.asset(
        AssetsUtils.gymEatsLogoRound,
        color: AppColors.green,
      ),
      placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
        color: AppColors.lightGrey,
      )),
    );
  }
}
