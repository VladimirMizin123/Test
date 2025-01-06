import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';

import '../../bloc/user_type/user_type_bloc.dart';
import '../../bloc/user_type/user_type_event.dart';
import '../../bloc/user_type/user_type_state.dart';
import '../../constant/app_TextStyle.dart';
import '../../constant/color_utils.dart';
import '../../constant/string_utils.dart';
import '../../models/sign_up_data_navigate_model.dart';
import '../../widget/app_widget.dart';
import '../../widget/svg_image.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() => _UserTypePageState();
}

class _UserTypePageState extends State<UserTypeScreen> {
  var model = Get.arguments;
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  String genderName = StringUtils.male;
  bool isMale = true;
  bool isFemale = false;
  bool isNon = false;

  bool isVisible = false;

  Color color = AppColors.primaryBlue;

  UserTypeBloc bloc = UserTypeBloc();

  String userInfoImage = AssetsUtils.icMaleChart;

  @override
  void initState() {
    super.initState();
    bloc.add(UserTypeClickEvent(isFemale: false, isMale: true, isNon: false));
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
                        StringUtils.myGenderAgeHeightWeight,
                        style: AppTextStyle.gymEatsStyle.copyWith(
                            color: color,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500),
                      ).paddingOnly(top: 10),
                      SizedBox(
                        height: 10.h,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 38.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: gender(
                                  text: StringUtils.male,
                                  textColor:
                                      isMale ? Colors.white : Colors.black,
                                  bgColor: isMale ? color : Colors.transparent,
                                  onClick: () {
                                    ageController.clear();
                                    heightController.clear();
                                    weightController.clear();
                                    bloc.add(UserTypeClickEvent(
                                        isFemale: false,
                                        isMale: true,
                                        isNon: false));
                                  },
                                ),
                              ),
                              Expanded(
                                child: gender(
                                  text: StringUtils.female,
                                  textColor:
                                      isFemale ? Colors.white : Colors.black,
                                  bgColor:
                                      isFemale ? color : Colors.transparent,
                                  onClick: () {
                                    ageController.clear();
                                    heightController.clear();
                                    weightController.clear();
                                    bloc.add(UserTypeClickEvent(
                                        isFemale: true,
                                        isMale: false,
                                        isNon: false));
                                  },
                                ),
                              ),
                              Expanded(
                                child: gender(
                                  text: StringUtils.nonBinary,
                                  textColor:
                                      isNon ? Colors.white : Colors.black,
                                  bgColor: isNon ? color : Colors.transparent,
                                  onClick: () {
                                    ageController.clear();
                                    heightController.clear();
                                    weightController.clear();
                                    bloc.add(UserTypeClickEvent(
                                        isFemale: false,
                                        isMale: false,
                                        isNon: true));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              height: 320,
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
                                    commonUserTypeTextField(
                                      width: 70.w,
                                      fontColor: Colors.white,
                                      valueColor: Colors.white,
                                      cursorColor: Colors.white,
                                      controller: ageController,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      hintText: StringUtils.required,
                                      textInputType: TextInputType.number,
                                      context: context,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[0-9]'))
                                      ],
                                      onChange: (String value) {
                                        bloc.add(TextChangeEvent(
                                            age: ageController.text,
                                            height: heightController.text,
                                            weight: weightController.text));
                                      },
                                    ).paddingOnly(top: 15).marginOnly(left: 70),
                                    commonUserTypeTextField(
                                            width: 70.w,
                                            fontColor: Colors.white,
                                            valueColor: Colors.white,
                                            cursorColor: Colors.white,
                                            controller: heightController,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w900,
                                            hintText: StringUtils.required,
                                            textInputType: TextInputType.multiline,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r"^\d+[\'’]?\d{0,2}")),
                                            ],
                                            context: context,
                                            onChange: (String value) {
                                              bloc.add(TextChangeEvent(
                                                  age: ageController.text,
                                                  height: heightController.text,
                                                  weight:
                                                      weightController.text));
                                            })
                                        .paddingOnly(top: 15)
                                        .marginOnly(right: 80),
                                  ],
                                ),
                                commonUserTypeTextField(
                                    width: 120.w,
                                    fontColor: Colors.white,
                                    valueColor: Colors.white,
                                    cursorColor: Colors.white,
                                    controller: weightController,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    hintText: StringUtils.required,
                                    textInputType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    isSuffix: true,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[0-9.]'))
                                    ],
                                    context: context,
                                    onChange: (String value) {
                                      bloc.add(TextChangeEvent(
                                          age: ageController.text,
                                          height: heightController.text,
                                          weight: weightController.text));
                                    }).marginOnly(top: 70, right: 10),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  buildButton(
                          onPressed: () {
                            if (isVisible) {
                              FocusScope.of(context).unfocus();
                              UserSignUpDataModel userSignUpDataModel =
                                  UserSignUpDataModel(
                                firstName: model.firstName,
                                lastName: model.lastName,
                                email: model.email,
                                password: model.password,
                                userName: model.userName,
                                confirmPassword: model.confirmPassword,
                                phoneNumber: model.phoneNumber,
                                gender: genderName,
                                age: ageController.text,
                                userId: model.userId,
                                height:
                                    heightController.text.replaceAll("'", "."),
                                weight: weightController.text,
                                addAddressModel: model.addAddressModel,
                              );
                              Get.toNamed('/UserSurveyScreen',
                                  arguments: userSignUpDataModel);
                              /*ageController.clear();
                              weightController.clear();
                              heightController.clear();*/
                            }
                          },
                          textColor: Colors.white,
                          bgColor: isVisible ? color : AppColors.disable,
                          title: StringUtils.next,
                          context: context)
                      .paddingOnly(top: 10.h),
                ],
              );
            },
            bloc: bloc,
            listener: (context, state) {
              if (state is UserTypeClickState) {
                isMale = state.isMale;
                isFemale = state.isFemale;
                isNon = state.isNon;

                /* ageController.clear();
                weightController.clear();
                heightController.clear();*/

                if (isMale) {
                  userInfoImage = AssetsUtils.icMaleChart;
                  genderName = StringUtils.male;
                  color = AppColors.primaryBlue;
                  isVisible = false;
                } else if (isFemale) {
                  userInfoImage = AssetsUtils.icFemaleChart;
                  genderName = StringUtils.female;
                  color = AppColors.terracotta;
                  isVisible = false;
                } else {
                  userInfoImage = AssetsUtils.icNonChart;
                  genderName = StringUtils.nonBinary;
                  color = AppColors.green;
                  isVisible = false;
                }
              }

              if (state is ChangeButtonState) {
                isVisible = state.isVisible;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget gender({
    required String text,
    required Color textColor,
    required Color bgColor,
    required Function() onClick,
  }) =>
      InkWell(
        onTap: () {
          onClick();
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          height: 46.h,
          child: Text(
            text,
            style: AppTextStyle.butttonTextStyle.copyWith(
                color: textColor, fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
      );
}
