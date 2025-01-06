import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_bloc.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/models/add_address_data_navigate_model.dart';
import 'package:gymeats_mobile/models/sign_up_data_navigate_model.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';

import '../../bloc/google_map/add_address/add_address_event.dart';
import '../../bloc/google_map/add_address/add_address_state.dart';

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
  TextEditingController floor = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zipName = TextEditingController();
  TextEditingController addressType = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController stateField = TextEditingController();
  final formKey = GlobalKey<FormState>();

  AddAddressBloc bloc = AddAddressBloc();
  @override
  void initState() {
    super.initState();
    streetName.text = widget.locationData['street_Name'] ?? '';
    apartmentName.text = widget.locationData['street_Num'] ?? '';
    city.text = widget.locationData['city'] ?? '';
    country.text = widget.locationData['country'] ?? '';
    stateField.text = widget.locationData['state'] ?? '';
    zipName.text = widget.locationData['zipcode'] ?? '';
    addressType.text = widget.locationData['addressType'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocConsumer(
          bloc: bloc,
          listener: (context, state) {},
          builder: (context, state) => Column(
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
                  Text('Add delivery address',
                      style: FontUtils.h20(fontColor: AppColors.oxFF010101)),
                  const SizedBox.shrink(),
                ],
              ).paddingSymmetric(horizontal: 15, vertical: 5.h),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Form(
                    key: formKey,
                    child: ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.h, top: 20.h),
                          child: Text('Address Type',
                              style: TextStyle(
                                  color: const Color(0xff373737),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300)),
                        ),
                        commonTextField(controller: addressType),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.h, top: 10.h),
                          child: Text('Street',
                              style: TextStyle(
                                  color: const Color(0xff373737),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300)),
                        ),
                        commonTextField(
                          controller: streetName,
                          validator: (value) {
                            if (value?.trim().isEmpty ?? true) {
                              return 'Please Enter Street Name';
                            } else {
                              return null;
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.h, top: 10.h),
                          child: Text('Street Number',
                              style: TextStyle(
                                  color: const Color(0xff373737),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300)),
                        ),
                        commonTextField(
                          controller: apartmentName,
                          validator: (p0) {
                            if (p0?.trim().isEmpty ?? true) {
                              return 'Please Enter Street Number';
                            } else {
                              return null;
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.h, top: 10.h),
                          child: Text('Apartment or Office Number',
                              style: TextStyle(
                                  color: const Color(0xff373737),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300)),
                        ),
                        commonTextField(
                          controller: floor,
                          validator: (p0) {
                            if (p0?.trim().isEmpty ?? true) {
                              return 'Please enter apartment or office number';
                            } else {
                              return null;
                            }
                          },
                        ),
                        // if (widget.arguments['string'] == 'isFromRegister') ...[
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.h, top: 10.h),
                          child: Text('Country',
                              style: TextStyle(
                                  color: const Color(0xff373737),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300)),
                        ),
                        commonTextField(
                          controller: country,
                          hintText: "Country (e.g., US)",
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2),
                          ],
                          validator: (p0) {
                            if (p0?.trim().isEmpty ?? true) {
                              return 'Please Enter Country Name';
                            } else {
                              return null;
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.h, top: 10.h),
                          child: Text('State',
                              style: TextStyle(
                                  color: const Color(0xff373737),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300)),
                        ),
                        commonTextField(
                          controller: stateField,
                          hintText: "State (e.g., NY)",
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2),
                          ],
                          validator: (p0) {
                            if (p0?.trim().isEmpty ?? true) {
                              return 'Please Enter State Name';
                            } else {
                              return null;
                            }
                          },
                        ),
                        // ],
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.h, top: 10.h),
                          child: Text('City',
                              style: TextStyle(
                                  color: const Color(0xff373737),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300)),
                        ),
                        commonTextField(
                          controller: city,
                          validator: (p0) {
                            if (p0?.trim().isEmpty ?? true) {
                              return 'Please Enter City Name';
                            } else {
                              return null;
                            }
                          },
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
                          controller: zipName,
                          validator: (p0) {
                            if (p0?.trim().isEmpty ?? true) {
                              return 'Please Enter ZipCode';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  String userID = PreferenceUtils.getString(prefUserData);
                  if (formKey.currentState!.validate()) {
                    if (widget.arguments['string'] == 'isFromRegister') {
                      AddAddressModel addAddressModel = AddAddressModel();
                      addAddressModel.latitude = double.tryParse(
                          widget.locationData['latitude'].toString());
                      addAddressModel.longitude = double.tryParse(
                          widget.locationData['longitude'].toString());
                      addAddressModel.streetNum = apartmentName.text;
                      addAddressModel.streetName = streetName.text;
                      addAddressModel.city = city.text;
                      addAddressModel.state = stateField.text;
                      addAddressModel.country = country.text;
                      addAddressModel.addressType = addressType.text;
                      addAddressModel.zipcode = zipName.text;
                      addAddressModel.isPrimary = true;
                      addAddressModel.floor = floor.text;

                      UserSignUpDataModel userData = UserSignUpDataModel(
                        firstName: widget.arguments['userData'].firstName,
                        lastName: widget.arguments['userData'].lastName,
                        email: widget.arguments['userData'].email,
                        password: widget.arguments['userData'].password,
                        userName: widget.arguments['userData'].userName,
                        confirmPassword:
                            widget.arguments['userData'].confirmPassword,
                        phoneNumber: widget.arguments['userData'].phoneNumber,
                        userId: widget.arguments['userData'].userId,
                        addAddressModel: addAddressModel,
                      );

                      if (widget.arguments?["alreadyPurchase"] ?? false) {
                        Get.toNamed('/BuildMyProfileScreen',
                            arguments: userData);
                      } else {
                        Get.toNamed('/PremiumScreen', arguments: userData);
                      }
                    } else {
                      bloc.add(
                        SaveClickEvent(
                          latitude: double.tryParse(
                                  widget.locationData['latitude'].toString()) ??
                              0.00,
                          longitude: double.tryParse(widget
                                  .locationData['longitude']
                                  .toString()) ??
                              0.00,
                          streetNum: apartmentName.text.toString(),
                          streetName: streetName.text.toString(),
                          city: city.text.toString(),
                          state: stateField.text,
                          country: country.text,
                          addressType: addressType.text,
                          zipcode: zipName.text.toString(),
                          isPrimary: true,
                          userId: userID,
                          isFrom: widget.arguments['string'],
                          floor: floor.text,
                        ),
                      );
                    }
                  }
                },
                child: state is AddAddressLoadingState
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 40.h),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container(
                        height: 48.h,
                        margin: EdgeInsets.only(
                            top: 0.h, bottom: 20.h, right: 20.w, left: 20.w),
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
      ),
    );
  }

  Widget commonTextField({
    String? Function(String?)? validator,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
  }) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      controller: controller,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10.w),
        hintText: hintText ?? '',
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
