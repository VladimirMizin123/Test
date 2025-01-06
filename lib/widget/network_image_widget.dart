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
    this.placeholder,
    this.height,
    this.width,
    this.showLoader = true,
    this.fit,
    this.showSizedBox = false,
  });
  final String url;
  final String? placeholder;
  final double? height;
  final double? width;
  final bool showLoader;
  final BoxFit? fit;
  final bool showSizedBox;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      cacheKey: url,
      errorWidget: (context, url, error) => showSizedBox
          ? SizedBox.shrink()
          : placeholder != null
              ? placeholder!.contains("svg")
                  ? SvgPicture.asset(
                      placeholder!,
                      color: AppColors.green,
                    )
                  : Image.asset(
                      placeholder!,
                      height: height,
                      width: width,
                    )
              : SvgPicture.asset(
                  AssetsUtils.gymEatsLogoRound,
                  color: AppColors.green,
                ),
      placeholder: (context, url) => showLoader
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.lightGrey,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
