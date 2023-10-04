import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/screen/dashboard/dashboard_screen.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';

class AddressConfirmation extends StatefulWidget {
  const AddressConfirmation({super.key, required this.locationData});
  final dynamic locationData;

  @override
  State<AddressConfirmation> createState() => _AddressConfirmationState();
}

class _AddressConfirmationState extends State<AddressConfirmation> {
  TextEditingController streetName = TextEditingController();
  TextEditingController apartmentName = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zipName = TextEditingController();

  @override
  void initState() {
    super.initState();

    print('-0----->>>>${widget.locationData}');

    streetName.text = widget.locationData['street_Name'] ?? '';
    apartmentName.text = widget.locationData['street_Num'] ?? '';
    city.text = widget.locationData['city'] ?? '';
    zipName.text = widget.locationData['zipcode'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 8.h,
            ),
            Center(
              child: Image.asset(
                AssetsUtils.gymEatsSpoon,
                height: 22.h,
                width: 56.w,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 8.h),
              child: Row(
                children: [
                  const BackButtonWidget(),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    'Add delivery address',
                    style: TextStyle(
                      color: const Color(0xff010101),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Avenir',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Text('Street',
                        style: TextStyle(
                            color: const Color(0xff373737),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300)),
                    Container(
                      height: 48.h,
                      margin: EdgeInsets.only(top: 4.h, bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: const Color(0xffC7C8CA), width: 1.w),
                      ),
                      child: TextFormField(
                        controller: streetName,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10.w),
                          hintText: '',
                          hintStyle: TextStyle(
                            color: const Color(0xff5F5F5F),
                            fontWeight: FontWeight.w300,
                            fontSize: 14.sp,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    Text('Apartment number ',
                        style: TextStyle(
                            color: const Color(0xff373737),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300)),
                    Container(
                      height: 48.h,
                      margin: EdgeInsets.only(top: 4.h, bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: const Color(0xffC7C8CA), width: 1.w),
                      ),
                      child: TextFormField(
                        controller: apartmentName,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10.w),
                          hintText: '',
                          hintStyle: TextStyle(
                            color: const Color(0xff5F5F5F),
                            fontWeight: FontWeight.w300,
                            fontSize: 14.sp,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    Text('City',
                        style: TextStyle(
                            color: const Color(0xff373737),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300)),
                    Container(
                      height: 48.h,
                      margin: EdgeInsets.only(top: 4.h, bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: const Color(0xffC7C8CA), width: 1.w),
                      ),
                      child: TextFormField(
                        controller: city,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10.w),
                          hintText: '',
                          hintStyle: TextStyle(
                            color: const Color(0xff5F5F5F),
                            fontWeight: FontWeight.w300,
                            fontSize: 14.sp,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    Text('Zip',
                        style: TextStyle(
                            color: const Color(0xff373737),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300)),
                    Container(
                      height: 48.h,
                      margin: EdgeInsets.only(top: 4.h, bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: const Color(0xffC7C8CA), width: 1.w),
                      ),
                      child: TextFormField(
                        controller: zipName,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10.w),
                          hintText: '',
                          hintStyle: TextStyle(
                            color: const Color(0xff5F5F5F),
                            fontWeight: FontWeight.w300,
                            fontSize: 14.sp,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.offAll(() => const DashBoardScreen());
                      },
                      child: Container(
                        height: 48.h,
                        margin: EdgeInsets.only(top: 0.h, bottom: 40.h),
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: const Color(0xffCE6B53),
                        ),
                        child: Center(
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Avenir',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
