import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_bloc.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_event.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_state.dart';
import 'package:gymeats_mobile/screen/account_screen/setting/unit/unit_screen_widget.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';

import '../../../../constant/color_utils.dart';
import '../../account/account_scrren_widget.dart';

class UnitScreen extends StatefulWidget {
  const UnitScreen({super.key});

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  AccountBloc accountBloc = AccountBloc();

  bool isLoader = false;
  int? weightValue;
  int? heightValue;
  int? energyValue;
  int? waterValue;
  String? unitId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      accountBloc.add(GetUnitInfoEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: BlocConsumer(
          bloc: accountBloc,
          listener: (context, state) {
            if (state is GetUnitInfoLoadingState) {
              isLoader = true;
              setState(() {});
            }
            if (state is GetUnitInfoSuccessState) {
              isLoader = false;

              weightValue = state.unitData?.weightType == 'Pound' ? 1 : 2;
              heightValue = state.unitData?.heightType == 'Inches' ? 1 : 2;
              energyValue = state.unitData?.energyType == 'Kilojoules' ? 1 : 2;
              waterValue = state.unitData?.waterType == 'Floz' ? 1 : 2;
              unitId = state.unitData?.unitId;

              setState(() {});
            }
            if (state is GetUnitInfoErrorState) {
              isLoader = false;
              setState(() {});
            }
          },
          builder: (context, state) {
            return AccountTitleWidget(
              title: "Units",
              widget: Expanded(
                child: isLoader
                    ? const AppCenterLoader()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            unitScreenWidget(
                              text: "Weight",
                              widget: radioButtonWidget(
                                context: context,
                                title1: "Pound",
                                title2: "Kilogram",
                                value1: 1,
                                value2: 2,
                                onChanged1: (value) {
                                  weightValue = value;
                                  accountBloc.add(
                                    UpdateUnitInfoEvent(
                                      unitId: unitId!,
                                      energyType: energyValue!,
                                      weightType: weightValue!,
                                      heightType: heightValue!,
                                      waterType: waterValue!,
                                    ),
                                  );
                                },
                                onChanged2: (value) {
                                  weightValue = value;
                                  accountBloc.add(
                                    UpdateUnitInfoEvent(
                                      unitId: unitId!,
                                      energyType: energyValue!,
                                      weightType: weightValue!,
                                      heightType: heightValue!,
                                      waterType: waterValue!,
                                    ),
                                  );
                                },
                                groupValue: weightValue,
                              ),
                            ),
                            unitScreenWidget(
                              text: "Height",
                              widget: radioButtonWidget(
                                context: context,
                                title1: "Feet/Inch",
                                title2: "Centimeter",
                                value1: 1,
                                value2: 2,
                                onChanged1: (value) {
                                  heightValue = value;
                                  accountBloc.add(
                                    UpdateUnitInfoEvent(
                                      unitId: unitId!,
                                      energyType: energyValue!,
                                      weightType: weightValue!,
                                      heightType: heightValue!,
                                      waterType: waterValue!,
                                    ),
                                  );
                                },
                                onChanged2: (value) {
                                  heightValue = value;
                                  accountBloc.add(
                                    UpdateUnitInfoEvent(
                                      unitId: unitId!,
                                      energyType: energyValue!,
                                      weightType: weightValue!,
                                      heightType: heightValue!,
                                      waterType: waterValue!,
                                    ),
                                  );
                                },
                                groupValue: heightValue,
                              ),
                            ),
                            unitScreenWidget(
                              text: "Water",
                              widget: radioButtonWidget(
                                context: context,
                                title1: "FL Oz",
                                title2: "Mililiters",
                                value1: 1,
                                value2: 2,
                                onChanged1: (value) {
                                  waterValue = value;
                                  accountBloc.add(
                                    UpdateUnitInfoEvent(
                                      unitId: unitId!,
                                      energyType: energyValue!,
                                      weightType: weightValue!,
                                      heightType: heightValue!,
                                      waterType: waterValue!,
                                    ),
                                  );
                                },
                                onChanged2: (value) {
                                  waterValue = value;
                                  accountBloc.add(
                                    UpdateUnitInfoEvent(
                                      unitId: unitId!,
                                      energyType: energyValue!,
                                      weightType: weightValue!,
                                      heightType: heightValue!,
                                      waterType: waterValue!,
                                    ),
                                  );
                                },
                                groupValue: waterValue,
                              ),
                            ),
                          ],
                        ),
                      ).paddingOnly(top: 140),
              ),
            );
          },
        ),
        /*AccountTitleWidget(
          title: "Units",
          widget: Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  unitScreenWidget(
                    text: "Weight",
                    widget: radioButtonWidget(
                      title1: "Pounds",
                      title2: "Kilograms",
                      value1: "Pounds",
                      value2: "Kilograms",
                      onChanged1: (value) {},
                      onChanged2: (value) {},
                      groupValue: "Pounds",
                    ),
                  ),
                  unitScreenWidget(
                    text: "Height",
                    widget: radioButtonWidget(
                      title1: "Inches",
                      title2: "Centimeters",
                      value1: "Inches",
                      value2: "Centimeters",
                      onChanged1: (value) {},
                      onChanged2: (value) {},
                      groupValue: "Centimeters",
                    ),
                  ),
                  unitScreenWidget(
                    text: "Energy",
                    widget: radioButtonWidget(
                      title1: "Kilojoules",
                      title2: "Calories",
                      value1: "Kilojoules",
                      value2: "Calories",
                      onChanged1: (value) {},
                      onChanged2: (value) {},
                      groupValue: "Calories",
                    ),
                  ),
                  unitScreenWidget(
                    text: "Water",
                    widget: radioButtonWidget(
                      title1: "Cup",
                      title2: "Mililiters",
                      value1: "Cup",
                      value2: "Mililiters",
                      onChanged1: (value) {},
                      onChanged2: (value) {},
                      groupValue: "Mililiters",
                    ),
                  ),
                ],
              ),
            ).paddingOnly(top: 140),
          ),
        ),*/
      ),
    );
  }
}
