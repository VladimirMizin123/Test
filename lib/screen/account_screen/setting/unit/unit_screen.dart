import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/units/units_bloc.dart';
import 'package:gymeats_mobile/bloc/units/units_event.dart';
import 'package:gymeats_mobile/bloc/units/units_state.dart';
import 'package:gymeats_mobile/screen/account_screen/setting/unit/unit_screen_widget.dart';
import '../../../../constant/color_utils.dart';
import '../../account/account_scrren_widget.dart';

class UnitScreen extends StatefulWidget {
  const UnitScreen({super.key});

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => UnitsBloc(),
          child: BlocBuilder<UnitsBloc, UnitsState>(
            builder: (context, state) {
              if (state is InitialUnitState) {
                return AccountTitleWidget(
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
                              onChanged1: (value) {
                                BlocProvider.of<UnitsBloc>(context).add(
                                    UnitsLoadEvent(selectedOption: "Pounds"));
                              },
                              onChanged2: (value) {
                                BlocProvider.of<UnitsBloc>(context).add(
                                    UnitsLoadEvent(
                                        selectedOption: "Kilograms"));
                              },
                              groupValue:
                                  (state as RadioOnTapState).selectedState,
                              // groupValue2:
                              // (state as RadioOnTapState).selectedState,
                            ),
                          ),
                          unitScreenWidget(
                            text: "Height",
                            widget: radioButtonWidget(
                              title1: "Inches",
                              title2: "Centimeters",
                              value1: "Inches",
                              value2: "Centimeters",
                              onChanged1: (value) {
                                // BlocProvider.of<UnitsBloc>(context).add(
                                //     UnitsLoadEvent(selectedOption1: "Inches"));
                              },
                              onChanged2: (value) {
                                // BlocProvider.of<UnitsBloc>(context).add(
                                //     UnitsLoadEvent(
                                //         selectedOption1: "Centimeters"));
                              },
                              groupValue: "Inches",
                              // (state as RadioOnTapState).selectedState1,
                              // (state as RadioOnTapState).selectedState1,
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
                );
              }
              return AccountTitleWidget(
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
                            onChanged1: (value) {
                              BlocProvider.of<UnitsBloc>(context).add(
                                  UnitsLoadEvent(selectedOption: "Pounds"));
                            },
                            onChanged2: (value) {
                              BlocProvider.of<UnitsBloc>(context).add(
                                  UnitsLoadEvent(selectedOption: "Kilograms"));
                            },
                            groupValue:
                                (state as RadioOnTapState).selectedState,
                            // groupValue2:
                            //     (state as RadioOnTapState).selectedState,
                          ),
                        ),
                        unitScreenWidget(
                          text: "Height",
                          widget: radioButtonWidget(
                            title1: "Inches",
                            title2: "Centimeters",
                            value1: "Inches",
                            value2: "Centimeters",
                            onChanged1: (value) {
                              // BlocProvider.of<UnitsBloc>(context).add(
                              //     UnitsLoadEvent(selectedOption1: "Inches"));
                            },
                            onChanged2: (value) {
                              // BlocProvider.of<UnitsBloc>(context).add(
                              //     UnitsLoadEvent(
                              //         selectedOption1: "Centimeters"));
                            },
                            groupValue:
                                (state as RadioOnTapState).selectedState,
                            // groupValue2:
                            //     (state as RadioOnTapState).selectedState1,
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
              );
            },
          ),
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
