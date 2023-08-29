import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';

class BestMatchRestaurantsScreen extends StatefulWidget {
  const BestMatchRestaurantsScreen({super.key});

  @override
  State<BestMatchRestaurantsScreen> createState() => _BestMatchRestaurantsScreenState();
}

class _BestMatchRestaurantsScreenState extends State<BestMatchRestaurantsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          const GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(21.2408, 72.8806),
              zoom: 15,
            ),
          ),
          const Positioned(top: 40,left: 15, child: Icon(Icons.keyboard_arrow_left_sharp,color: AppColors.darkGray,size: 40)),
          DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.2,
              maxChildSize: 0.7,
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  color: AppColors.whiteColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 3.h,
                              width: 80.w,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.disable),
                            )),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'See Best Matches',
                            style: FontUtils.h22(fontColor: AppColors.darkGray, fontWeight: FWT.bold),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: 25,
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: Image.asset(
                                                  AssetsUtils.defaultImage,
                                                  height: screenSize.height * 0.25,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 12, left: 12),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: AppColors.whiteColor,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                        child: Text(
                                                          'Free delivery',
                                                          style: FontUtils.h12(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: AppColors.whiteColor,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                        child: Text(
                                                          '-10% off',
                                                          style: FontUtils.h12(fontColor: AppColors.terracotta, fontWeight: FWT.semiBold),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 12, left: 12),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: AppColors.whiteColor,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                        child: Text(
                                                          'Free delivery',
                                                          style: FontUtils.h12(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: AppColors.whiteColor,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                        child: Text(
                                                          '-10% off',
                                                          style: FontUtils.h12(fontColor: AppColors.terracotta, fontWeight: FWT.semiBold),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                right: 12,
                                                bottom: 12,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.whiteColor,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(AssetsUtils.icThumbUpLine),
                                                        const SizedBox(width: 5),
                                                        Text(
                                                          '95%',
                                                          style: FontUtils.h16(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Text(
                                                          '(145)',
                                                          style: FontUtils.h14(fontColor: AppColors.disable, fontWeight: FWT.light),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('GaGa', overflow: TextOverflow.ellipsis, maxLines: 2, style: FontUtils.h18(fontColor: AppColors.darkGray, fontWeight: FWT.semiBold)),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.lightGrey,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                  child: Text(
                                                    'Italian',
                                                    style: FontUtils.h14(fontColor: AppColors.black, fontWeight: FWT.regular),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(AssetsUtils.icScooter),
                                              const SizedBox(width: 10),
                                              Text('\$ 20.99', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                              const SizedBox(width: 10),
                                              const CircleAvatar(maxRadius: 3, backgroundColor: AppColors.darkGray),
                                              const SizedBox(width: 10),
                                              Text('15-25 min', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
