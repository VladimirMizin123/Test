import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_bloc.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_state.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/account_event.dart';

class ProfileImagePickerBottomSheet extends StatefulWidget {
  final AccountBloc? accountBloc;
  const ProfileImagePickerBottomSheet({super.key, this.accountBloc});

  @override
  State<ProfileImagePickerBottomSheet> createState() =>
      _ProfileImagePickerBottomSheetState();
}

class _ProfileImagePickerBottomSheetState
    extends State<ProfileImagePickerBottomSheet> {
  int selectedIndex = 0;
  final ImagePicker _picker = ImagePicker();
  String imagePath = '';

  Future<void> picImage(ImageSource source) async {
    try {
      XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 100,
      );
      if (pickedFile != null) {
        setState(() {
          imagePath = pickedFile.path;
        });

        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
            WebUiSettings(
              // ignore: use_build_context_synchronously
              context: context,
            ),
          ],
        );

        File image = File(croppedFile!.path);

        try {
          widget.accountBloc!.add(GetSelectedImagePathEvent(imagePath: image));
        } catch (e) {
          print('=eee====>$e');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocConsumer<AccountBloc, AccountState>(
        bloc: widget.accountBloc,
        listener: (context, state) {
          if (state is SelectedImagePathState) {
            Get.back();
          }
        },
        builder: (context, state) {
          return Material(
            color: AppColors.whiteColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 3.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.disable),
                        )),
                    const SizedBox(height: 20),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select ImageSource',
                          style: FontUtils.h18(
                              fontColor: AppColors.black,
                              fontWeight: FWT.semiBold),
                        )),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () async {
                            await picImage(ImageSource.camera);
                          },
                          child: Container(
                            height: screenSize.height * 0.20,
                            decoration: BoxDecoration(
                                boxShadow: boxShadowWidget,
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                                child: Text('Take a Photo',
                                    style: FontUtils.h14(
                                        fontColor: AppColors.black))),
                          ),
                        )),
                        const SizedBox(width: 10),
                        Expanded(
                            child: GestureDetector(
                          onTap: () async {
                            await picImage(ImageSource.gallery);
                          },
                          child: Container(
                            height: screenSize.height * 0.20,
                            decoration: BoxDecoration(
                                boxShadow: boxShadowWidget,
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                                child: Text('Gallery',
                                    style: FontUtils.h14(
                                        fontColor: AppColors.black))),
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      AssetsUtils.gymEatsLogo,
                      height: 20.h,
                      width: 56.w,
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
