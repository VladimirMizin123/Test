import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/my_address/my_address_bloc.dart';
import 'package:gymeats_mobile/bloc/my_address/my_address_event.dart';
import 'package:gymeats_mobile/screen/account_screen/account/account_scrren_widget.dart';
import 'package:gymeats_mobile/screen/account_screen/map_address/map_address_screen.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import '../../../bloc/my_address/my_address_state.dart';
import '../../../constant/asset_utils.dart';
import '../../../constant/color_utils.dart';
import '../../../widget/divider_widget.dart';
import '../../../widget/svg_image.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  MyAddressBloc addressBloc = MyAddressBloc();

  String? selectedAddress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addressBloc.add(GetUserAddressEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AccountTitleWidget(
                title: "My Address",
                widget: Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade200, spreadRadius: 1)
                      ],
                    ),
                    // height: 1.h,
                    margin:
                        EdgeInsets.only(top: 150.h, right: 23.w, left: 23.w),
                    child: Column(
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 8.h,
                        ),
                        Expanded(
                            child: BlocConsumer(
                          bloc: addressBloc,
                          builder: (context, state) {
                            if (state is InitialState) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AccountTitleWidget(
                                    title: "My Address",
                                    widget: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade200,
                                              spreadRadius: 1)
                                        ],
                                      ),
                                      // height: 1.h,
                                      margin: EdgeInsets.only(
                                          top: 150.h, right: 23.w, left: 23.w),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 20.w),
                                                    child: Radio(
                                                      value: "Home",
                                                      groupValue: state,
                                                      onChanged: (value) {
                                                        //changeOption(value, context);
                                                        BlocProvider.of<
                                                                    MyAddressBloc>(
                                                                context)
                                                            .add(MyAddressLoadEvent(
                                                                firstOption:
                                                                    'Home'));
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 17.w,
                                                  ),
                                                  const Text("Home",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 20.w),
                                                    child: const SvgImage(
                                                      image: AssetsUtils
                                                          .forwardArrow,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const DividerWidget(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 20.w),
                                                    child: Radio(
                                                      value: "Office",
                                                      groupValue: state,
                                                      onChanged: (value) {
                                                        BlocProvider.of<
                                                                    MyAddressBloc>(
                                                                context)
                                                            .add(MyAddressLoadEvent(
                                                                firstOption:
                                                                    'Office'));
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 17.w,
                                                  ),
                                                  const Text("Office",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 20.w),
                                                    child: const SvgImage(
                                                      image: AssetsUtils
                                                          .forwardArrow,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  buildButton(
                                          context: context,
                                          title: "Add New Address",
                                          onPressed: () {
                                            Get.to(
                                              const MapAddressScreen(),
                                            );
                                          },
                                          textColor: AppColors.whiteColor,
                                          bgColor: AppColors.primaryBlueColor)
                                      .paddingOnly(right: 23.w, left: 23.w),
                                ],
                              ).paddingOnly(bottom: 20.h);
                            }

                            if (state is SetAddressPrimarySuccessState) {
                              addressBloc.add(GetUserAddressEvent());
                              return const Center(child: SizedBox());
                            }

                            if (state is GetUserAddressLoadingState) {
                              return const AppCenterLoader();
                            }

                            if (state is GetUserAddressSuccessState) {
                              if (state.userAddress.isEmpty) {
                                return const Center(
                                  child: Text('No Data Found'),
                                );
                              }

                              if ((selectedAddress == null ||
                                  (selectedAddress?.isEmpty ?? false))) {
                                int index = state.userAddress.indexWhere(
                                    (element) => element.isPrimary == true);

                                if (index >= 0) {
                                  selectedAddress = state.userAddress[index].id;
                                }
                              }
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: state.userAddress.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(left: 20.w),
                                              child: Radio(
                                                activeColor:
                                                    AppColors.primaryBlueColor,
                                                value:
                                                    state.userAddress[index].id,
                                                groupValue: selectedAddress,
                                                onChanged: (value) {
                                                  selectedAddress = value;

                                                  addressBloc.add(
                                                      SetPrimaryAddressEvent(
                                                          addressId: value));

                                                  // setState(() {});
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 17.w,
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${state.userAddress[index].streetName} ',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              (state.userAddress[index]
                                                          .isPrimary ??
                                                      false)
                                                  ? '(default)'
                                                  : '',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          var value = await Get.to(
                                            () => MapAddressScreen(
                                                userAddress:
                                                    state.userAddress[index]),
                                          );

                                          if (value != null) {
                                            addressBloc
                                                .add(GetUserAddressEvent());
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 20.w),
                                          child: const SvgImage(
                                            image: AssetsUtils.forwardArrow,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const DividerWidget(),
                              );
                            }

                            return const SizedBox();
                          },
                          listener: (context, state) {},
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            buildButton(
                    context: context,
                    title: "Add New Address",
                    onPressed: () async {
                      var value = await Get.to(
                        () => const MapAddressScreen(),
                      );

                      if (value != null) {
                        selectedAddress = null;
                        addressBloc.add(GetUserAddressEvent());
                      }
                    },
                    textColor: AppColors.whiteColor,
                    bgColor: AppColors.primaryBlueColor)
                .paddingOnly(right: 23.w, left: 23.w),
          ],
        ).paddingOnly(bottom: 20.h),
      ),
    );
  }
}
