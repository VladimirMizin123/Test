import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.text,
    required this.btnText,
    required this.onConfirm,
  });
  final String text;
  final String btnText;
  final Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: IntrinsicHeight(
        child: Material(
          color: Colors.transparent,
          child: Align(
            child: GestureDetector(
              onTap: () => {},
              child: IntrinsicHeight(
                child: Container(
                  width: context.width * 0.9,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: FontUtils.h20(
                            fontColor: AppColors.darkGray,
                            fontWeight: FWT.semiBold),
                      ),
                      20.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: simpleTextBorderButton(
                              height: 48,
                              context: context,
                              buttonLable: StringUtils.cancel,
                              onTap: () => Get.back(),
                              isDarkColor: true,
                            ),
                          ),
                          10.width,
                          Expanded(
                            child: simpleTextBorderButton(
                              height: 48,
                              context: context,
                              buttonLable: btnText,
                              onTap: () => onConfirm.call(),
                              isDarkColor: true,
                              isFillColor: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
