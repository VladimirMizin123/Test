import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../app/functions.dart';
import '../../bloc/user_photo_selection/user_photo_selection_bloc.dart';
import '../../bloc/user_photo_selection/user_photo_selection_event.dart';
import '../../bloc/user_photo_selection/user_photo_selection_state.dart';
import '../../constant/app_TextStyle.dart';
import '../../constant/asset_utils.dart';
import '../../constant/color_utils.dart';
import '../../constant/string_utils.dart';
import '../../models/sign_up_data_navigate_model.dart';
import '../../widget/app_widget.dart';

class UserPhotoSelectionScreen extends StatefulWidget {
  const UserPhotoSelectionScreen({super.key});

  @override
  State<UserPhotoSelectionScreen> createState() =>
      _UserPhotoSelectionScreenState();
}

class _UserPhotoSelectionScreenState extends State<UserPhotoSelectionScreen> {
  Color color = AppColors.primaryBlue;
  Color colorProfileImage = AppColors.bluePressed;
  Color colorTakePhoto = AppColors.newDarkBlue;
  UserPhotoSelectionBloc bloc = UserPhotoSelectionBloc();
  UserSignUpDataModel model = Get.arguments as UserSignUpDataModel;
  File? imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (model.gender == StringUtils.male) {
      color = AppColors.primaryBlue;
      colorProfileImage = AppColors.bluePressed;
      colorTakePhoto = AppColors.newDarkBlue;
    } else if (model.gender == StringUtils.female) {
      color = AppColors.terracotta;
      colorProfileImage = AppColors.terracotta;
      colorTakePhoto = AppColors.terracotta;
    } else {
      color = AppColors.green;
      colorProfileImage = AppColors.green;
      colorTakePhoto = AppColors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height.h,
          width: MediaQuery.of(context).size.width.w,
          padding: const EdgeInsets.all(12),
          child: BlocConsumer<UserPhotoSelectionBloc, UserPhotoSelectionState>(
            builder: (context, state) {
              return Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Image.asset(
                          AssetsUtils.gymEatsLogo,
                          fit: BoxFit.cover,
                          color: color,
                          height: 60.h,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        StringUtils.letsUploadYourProfilePicture,
                        style: AppTextStyle.gymEatsStyle.copyWith(
                            color: color,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500),
                      ).paddingOnly(top: 10),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (imageFile != null) ...{
                            ClipRRect(
                              borderRadius: BorderRadius.circular(150),
                              child: Image.file(
                                height: 220,
                                width: 220,
                                imageFile!,
                                fit: BoxFit.fill,
                              ),
                            ),
                          } else ...{
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorProfileImage),
                              width: 200.w,
                              height: 200.h,
                              child: Text(
                                StringUtils.profileImage,
                                style: AppTextStyle.gymEatsStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          },
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  bloc.add(ImageSelectionEvent(
                                      imageFrom: StringUtils.takePhoto));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorTakePhoto),
                                  width: 110.w,
                                  height: 110.h,
                                  child: Text(StringUtils.takePhoto,
                                      style: AppTextStyle.gymEatsStyle.copyWith(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                              SizedBox(width: 35.w),
                              InkWell(
                                onTap: () {
                                  bloc.add(ImageSelectionEvent(
                                      imageFrom: StringUtils.uploadPhoto));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.middleGray),
                                  width: 110.w,
                                  height: 110.h,
                                  child: Text(StringUtils.uploadPhoto,
                                      style: AppTextStyle.gymEatsStyle.copyWith(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500)),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/UserSignUpInfoScreen', arguments: model);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(StringUtils.skip,
                          style: AppTextStyle.gymEatsStyle.copyWith(
                              color: AppColors.disable,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildBorderButton(
                                context: context,
                                onPressed: () {
                                  debugPrint("");
                                  Get.back();
                                  // Get.toNamed('/UserSurveyScreen',
                                  //     arguments: model);
                                },
                                textColor: setColor(gender: model.gender!),
                                borderColor: setColor(gender: model.gender!),
                                bgColor: Colors.white,
                                title: StringUtils.previous)
                            .paddingOnly(top: 25.h),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: buildButton(
                                context: context,
                                onPressed: () {
                                  UserSignUpDataModel userSignUpDataModel =
                                      UserSignUpDataModel(
                                    firstName: model.firstName,
                                    lastName: model.lastName,
                                    email: model.email,
                                    password: model.password,
                                    userName: model.userName,
                                    confirmPassword: model.confirmPassword,
                                    phoneNumber: model.phoneNumber,
                                    gender: model.gender,
                                    age: model.age,
                                    height: model.height,
                                    weight: model.weight,
                                    dietId: model.dietId,
                                    surveyId: model.surveyId,
                                    userProfileImage: imageFile,
                                    options: model.options,
                                    restrictionID: model.restrictionID,
                                    addAddressModel: model.addAddressModel,
                                  );
                                  Get.toNamed('/UserSignUpInfoScreen',
                                      arguments: userSignUpDataModel);
                                },
                                textColor: Colors.white,
                                bgColor: setColor(gender: model.gender!),
                                title: StringUtils.next)
                            .paddingOnly(top: 25.h),
                      ),
                    ],
                  ),
                ],
              );
            },
            bloc: bloc,
            listener: (context, state) {
              if (state is GetImageState) {
                imageFile = state.image;
              }
            },
          ),
        ),
      ),
    );
  }
}
