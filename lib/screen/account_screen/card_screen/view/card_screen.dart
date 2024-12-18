// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/card_bloc/card_bloc.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/models/stripe_card_model.dart';
import 'package:gymeats_mobile/screen/account_screen/card_screen/view/card_crud_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/credit_card_widget.dart';
import 'package:shimmer/shimmer.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final CardBloc _bloc = CardBloc();
  bool isLoading = false;

  List<StripeCard> cardList = [];
  @override
  void initState() {
    _bloc.add(ListAllCardEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringUtils.cards,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(color: const Color(0xFF010101)),
                    )
                  ],
                ),
                Positioned.fill(
                  left: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: SvgPicture.asset(
                        AssetsUtils.icBackArrow,
                        height: 25.h,
                        width: 25.w,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                ),
              ],
            ).paddingOnly(left: 20, right: 20, top: 10),
            Expanded(
              child: BlocConsumer<CardBloc, CardState>(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is CardLoadingState) {
                    isLoading = state.isLoading;
                    setState(() {});
                  }

                  if (state is CardFetchSuccessState) {
                    cardList = state.cardList;
                    setState(() {});
                  }
                },
                builder: (_, __) {
                  return switch (isLoading) {
                    true => ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                        itemCount: 30,
                        separatorBuilder: (context, index) => 20.height,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: AppColors.lightGrey,
                            highlightColor:
                                AppColors.lightGrey.withOpacity(0.95),
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.disable,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        },
                      ),
                    _ => cardList.isEmpty
                        ? const Center(
                            child: Text(
                              StringUtils.theCardIsNotAvailable,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.darkGreyColor,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                            itemCount: cardList.length,
                            separatorBuilder: (context, index) => 20.height,
                            itemBuilder: (context, index) {
                              return CreditCardWidget(
                                card: cardList[index],
                                onTap: () {
                                  Get.to(
                                    () => CardCrudScreen(
                                      cardBloc: _bloc,
                                      card: cardList[index],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  };
                },
              ),
            ),
            buildButton(
              context: context,
              title: "Add new card",
              onPressed: () {
                Get.to(() => CardCrudScreen(cardBloc: _bloc));
              },
              textColor: AppColors.whiteColor,
              bgColor: AppColors.terracotta,
            ).paddingOnly(right: 23.w, left: 23.w, bottom: 20),
          ],
        ),
      ),
    );
  }
}
