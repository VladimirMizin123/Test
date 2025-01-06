import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/screen/account_screen/map_address/map_address_screen_widget.dart';
import 'package:gymeats_mobile/screen/account_screen/profile/profile_screen_widget.dart';

class FoodMenuAddress extends StatefulWidget {
  const FoodMenuAddress({
    super.key,
    required this.request,
  });
  final Map<String, dynamic> request;

  @override
  State<FoodMenuAddress> createState() => _FoodMenuAddressState();
}

class _FoodMenuAddressState extends State<FoodMenuAddress> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController sName = TextEditingController();
  TextEditingController sNumber = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController floorNumberController = TextEditingController();

  @override
  void initState() {
    setInitialData();
    super.initState();
  }

  void setInitialData() {
    sName.text = widget.request["user_street_name"]?.toString() ?? "";
    sNumber.text = widget.request["user_street_num"]?.toString() ?? "";
    city.text = widget.request["user_city"]?.toString() ?? "";
    state.text = widget.request["user_state"]?.toString() ?? "";
    country.text = widget.request["user_country"]?.toString() ?? "";
    zipCode.text = widget.request["user_zipcode"]?.toString() ?? "";
    floorNumberController.text =
        widget.request["extended_address"]?.toString() ?? "";
  }

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
              Row(
                children: [
                  Expanded(
                    child: labelWidget(
                      text: "Please provide your address.",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.darkGray,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: const VisualDensity(vertical: -4.0),
                    onPressed: () => Get.back(),
                    icon: SvgPicture.asset(AssetsUtils.icClose),
                  ),
                ],
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
                title: "Apartment or Office Number",
                textEditingController: floorNumberController,
                validator: (p0) {
                  if (p0?.trim().isEmpty ?? true) {
                    return 'Please enter apartment or office number';
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
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2),
                ],
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
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2),
                ],
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
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      Map<String, dynamic> req = {
                        "user_zipcode": zipCode.text,
                        "user_country": country.text,
                        "user_state": state.text,
                        "user_street_name": sName.text,
                        "user_street_num": sNumber.text,
                        "user_city": city.text,
                        "extended_address": floorNumberController.text,
                      };
                      await PreferenceUtils.setString(
                          foodMenuAddress, jsonEncode(req));
                      Get.back(result: true);
                    }
                  },
                  child: Text(
                    StringUtils.continueTxt,
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
