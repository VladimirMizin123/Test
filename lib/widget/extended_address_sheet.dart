import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/screen/account_screen/map_address/map_address_screen_widget.dart';
import 'package:gymeats_mobile/screen/account_screen/profile/profile_screen_widget.dart';

class ExtendedAddress extends StatefulWidget {
  const ExtendedAddress({
    super.key,
    this.fromSignup = false,
  });
  final bool fromSignup;

  @override
  State<ExtendedAddress> createState() => _ExtendedAddressState();
}

class _ExtendedAddressState extends State<ExtendedAddress> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController sName = TextEditingController();
  TextEditingController sNumber = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        height: context.height * 0.9,
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.only(
                left: 22,
                right: 22,
                top: 10,
                bottom: 10 + MediaQuery.of(context).viewInsets.bottom),
            children: [
              10.height,
              labelWidget(
                text:
                    "Please provide your address. We are unable to find your address.",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.w400,
                ),
              ),
              mapDetailWidget(
                title: "Street Name",
                hintText: "Name",
                textEditingController: sName,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Street details';
                  } else {
                    return null;
                  }
                },
              ),
              mapDetailWidget(
                title: "Street Number",
                hintText: "Enter your street number",
                textEditingController: sNumber,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Street Number';
                  } else {
                    return null;
                  }
                },
              ),
              mapDetailWidget(
                title: "City",
                hintText: "Enter city name",
                textEditingController: city,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter City Name';
                  } else {
                    return null;
                  }
                },
              ),
              mapDetailWidget(
                title: "State",
                hintText: "State (e.g., NY)",
                textEditingController: state,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter State Code';
                  } else {
                    return null;
                  }
                },
              ),
              mapDetailWidget(
                title: "Country",
                hintText: "Country (e.g., US)",
                textEditingController: country,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter State Code';
                  } else {
                    return null;
                  }
                },
              ),
              mapDetailWidget(
                title: "ZipCode",
                hintText: "Enter ZipCode",
                textEditingController: zipCode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Zip Code';
                  } else {
                    return null;
                  }
                },
              ),
              25.height,
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                  onPressed: () => {
                    if (formKey.currentState?.validate() ?? false)
                      {
                        Get.back(
                          result: {
                            "extendedAddress": {
                              "street_Num": sNumber.text,
                              "street_Name": sName.text,
                              "city": city.text,
                              "state": state.text,
                              "Country": country.text,
                              "zipCode": zipCode.text,
                            }
                          },
                        ),
                      }
                  },
                  child: Text(
                    widget.fromSignup
                        ? StringUtils.continueTxt
                        : StringUtils.trackOrder,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: AppColors.whiteColor,
                        ),
                  ),
                ),
              ),
              25.height,
            ],
          ),
        ),
      ),
    );
  }
}
