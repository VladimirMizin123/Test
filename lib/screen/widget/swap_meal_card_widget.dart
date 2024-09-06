import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/swap_meal_model.dart';

class SwapMealCardWidget extends StatelessWidget {
  final SimilarMealData? similarMealData;
  final BuildContext context;
  final VoidCallback? onSkipMealTap;
  final VoidCallback? onSwapMealTap;
  final VoidCallback? onTap;
  final bool isCardSelected;
  const SwapMealCardWidget(
      {super.key,
      this.similarMealData,
      required this.context,
      this.onSkipMealTap,
      this.onSwapMealTap,
      this.onTap,
      this.isCardSelected = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: similarMealData!.isSelectedForSwap!
                  ? AppColors.middleGray
                  : Colors.transparent),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(0, 76, 99, 0.08),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // ClipRRect(borderRadius: BorderRadius.circular(12),
              //   child: Image.network(
              //     similarMealData!.mainImage!,
              //     height: 60.h,
              //     width: 70.w,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 80.h,
                  width: 90.w,
                  color: AppColors.lightGrey,
                  child: CachedNetworkImage(
                    imageUrl: similarMealData!.mainImage!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                      color: AppColors.lightGrey,
                    )),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(similarMealData!.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: FontUtils.h16(
                            fontColor: AppColors.darkGray,
                            fontWeight: FWT.regular)),
                    Text(
                        '${similarMealData!.nutrientsPerServing!.calories} cal',
                        style: FontUtils.h14(
                            fontColor: AppColors.letsEatButton,
                            fontWeight: FWT.lightMedium)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 24.h,
                width: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryBlue, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: (similarMealData!.isSelectedForSwap ?? false),
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryBlue),
                        height: 16.h,
                        width: 16.w,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
