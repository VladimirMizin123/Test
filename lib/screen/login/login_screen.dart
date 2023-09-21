import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/login/login_state.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../bloc/login/login_bloc.dart';
import '../../bloc/login/login_event.dart';
import '../../constant/string_utils.dart';
import '../../widget/app_center_loader.dart';
import '../../widget/app_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final routeName = '/login';
  final emailController = TextEditingController(text: 'sojitratest01@mailinator.com');
  // final emailController = TextEditingController(text: 'parth.elision@gmail.com');
  final passwordController = TextEditingController(text: 'Sojitra@321');
  // final passwordController = TextEditingController(text: '123456789');

  LoginBloc bloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final themeData = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height.h,
          width: size.width.w,
          padding: EdgeInsets.only(top: 10.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    AssetsUtils.gymEatsLogo,
                    fit: BoxFit.cover,
                    height: 60.h,
                  ),
                ),
                Text(
                  StringUtils.welcome,
                  style: textTheme.displayLarge?.copyWith(letterSpacing: -0.8, fontWeight: FontWeight.w800, color: Colors.black),
                ).paddingOnly(top: 16.h, bottom: 0),
                Text(
                  StringUtils.loginSubText,
                  style: textTheme.bodyLarge?.copyWith(color: AppColors.middleGray),
                ),
                commonTextField(context: context, controller: emailController, hintText: StringUtils.email).paddingOnly(top: 20.h),
                commonTextField(context: context, controller: passwordController, hintText: StringUtils.password).paddingOnly(top: 16.h),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/ForgotPasswordScreen');
                    clearFiled();
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      StringUtils.forgot,
                      style: textTheme.bodyLarge?.copyWith(color: AppColors.darkGray),
                    ),
                  ).paddingOnly(top: 20.h),
                ),
                BlocConsumer<LoginBloc, LoginState>(
                    bloc: bloc,
                    listener: (context, state) {
                      if (state is LoginSuccessfulState) {
                        clearFiled();
                      }
                    },
                    builder: (context, state) {
                      if (state is LoginLoadingState) {
                        return const AppCenterLoader();
                      }
                      return buildButton(
                              context: context,
                              onPressed: () {
                                bloc.add(LoginClickEvent(email: emailController.text, password: passwordController.text));
                              },
                              textColor: const Color(0xFFD9E9EE),
                              bgColor: const Color(0xFF004C63),
                              title: StringUtils.logIn)
                          .paddingOnly(top: 25.h);
                    }),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    StringUtils.or,
                    style: textTheme.bodyLarge,
                  ).paddingSymmetric(vertical: 15.h),
                ),
                buildButton(
                    context: context,
                    hasImage: true,
                    imagePath: AssetsUtils.appleLogo,
                    onPressed: () async {
                      await appleSignIn();
                    },
                    textColor: const Color(0xFFD9E9EE),
                    bgColor: Colors.black,
                    title: StringUtils.apple),
                Wrap(
                  children: [
                    Text(StringUtils.donTAccount,
                        style: textTheme.bodyMedium!.copyWith(
                          color: const Color(0xFF373737),
                        )),
                    InkWell(
                      onTap: () {
                        // Login Screen
                        Get.toNamed('/SignUpScreen');
                      },
                      child: Text(StringUtils.signUp, style: textTheme.bodyLarge!.copyWith(decoration: TextDecoration.underline, color: themeData.primaryColor, fontSize: 14.sp, fontWeight: FontWeight.w400)),
                    ),
                  ],
                ).paddingOnly(top: 22.h, left: 60.w),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'By clicking "Sign up", you agree to our terms and that you have read our ',
                        style: textTheme.bodySmall!.copyWith(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: textTheme.bodySmall!.copyWith(color: const Color(0XFF336633), fontSize: 14.sp, fontWeight: FontWeight.w400),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Single tapped.
                          },
                      ),
                      TextSpan(
                        text: '.',
                        style: TextStyle(color: Colors.blue[300]),
                      ),
                    ],
                  ),
                ).paddingOnly(top: 50.h, bottom: 10.h),
              ],
            ).paddingSymmetric(horizontal: 20.w),
          ),
        ),
      ),
    );
  }

  clearFiled() {
    emailController.clear();
    passwordController.clear();
  }

  //Apple Sign In
  Future<void> appleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      print(credential.email);
    } catch (e) {
      print("Error:- $e");
    }
  }
}
