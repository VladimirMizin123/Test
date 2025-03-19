import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as s;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_bloc.dart';
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_state.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../../bloc/google_map/add_address/add_address_event.dart';
import '../../../constant/asset_utils.dart';
import 'map_address_screen_widget.dart';

class MapAddressSecondStep extends StatefulWidget {
  final UserAddress? userAddress;
  final LatLng? selectedLatLng;
  final TextEditingController addressNameController;
  final TextEditingController streetDetailsController;
  final TextEditingController apartmentNumberController;
  final TextEditingController floorNumberController;
  final TextEditingController zipCodeController;
  final TextEditingController cityField;
  final TextEditingController stateField;
  final TextEditingController countryField;

  const MapAddressSecondStep({
    super.key,
    this.userAddress,
    this.selectedLatLng,
    required this.addressNameController,
    required this.streetDetailsController,
    required this.apartmentNumberController,
    required this.floorNumberController,
    required this.zipCodeController,
    required this.cityField,
    required this.stateField,
    required this.countryField,
  });

  @override
  State<MapAddressSecondStep> createState() => _MapAddressSecondStepState();
}

class _MapAddressSecondStepState extends State<MapAddressSecondStep> {
  final formKey = GlobalKey<FormState>();

  AddAddressBloc bloc = AddAddressBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: BlocBuilder(
            bloc: bloc,
            builder: (context, state) {
              if (state is AddAddressLoadingState) {
                return const AppCenterLoader();
              } else {
                return Column(
                  children: [
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Address details',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(color: const Color(0xFF010101)),
                            )
                          ],
                        ),
                        Positioned.fill(
                          left: 0,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () => Get.back(),
                              child: SvgPicture.asset(
                                AssetsUtils.icBackArrow,
                                height: 25.h,
                                width: 25.w,
                                color: AppColors.darkGray,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).paddingOnly(left: 20, right: 20, top: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              mapDetailWidget(
                                title: "Address Type",
                                textEditingController:
                                    widget.addressNameController,
                                readOnly: false,
                                suffixIcon: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                              mapDetailWidget(
                                title: "Street",
                                textEditingController:
                                    widget.streetDetailsController,
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
                                textEditingController:
                                    widget.apartmentNumberController,
                                validator: (p0) {
                                  if (p0?.trim().isEmpty ?? true) {
                                    return 'Please Enter Street Number';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              mapDetailWidget(
                                title: "Apartment or Office Number",
                                textEditingController:
                                    widget.floorNumberController,
                                validator: (p0) {
                                  if (p0?.trim().isEmpty ?? true) {
                                    return 'Please enter apartment or office number';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              mapDetailWidget(
                                title: "Country",
                                textEditingController: widget.countryField,
                                hintText: "Country (e.g., US)",
                                inputFormatters: [
                                  s.LengthLimitingTextInputFormatter(2),
                                ],
                                validator: (p0) {
                                  if (p0?.trim().isEmpty ?? true) {
                                    return 'Please Enter Country Name';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              mapDetailWidget(
                                title: "State",
                                hintText: "State (e.g., NY)",
                                textEditingController: widget.stateField,
                                inputFormatters: [
                                  s.LengthLimitingTextInputFormatter(2),
                                ],
                                validator: (p0) {
                                  if (p0?.trim().isEmpty ?? true) {
                                    return 'Please Enter State Name';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              mapDetailWidget(
                                title: "City",
                                textEditingController: widget.cityField,
                                validator: (p0) {
                                  if (p0?.trim().isEmpty ?? true) {
                                    return 'Please Enter City Name';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              mapDetailWidget(
                                title: "Zip",
                                textEditingController: widget.zipCodeController,
                                validator: (p0) {
                                  if (p0?.trim().isEmpty ?? true) {
                                    return 'Please Enter ZipCode';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ).paddingOnly(left: 22.w, right: 22.w, top: 8.h),
                        ),
                      ),
                    ),
                    buildButton(
                            context: context,
                            title: "Save",
                            onPressed: () {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }

                              if (widget.userAddress != null) {
                                print('------>>>>DDDDD');

                                bloc.add(
                                  UpdateClickEvent(
                                    latitude:
                                        widget.selectedLatLng?.latitude ?? 0,
                                    longitude:
                                        widget.selectedLatLng?.longitude ?? 0,
                                    streetNum:
                                        widget.apartmentNumberController.text,
                                    streetName:
                                        widget.streetDetailsController.text,
                                    city: widget.cityField.text,
                                    state: widget.stateField.text,
                                    country: widget.countryField.text,
                                    addressType:
                                        widget.addressNameController.text,
                                    zipcode: widget.zipCodeController.text,
                                    isPrimary:
                                        widget.userAddress?.isPrimary ?? false,
                                    userId:
                                        PreferenceUtils.getString(prefUserData),
                                    isFrom: 'isFromProfile',
                                    addressId: widget.userAddress?.id ?? '',
                                    floor: widget.floorNumberController.text,
                                  ),
                                );
                              } else {
                                bloc.add(
                                  SaveClickEvent(
                                    latitude:
                                        widget.selectedLatLng?.latitude ?? 0,
                                    longitude:
                                        widget.selectedLatLng?.longitude ?? 0,
                                    streetNum:
                                        widget.apartmentNumberController.text,
                                    streetName:
                                        widget.streetDetailsController.text,
                                    city: widget.cityField.text,
                                    state: widget.stateField.text,
                                    country: widget.countryField.text,
                                    addressType:
                                        widget.addressNameController.text,
                                    zipcode: widget.zipCodeController.text,
                                    isPrimary: true,
                                    userId:
                                        PreferenceUtils.getString(prefUserData),
                                    isFrom: 'isFromProfile',
                                    floor: widget.floorNumberController.text,
                                  ),
                                );
                              }
                            },
                            textColor: AppColors.whiteColor,
                            bgColor: AppColors.primaryBlueColor)
                        .paddingOnly(
                            left: 22.w, right: 22.w, top: 12.h, bottom: 10.h),
                  ],
                );
              }
            }),
      ),
    );
  }
}
