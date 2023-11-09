import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_bloc.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_event.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_state.dart';
import 'package:gymeats_mobile/screen/account_screen/profile/bottomsheet/profile_image_picker_bottomsheet.dart';
import 'package:gymeats_mobile/screen/account_screen/profile/profile_screen_widget.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:intl/intl.dart';

import '../../../constant/color_utils.dart';
import '../account/account_scrren_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DateTime dateTime = DateTime.now();
  final formKey = GlobalKey<FormState>();
  bool isClick = false;
  AccountBloc accountBloc = AccountBloc();
  File? pickedImageFile;
  String profileImageUrl = '';

  bool isProfileImageLoader = false;
  bool isProfileDetailsLoader = false;

  bool isUpdateProfileImageLoader = false;
  bool isUpdateProfileDetailsLoader = false;

  List<String> goalFocusList = ["lose weight", "gain weight"];
  List<String> genderList = ["Male", "Female"];

  String? selectedGoalFocus;
  String? selectedGender;
  DateTime? selectedDOB;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController goalFocusController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController targetWeightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountBloc.add(GetProfileDetailsEvent());
      accountBloc.add(GetProfileImageEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AccountBloc, AccountState>(
            bloc: accountBloc,
            listener: (context, state) {
              if (state is SelectedImagePathState) {
                pickedImageFile = state.imgPath!;
                setState(() {});
              }

              if (state is GetProfileImageSuccessState) {
                profileImageUrl = state.imageUrl ?? '';
                isProfileImageLoader = false;
                setState(() {});
              }

              if (state is GetProfileDetailsSuccessState) {
                isProfileDetailsLoader = false;

                firstNameController.text =
                    state.profileDetails?.firstName ?? '';
                lastNameController.text = state.profileDetails?.lastName ?? '';
                phoneNumberController.text =
                    state.profileDetails?.phoneNumber ?? '';
                weightController.text =
                    state.profileDetails?.weightInLb.toString() ?? '';
                targetWeightController.text =
                    state.profileDetails?.targetWeightInLb.toString() ?? '';
                heightController.text = state.profileDetails?.heightInCm == null
                    ? ''
                    : (state.profileDetails!.heightInCm! / 30.48)
                        .toStringAsFixed(2);

                if (state.profileDetails?.goal == 1) {
                  goalFocusController.text = goalFocusList.first.toString();
                  selectedGoalFocus = goalFocusList.first.toString();
                } else if (state.profileDetails?.goal == 2) {
                  goalFocusController.text =
                      goalFocusList.last.toString() ?? '';
                  selectedGoalFocus = goalFocusList.last.toString();
                }

                if (state.profileDetails?.birthDate?.isNotEmpty ?? false) {
                  selectedDOB =
                      DateTime.parse(state.profileDetails!.birthDate!);
                  dobController.text =
                      DateFormat('MM/dd/yyyy').format(selectedDOB!);
                }

                genderController.text = state.profileDetails?.gender
                        .toString()
                        .toLowerCase()
                        .capitalizeFirst ??
                    '';

                if (genderController.text == genderList.first) {
                  selectedGender = genderList.first;
                } else if (genderController.text == genderList.last) {
                  selectedGender = genderList.last;
                }

                setState(() {});
              }

              if (state is GetProfileImageLoadingState) {
                profileImageUrl = '';
                isProfileImageLoader = true;
                setState(() {});
              }

              if (state is GetProfileDetailsLoadingState) {
                isProfileDetailsLoader = true;
                setState(() {});
              }

              if (state is UpdateProfileImageLoadingState) {
                isUpdateProfileImageLoader = true;
                setState(() {});
              }

              if (state is UpdateProfileDetailsLoadingState) {
                isUpdateProfileDetailsLoader = true;
                setState(() {});
              }

              if (state is UpdateProfileImageSuccessState ||
                  state is UpdateProfileImageErrorState) {
                isUpdateProfileImageLoader = false;
                setState(() {});
              }
              print('==state=>${state}');
              if (state is UpdateProfileDetailsSuccessState ||
                  state is UpdateProfileDetailsErrorState) {
                isUpdateProfileDetailsLoader = false;
                setState(() {});
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: AccountTitleWidget(
                      title: "Profile",
                      widget: Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade200, spreadRadius: 1)
                            ],
                          ),
                          margin: EdgeInsets.only(
                              top: 140.h, right: 23.w, left: 23.w),
                          child: isProfileDetailsLoader || isProfileImageLoader
                              ? const AppCenterLoader()
                              : SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 8.h),
                                          child: Column(
                                            children: [
                                              if (pickedImageFile != null)
                                                Container(
                                                  height: 100.w,
                                                  width: 100.w,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.r),
                                                    child: Image.file(
                                                      File(pickedImageFile
                                                              ?.path ??
                                                          ""),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              else if (profileImageUrl
                                                  .isNotEmpty)
                                                Container(
                                                  height: 100.w,
                                                  width: 100.w,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.r),
                                                    child: Image.network(
                                                      profileImageUrl,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              else
                                                Container(
                                                  height: 100.w,
                                                  width: 100.w,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors.lightGrey,
                                                  ),
                                                  child: Center(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100.r),
                                                      child: SvgPicture.asset(
                                                          AssetsUtils.appleLogo,
                                                          fit: BoxFit.fill,
                                                          height: 80.w,
                                                          width: 80.w,
                                                          color: Colors.yellow),
                                                    ),
                                                  ),
                                                ),
                                              SizedBox(
                                                height: 2.h,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return ProfileImagePickerBottomSheet(
                                                        accountBloc:
                                                            accountBloc,
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  "Edit profile photo",
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        profileDataWidget(
                                          text: "First Name",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                          widget: commonTextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please Enter First Name';
                                                } else {
                                                  return null;
                                                }
                                              },
                                              textEditingController:
                                                  firstNameController,
                                              enableBorderColor:
                                                  AppColors.primaryBlueColor,
                                              obscureText: false,
                                              width: 140.w,
                                              horizontal: 10,
                                              vertical: 0,
                                              hintText: "First Name"),
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                        ),
                                        profileDataWidget(
                                          text: "Last Name",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                          widget: commonTextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please Enter Last Name';
                                                } else {
                                                  return null;
                                                }
                                              },
                                              textEditingController:
                                                  lastNameController,
                                              enableBorderColor:
                                                  AppColors.primaryBlueColor,
                                              obscureText: false,
                                              width: 140.w,
                                              horizontal: 10,
                                              vertical: 0,
                                              hintText: "Last Name"),
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                        ),
                                        profileDataWidget(
                                          text: "Phone Number",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                          widget: commonTextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please Enter Phone Number';
                                                } else if (value.length != 10) {
                                                  return 'Please Enter Valid Phone Number';
                                                } else {
                                                  return null;
                                                }
                                              },
                                              textEditingController:
                                                  phoneNumberController,
                                              enableBorderColor:
                                                  AppColors.primaryBlueColor,
                                              obscureText: false,
                                              width: 140.w,
                                              horizontal: 10,
                                              vertical: 0,
                                              textInputType:
                                                  TextInputType.number,
                                              hintText: "Phone Number"),
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                        ),
                                        profileDataWidget(
                                          text: "Goal/Focus",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                          widget: commonTextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please Select Goal/Focus';
                                              } else {
                                                return null;
                                              }
                                            },
                                            textEditingController:
                                                goalFocusController,
                                            enableBorderColor:
                                                AppColors.primaryBlueColor,
                                            obscureText: false,
                                            width: 140.w,
                                            horizontal: 10,
                                            vertical: 0,
                                            hintText: "Goal/Focus",
                                            suffixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: DropdownButton(
                                                value: selectedGoalFocus,
                                                hint: const Text("Goal/Focus"),
                                                items: List.generate(
                                                  goalFocusList.length,
                                                  (index) => DropdownMenuItem(
                                                    value: goalFocusList[index],
                                                    child: Text(
                                                      goalFocusList[index],
                                                    ),
                                                  ),
                                                ),
                                                underline: const SizedBox(),
                                                isExpanded: true,
                                                onChanged: (value) {
                                                  goalFocusController.text =
                                                      value ?? "";
                                                  selectedGoalFocus = value;
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        profileDataWidget(
                                          text: "Weight",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                          widget: commonTextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please Enter Weight';
                                              } else {
                                                return null;
                                              }
                                            },
                                            textEditingController:
                                                weightController,
                                            enableBorderColor:
                                                AppColors.primaryBlueColor,
                                            width: 140.w,
                                            horizontal: 10,
                                            vertical: 0,
                                            hintText: "Weight",
                                            textInputType: TextInputType.number,
                                          ),
                                        ),
                                        profileDataWidget(
                                          text: "Target Weight",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                          widget: commonTextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please Enter Target Weight';
                                              } else {
                                                return null;
                                              }
                                            },
                                            textEditingController:
                                                targetWeightController,
                                            enableBorderColor:
                                                AppColors.primaryBlueColor,
                                            width: 140.w,
                                            horizontal: 10,
                                            vertical: 0,
                                            hintText: "Target Weight",
                                            textInputType: TextInputType.number,
                                          ),
                                        ),
                                        profileDataWidget(
                                          text: "Height",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                          widget: commonTextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please Enter Height';
                                              } else {
                                                return null;
                                              }
                                            },
                                            textEditingController:
                                                heightController,
                                            enableBorderColor:
                                                AppColors.middleGray,
                                            width: 140.w,
                                            horizontal: 10,
                                            vertical: 0,
                                            hintText: 'Height',
                                            hintStyle: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w300,
                                              color: AppColors.middleGray,
                                            ),
                                            textInputType: const TextInputType
                                                .numberWithOptions(
                                              decimal: true,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                        ),
                                        profileDataWidget(
                                          text: "Birthdate",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                          widget: commonTextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please Select Birthdate';
                                              } else {
                                                return null;
                                              }
                                            },
                                            textEditingController:
                                                dobController,
                                            enableBorderColor:
                                                AppColors.primaryBlueColor,
                                            obscureText: false,
                                            width: 140.w,
                                            horizontal: 10,
                                            vertical: 0,
                                            readOnly: true,
                                            hintText: "DOB",
                                            onTap: () {
                                              showCupertinoModalPopup(
                                                context: context,
                                                builder: (context) =>
                                                    CupertinoActionSheet(
                                                  actions: [
                                                    buildDatePicker(),
                                                  ],
                                                  cancelButton:
                                                      CupertinoActionSheetAction(
                                                    onPressed: () {
                                                      isClick = true;
                                                      dobController.text =
                                                          DateFormat(
                                                                  'MM/dd/yyyy')
                                                              .format(dateTime);
                                                      selectedDOB = dateTime;
                                                      print(
                                                          '==selectedDOB=>$selectedDOB');
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      "Done",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .errorRedColor),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        profileDataWidget(
                                          text: "Gender",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                          widget: commonTextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please Select Gender';
                                              } else {
                                                return null;
                                              }
                                            },
                                            textEditingController:
                                                genderController,
                                            enableBorderColor:
                                                AppColors.primaryBlueColor,
                                            obscureText: false,
                                            width: 140.w,
                                            horizontal: 10,
                                            vertical: 0,
                                            hintText: "Gender",
                                            suffixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: DropdownButton(
                                                value: selectedGender,
                                                hint: const Text("Gender"),
                                                items: List.generate(
                                                  genderList.length,
                                                  (index) => DropdownMenuItem(
                                                    value: genderList[index],
                                                    child: Text(
                                                      genderList[index],
                                                    ),
                                                  ),
                                                ),
                                                underline: const SizedBox(),
                                                isExpanded: true,
                                                onChanged: (value) {
                                                  genderController.text =
                                                      value ?? "";
                                                  selectedGender = value;
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ).paddingOnly(
                                        right: 16.w, left: 16.w, bottom: 10.w),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  if (isUpdateProfileDetailsLoader ||
                      isUpdateProfileImageLoader)
                    SizedBox(
                      width: double.infinity.w,
                      height: 48.h,
                      child: const AppCenterLoader(),
                    ).paddingOnly(
                        right: 16.w, left: 16.w, top: 16.h, bottom: 16.h)
                  else
                    buildButton(
                            context: context,
                            title: "Update",
                            bgColor: AppColors.primaryBlueColor,
                            textColor: AppColors.whiteColor,
                            onPressed: () {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }

                              accountBloc.add(
                                UpdateProfileDetailsEvent(
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  phoneNumber: phoneNumberController.text,
                                  goal: selectedGoalFocus == goalFocusList.first
                                      ? 1
                                      : selectedGoalFocus == goalFocusList.last
                                          ? 2
                                          : 0,
                                  weight: int.parse(weightController.text),
                                  targetWeight:
                                      int.parse(targetWeightController.text),
                                  heightInCm:
                                      double.parse(heightController.text),
                                  birthDate: selectedDOB!,
                                  gender: selectedGender ?? '',
                                ),
                              );

                              if (pickedImageFile != null) {
                                accountBloc.add(UpdateProfileImageEvent(
                                    imageFile: pickedImageFile!));
                              }
                            })
                        .paddingOnly(
                            right: 16.w, left: 16.w, top: 16.h, bottom: 16.h),
                ],
              );
            }),
      ),
    );
  }

  Widget buildDatePicker() => Container(
        height: 300,
        // decoration: BoxDecoration(
        //     color: Colors.grey.shade200,
        //     borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(10.w),
        //         topRight: Radius.circular(10.w))),
        width: double.infinity,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: dateTime,
          minimumDate: DateTime(1900),
          maximumYear: DateTime.now().year,
          backgroundColor: Colors.grey.shade200,
          onDateTimeChanged: (dateTime) => setState(() {
            this.dateTime = dateTime;
            print("date : $dateTime");
          }),
        ),
      );
}
