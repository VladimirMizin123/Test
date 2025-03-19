import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/controller/home_screen_controller.dart';
import 'package:gymeats_mobile/screen/account_screen/about/pivacy/privacy_policy_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../bloc/sign_up/sign_up_bloc.dart';
import '../../bloc/sign_up/sign_up_event.dart';
import '../../bloc/sign_up/sign_up_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  bool isPassword = false;
  bool isConFirmPassword = false;

  SignUpBloc bloc = SignUpBloc();

  @override
  void initState() {
    if (Get.arguments != null) {
      homeScreenController.initRegister(Get.arguments);
    }

    super.initState();
  }

  @override
  void dispose() {
    PreferenceUtils.removePref(prefUserEmail);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final themeData = Theme.of(context);
    return GetBuilder<HomeScreenController>(builder: (homeController) {
      homeController = homeScreenController;
      return Scaffold(
        body: SafeArea(
          child: Container(
            height: size.height.h,
            width: size.width.w,
            padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      AssetsUtils.gymEatsLogo,
                      fit: BoxFit.cover,
                      height: 60.h,
                    ),
                  ),
                  Text(
                    'You are one step closer to eating better!',
                    style: textTheme.headlineSmall!.copyWith(
                        color: themeData.primaryColor, fontSize: 19.5.sp),
                    // style: AppTextStyle.butttonTextStyle
                    //     .copyWith(color: const Color(0xFF004C63)),
                  ).paddingOnly(top: 10),
                  Text(
                    homeController.argumentData == null
                        ? 'Create your GYM EATS account to continue'
                        : 'Complete your GYM EATS account to continue',
                    style: textTheme.bodyMedium!.copyWith(
                        color: const Color(0xFF5F5F5F),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400),
                  ).paddingOnly(top: 18),
                  commonTextField(
                          context: context,
                          controller: homeController.fNameController,
                          hintText: StringUtils.fName)
                      .paddingOnly(top: 8),
                  commonTextField(
                          context: context,
                          controller: homeController.lastNameController,
                          hintText: StringUtils.lName)
                      .paddingOnly(top: 16),
                  commonTextField(
                    context: context,
                    controller: homeController.emailController,
                    hintText: StringUtils.email,
                    readOnly: homeController.argumentData != null,
                  ).paddingOnly(top: 16),
                  commonTextField(
                    context: context,
                    controller: homeController.phoneNumberController,
                    hintText: StringUtils.phone,
                    textInputType: TextInputType.number,
                    maxLength: 10,
                  ).paddingOnly(top: 16),
                  if (!(homeController.argumentData?['fromLogin'] ??
                      false)) ...[
                    commonTextField(
                            context: context,
                            controller: homeController.passwordController,
                            eyeShow: true,
                            isPassword: isPassword,
                            onTap: () {
                              isPassword = !isPassword;
                              setState(() {});
                            },
                            hintText: StringUtils.password)
                        .paddingOnly(top: 16),
                    commonTextField(
                            context: context,
                            eyeShow: true,
                            isPassword: isConFirmPassword,
                            onTap: () {
                              isConFirmPassword = !isConFirmPassword;
                              setState(() {});
                            },
                            controller:
                                homeController.confirmPasswordController,
                            hintText: StringUtils.confirmPassword)
                        .paddingOnly(top: 16),
                    commonTextField(
                      context: context,
                      controller: homeController.referralCode,
                      hintText: StringUtils.referralCode,
                    ).paddingOnly(top: 16),
                  ],
                  BlocConsumer<SignUpBloc, SignUpState>(
                      bloc: bloc,
                      listener: (context, state) {
                        if (state is IsEmailSuccessState) {}
                      },
                      builder: (context, state) {
                        if (state is LoggingState) {
                          return SizedBox(
                            height: 35.w,
                            width: 35.w,
                            child: const CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ).paddingOnly(top: 10);
                        }
                        return buildButton(
                          context: context,
                          onPressed: () async {
                            final data = await homeController.joinGymEatButton(
                                homeController.argumentData != null);
                            if (data == null) {
                              return;
                            }
                            if (homeController.argumentData == null) {
                              bloc.add(
                                CheckEmailEvent(
                                  email: homeController.emailController.text,
                                  confirmPassword: homeController
                                      .confirmPasswordController.text,
                                  fName: homeController.fNameController.text,
                                  lName: homeController.lastNameController.text,
                                  password:
                                      homeController.passwordController.text,
                                  userName:
                                      "${homeController.fNameController.text}${homeController.lastNameController.text}",
                                  phoneNumber:
                                      homeController.phoneNumberController.text,
                                  referralCode:
                                      homeController.referralCode.text,
                                ),
                              );
                            } else {
                              await homeScreenController.continueRegister();
                            }
                          },
                          textColor: const Color(0xFFD9E9EE),
                          bgColor: const Color(0xFF004C63),
                          title: Get.arguments == null
                              ? StringUtils.joinGymEats
                              : StringUtils.continueTxt,
                        ).paddingOnly(top: 25.h);
                      }),
                  /*Text(
                    StringUtils.or,
                    style: textTheme.bodyLarge?.copyWith(fontSize: 20.sp),
                  ).paddingSymmetric(vertical: 12.h),*/
                  /*kIsWeb
                      ? const SizedBox()
                      : Platform.isIOS
                          ? buildButton(
                              context: context,
                              hasImage: true,
                              imagePath: AssetsUtils.appleLogo,
                              onPressed: () async {
                                await homeController.appleSignIn();
                              },
                              textColor: const Color(0xFFD9E9EE),
                              bgColor: Colors.black,
                              title: StringUtils.apple)
                          : buildButton(
                              context: context,
                              hasImage: true,
                              imagePath: AssetsUtils.googleLogo,
                              onPressed: () {},
                              textColor: Colors.white,
                              bgColor: Colors.black,
                              title: StringUtils.google,
                            ),*/
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: StringUtils.alreadyAccount,
                          style: textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFF373737),
                          ),
                        ),
                        TextSpan(
                          text: StringUtils.logIn,
                          style: textTheme.bodyLarge!.copyWith(
                              decoration: TextDecoration.underline,
                              color: themeData.primaryColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Single tapped.
                              Get.back();
                            },
                        ),
                      ],
                    ),
                  ).paddingOnly(top: 22),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'By clicking "Sign up", you agree to our terms and that you have read our ',
                          style: textTheme.bodySmall!.copyWith(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: textTheme.bodySmall!.copyWith(
                              color: const Color(0XFF336633),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PolicyScreen(),
                                  ));
                            },
                        ),
                        TextSpan(
                          text: '.',
                          style: TextStyle(color: Colors.blue[300]),
                        ),
                      ],
                    ),
                  ).paddingSymmetric(vertical: 50.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
