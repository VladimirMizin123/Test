import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/screen/grocery/screen/checkout/checkoput_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/credit_card.dart';
import 'package:ml_card_scanner/ml_card_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDebitCardScreen extends StatefulWidget {
  const AddDebitCardScreen({super.key, this.data});
  final Map<String, dynamic>? data;
  @override
  State<AddDebitCardScreen> createState() => _AddDebitCardScreenState();
}

class _AddDebitCardScreenState extends State<AddDebitCardScreen> {
  TextEditingController cardName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cvvNumber = TextEditingController();
  CardInfo? _cardInfo;
  var controller = MaskedTextController(mask: '00/0000');

  getData() {
    if (widget.data != null) {
      cardName.text = widget.data?['name'];
      cardNumber.text = widget.data?['number'];
      controller.text = widget.data?['valid'];
      cvvNumber.text = widget.data?['cvv'];
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Image.asset(
                  AssetsUtils.gymEatsSpoon,
                  height: 22.h,
                  width: 56.w,
                  color: AppColors.terracotta,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                      ),
                    ),
                    const Text(
                      'Add Card',
                      style: TextStyle(
                        color: Color(0xFF010101),
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      width: 30,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.h, top: 10.h),
                child: Text('Name',
                    style: TextStyle(
                        color: const Color(0xff373737),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300)),
              ),
              commonTextField(
                label: 'Please Enter Name',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Name';
                  } else {
                    return null;
                  }
                },
                controller: cardName,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.h, top: 10.h),
                child: Text('Card number',
                    style: TextStyle(
                        color: const Color(0xff373737),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300)),
              ),
              commonTextField(
                  keyboardType: TextInputType.number,
                  label: 'Please Card number',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Card number';
                    } else {
                      return null;
                    }
                  },
                  controller: cardNumber,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: GestureDetector(
                      onTap: () async {
                        await Get.to(() => const CreditCard())!.then((value) {
                          setState(() {
                            _cardInfo = value;

                            cardNumber.text = _cardInfo!.number;
                          });
                        });
                      },
                      child: Image.asset(
                        AssetsUtils.scanner,
                        height: 10.h,
                        width: 10.w,
                        color: AppColors.darkGray,
                      ),
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h, top: 10.h),
                          child: Text('Valid until',
                              style: TextStyle(
                                  color: const Color(0xff373737),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300)),
                        ),
                        commonTextField(
                          label: 'MM/YYYY',
                          controller: controller,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Month/Month';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h, top: 10.h),
                          child: Text('CVV',
                              style: TextStyle(
                                  color: const Color(0xff373737),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300)),
                        ),
                        commonTextField(
                          label: '***',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter CVV Number';
                            } else {
                              return null;
                            }
                          },
                          controller: cvvNumber,
                          suffixIcon: const Icon(
                            Icons.info_outline,
                            color: AppColors.darkGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  Map<String, dynamic> data1 = {
                    'name': cardName.text,
                    'number': cardNumber.text,
                    'valid': controller.text,
                    'cvv': cvvNumber.text,
                  };

                  Get.back(result: data1);
                },
                child: Container(
                  height: 45.h,
                  margin: EdgeInsets.only(bottom: 40.h),
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: const Color(0xffCE6B53),
                  ),
                  child: Center(
                    child: Text(
                      'Save',
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
      ),
    );
  }

  Widget commonTextField({
    String? Function(String?)? validator,
    String? label,
    Widget? suffixIcon,
    TextEditingController? controller,
    int? maxLength,
    Function(String)? onChanged,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      controller: controller,
      onChanged: onChanged,
      maxLength: maxLength,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        counterText: '',
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10.w),
        hintText: label,
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
        suffixIcon: suffixIcon,
      ),
    );
  }
}
