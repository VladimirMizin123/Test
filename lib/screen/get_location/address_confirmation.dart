import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/models/add_address_data_navigate_model.dart';
import 'package:gymeats_mobile/models/sign_up_data_navigate_model.dart';
import 'package:gymeats_mobile/screen/dashboard/dashboard_screen.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';

class AddressConfirmation extends StatefulWidget {
  const AddressConfirmation(
      {super.key, required this.locationData, required this.arguments});
  final dynamic locationData;
  final dynamic arguments;

  @override
  State<AddressConfirmation> createState() => _AddressConfirmationState();
}

class _AddressConfirmationState extends State<AddressConfirmation> {
  TextEditingController streetName = TextEditingController();
  TextEditingController apartmentName = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zipName = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    streetName.text = widget.locationData['street_Name'] ?? '';
    apartmentName.text = widget.locationData['street_Num'] ?? '';
    city.text = widget.locationData['city'] ?? '';
    zipName.text = widget.locationData['zipcode'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Column(
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.h, top: 20.h),
                      child: Text('Street',
                          style: TextStyle(
                              color: const Color(0xff373737),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w300)),
                    ),
                    commonTextField(
                        controller: streetName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Street Name';
                          } else {
                            return null;
                          }
                        }),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.h, top: 10.h),
                      child: Text('Apartment number',
                          style: TextStyle(
                              color: const Color(0xff373737),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w300)),
                    ),
                    commonTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Apartment number';
                        } else {
                          return null;
                        }
                      },
                      controller: apartmentName,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.h, top: 10.h),
                      child: Text('City',
                          style: TextStyle(
                              color: const Color(0xff373737),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w300)),
                    ),
                    commonTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter City Name';
                        } else {
                          return null;
                        }
                      },
                      controller: city,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.h, top: 10.h),
                      child: Text(
                        'Zip',
                        style: TextStyle(
                            color: const Color(0xff373737),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    commonTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Zip Code';
                        } else {
                          return null;
                        }
                      },
                      controller: zipName,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                if (formKey.currentState!.validate()) {
                  if (widget.arguments['string'] == 'isFromRegister') {
                    AddAddressModel addAddressModel = AddAddressModel();
                    addAddressModel.latitude = widget.locationData['latitude'];
                    addAddressModel.longitude =
                        widget.locationData['longitude'];
                    addAddressModel.streetNum =
                        widget.locationData['street_Num'];
                    addAddressModel.streetName =
                        widget.locationData['street_Name'];
                    addAddressModel.city = widget.locationData['city'];
                    addAddressModel.state = widget.locationData['state'];
                    addAddressModel.country = widget.locationData['country'];
                    addAddressModel.addressType =
                        widget.locationData['addressType'];
                    addAddressModel.zipcode = widget.locationData['zipcode'];
                    addAddressModel.isPrimary = false;

                    UserSignUpDataModel userData = UserSignUpDataModel(
                      firstName: widget.arguments['userData'].firstName,
                      lastName: widget.arguments['userData'].lastName,
                      email: widget.arguments['userData'].email,
                      password: widget.arguments['userData'].password,
                      userName: widget.arguments['userData'].email,
                      confirmPassword:
                          widget.arguments['userData'].confirmPassword,
                    );

                    userData.addAddressModel = addAddressModel;

                    Get.toNamed('/PremiumScreen', arguments: userData);
                  } else {
                    Get.offAllNamed('/AppManagerScreen');
                  }
                }
              },
              child: Container(
                height: 48.h,
                margin: EdgeInsets.only(
                    top: 0.h, bottom: 40.h, right: 20.w, left: 20.w),
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
    );
  }

  Widget commonTextField(
      {String? Function(String?)? validator,
      TextEditingController? controller}) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10.w),
        hintText: '',
        hintStyle: TextStyle(
          color: const Color(0xff5F5F5F),
          fontWeight: FontWeight.w300,
          fontSize: 14.sp,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.w,
          ),
        ),
        errorStyle: const TextStyle(color: Colors.red),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: const Color(0xffC7C8CA),
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: const Color(0xffC7C8CA),
            width: 1.w,
          ),
        ),
      ),
    );
  }
}
