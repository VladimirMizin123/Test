import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../app/functions.dart';
import '../../bloc/user_sign_up_info/user_sign_up_info_bloc.dart';
import '../../bloc/user_sign_up_info/user_sign_up_info_event.dart';
import '../../bloc/user_sign_up_info/user_sign_up_info_state.dart';
import '../../constant/app_TextStyle.dart';
import '../../constant/asset_utils.dart';
import '../../constant/color_utils.dart';
import '../../constant/string_utils.dart';
import '../../models/sign_up_data_navigate_model.dart';
import '../../widget/app_center_loader.dart';
import '../../widget/app_widget.dart';
import '../../widget/svg_image.dart';

class UserSignUpInfoScreen extends StatefulWidget {
  const UserSignUpInfoScreen({super.key});

  @override
  State<UserSignUpInfoScreen> createState() => _UserSignUpInfoScreenState();
}

class _UserSignUpInfoScreenState extends State<UserSignUpInfoScreen> {
  Color color = AppColors.primaryBlue;
  UserSignUpDataModel model = Get.arguments as UserSignUpDataModel;
  String userInfoImage = AssetsUtils.icMaleChart;
  UserSignUpInfoBloc bloc = UserSignUpInfoBloc();

  PageController pageController = PageController();
  int currentPage = 0;
  int itemsPerPage = 4;

  Position? _currentPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.add(LatLogEvent());
    pageController = PageController(initialPage: 0);
    if (model.gender == StringUtils.male) {
      userInfoImage = AssetsUtils.icMaleChart;
      color = AppColors.primaryBlue;
    } else if (model.gender == StringUtils.female) {
      userInfoImage = AssetsUtils.icFemaleChart;
      color = AppColors.terracotta;
    } else {
      userInfoImage = AssetsUtils.icNonChart;
      color = AppColors.green;
    }
  }

  @override
  void dispose() {
    pageController.dispose(); // Dispose of the PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height.h,
          width: MediaQuery.of(context).size.width.w,
          padding: const EdgeInsets.all(12),
          child: BlocConsumer(
            builder: (context, state) {
              return Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                AssetsUtils.gymEatsLogo,
                                fit: BoxFit.cover,
                                color: color,
                                height: 60.h,
                              ),
                            ),
                          ),
                          if (model.userProfileImage != null) ...{
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                height: 50,
                                width: 50,
                                model.userProfileImage!,
                                fit: BoxFit.fill,
                              ),
                            ),
                          }
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        StringUtils.howDoesThisProfileLook,
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
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 290,
                                  height: 290,
                                  child: SvgImage(
                                    fit: BoxFit.fill,
                                    image: userInfoImage,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(model.age!,
                                                style: AppTextStyle.gymEatsStyle
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 31.sp,
                                                        fontWeight:
                                                            FontWeight.w800))
                                            .paddingOnly(top: 5)
                                            .marginOnly(left: 90),
                                        Text(model.height!,
                                                style: AppTextStyle.gymEatsStyle
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 31.sp,
                                                        fontWeight:
                                                            FontWeight.w800))
                                            .paddingOnly(top: 5)
                                            .marginOnly(right: 105),
                                      ],
                                    ),
                                    Text(model.weight!,
                                            style: AppTextStyle.gymEatsStyle
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 31.sp,
                                                    fontWeight:
                                                        FontWeight.w800))
                                        .marginOnly(top: 60, right: 10),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: SizedBox(
                                height: 100,
                                child: PageView.builder(
                                  scrollDirection: Axis.horizontal,
                                  controller: pageController,
                                  itemCount:
                                      (model.options!.length / itemsPerPage)
                                          .ceil(),
                                  onPageChanged: (int page) {
                                    setState(() {
                                      currentPage = page;
                                    });
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final startIndex = index * itemsPerPage;
                                    final endIndex =
                                        (index + 1) * itemsPerPage <
                                                model.options!.length
                                            ? (index + 1) * itemsPerPage
                                            : model.options!.length;

                                    final pageData = model.options!
                                        .sublist(startIndex, endIndex);

                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: pageData
                                          .map((item) => Container(
                                                /*height: 80.h,
                                            width: 80.h,*/
                                                padding:
                                                    const EdgeInsets.all(18),
                                                margin: const EdgeInsets.only(
                                                    right: 2.5, left: 2.5),
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black54),
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ))
                                          .toList(),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            _buildPageIndicator(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<UserSignUpInfoBloc, UserSignUpInfoState>(
                    bloc: bloc,
                    builder: (context, state) {
                      if (state is SignUpSuccessState) {
                        return const AppCenterLoader();
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: buildBorderButton(
                                    context: context,
                                    onPressed: () {
                                      Get.back();
                                    },
                                    textColor: setColor(gender: model.gender!),
                                    borderColor:
                                        setColor(gender: model.gender!),
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
                                              confirmPassword:
                                                  model.confirmPassword,
                                              gender: model.gender,
                                              age: model.age,
                                              height: model.height,
                                              weight: model.weight,
                                              dietId: model.dietId,
                                              surveyId: model.surveyId,
                                              userProfileImage:
                                                  model.userProfileImage,
                                              latitude: _currentPosition!
                                                  .latitude
                                                  .toString(),
                                              longitude: _currentPosition!
                                                  .longitude
                                                  .toString());
                                      bloc.add(SignUpApiEvent(
                                          model: userSignUpDataModel));
                                    },
                                    textColor: Colors.white,
                                    bgColor: setColor(gender: model.gender!),
                                    title: StringUtils.next)
                                .paddingOnly(top: 25.h),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
            bloc: bloc,
            listener: (context, state) {
              if (state is LatLogState) {
                _currentPosition = state.currentPosition;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        (model.options!.length / itemsPerPage).ceil(),
        (index) => Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index ? color : AppColors.inactive,
          ),
        ),
      ),
    );
  }
}
