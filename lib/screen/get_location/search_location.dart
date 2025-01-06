import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/models/search_address_model.dart';
import 'package:gymeats_mobile/repository/google_map_searching.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  FocusNode searchTextFocus = FocusNode();
  TextEditingController searchTextController = TextEditingController();
  final GoogleMapSearchRepository _googleMapSearchRepository =
      GoogleMapSearchRepository();
  List<Prediction> searchList = [];
  Timer? _debounce;
  LatLng? selectedLatLng;
  Future<void> searchLocation(String value) async {
    await _googleMapSearchRepository.searchLocation(value).fold((left) {
      showToast(isSuccess: false, message: left.errorMessage ?? "");
    }, (right) {
      // showToast(isSuccess: true, message: right.message!);
      SearchAddressResponseModel(
        predictions: right.predictions,
        status: right.status,
      );

      searchList = right.predictions ?? [];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                AssetsUtils.gymEatsSpoon,
                height: 20.h,
                width: 56.w,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),
                Text('Search delivery address',
                    style: FontUtils.h20(fontColor: AppColors.oxFF010101)),
                const SizedBox.shrink(),
              ],
            ).paddingSymmetric(horizontal: 15, vertical: 5.h),

            ///SearchBar==========================================

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                height: 48.h,
                margin: EdgeInsets.only(top: 22.h, bottom: 22.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xff004C63).withOpacity(0.08),
                        offset: const Offset(0, 0),
                        spreadRadius: 0,
                        blurRadius: 16)
                  ],
                ),
                child: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: searchTextController,
                  focusNode: searchTextFocus,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: const Color(0xff5F5F5F),
                      fontWeight: FontWeight.w300,
                      fontSize: 14.sp,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(14.h),
                      child: Image.asset(
                        AssetsUtils.searchIcon,
                        height: 20.h,
                        width: 20.w,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) {
                      _debounce?.cancel();
                    }
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      searchLocation(value);
                    });
                  },
                ),
              ),
            ),

            Expanded(
              child: searchList.isNotEmpty
                  ? ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      physics: const BouncingScrollPhysics(),
                      itemCount: searchList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            searchTextController.text =
                                searchList[index].description ?? '';

                            searchTextFocus.unfocus();
                            Navigator.pop(context, searchList[index]);
                            print(
                                'description=====>${searchList[index].description}');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Text(searchList[index].description ?? "",
                                style: const TextStyle(color: Colors.black)),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    )
                  : Center(
                      child: Text(
                        'No Search Address',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: '',
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
