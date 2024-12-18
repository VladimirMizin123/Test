import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/card_bloc/card_bloc.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/models/stripe_card_model.dart';
import 'package:gymeats_mobile/screen/restaurants/credit_card.dart';
import 'package:gymeats_mobile/service/toast_service.dart';
import 'package:ml_card_scanner/ml_card_scanner.dart';

class CardCrudScreen extends StatefulWidget {
  const CardCrudScreen({
    super.key,
    required this.cardBloc,
    this.card,
    this.deleteAccess = true,
  });
  final CardBloc cardBloc;
  final StripeCard? card;
  final bool deleteAccess;

  @override
  State<CardCrudScreen> createState() => _CardCrudScreenState();
}

class _CardCrudScreenState extends State<CardCrudScreen> {
  TextEditingController cardName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cvvNumber = TextEditingController();
  RxBool deleteLoader = false.obs;
  CardInfo? _cardInfo;
  bool saveLoader = false;
  bool defaultCardLoader = false;
  var controller = MaskedTextController(mask: '00/0000');

  final formKey = GlobalKey<FormState>();

  String formatCardNumber(String cardNumber) {
    return cardNumber
        .replaceAllMapped(RegExp(r'.{1,4}'), (match) => '${match.group(0)} ')
        .trim();
  }

  getData() {
    if (widget.card != null) {
      cardName.text = widget.card?.name ?? "";
      cardNumber.text =
          formatCardNumber((widget.card?.last4 ?? "").padLeft(16, 'x'));
      controller.text =
          '${widget.card?.expMonth.toString().padLeft(2, '0')}/${widget.card?.expYear}';
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.card != null;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<CardBloc, CardState>(
          bloc: widget.cardBloc,
          listener: (context, state) {
            if (state is CardSuccessState) {
              ToastService.showToast(
                  "Card ${isEdit ? "updated" : "added"} successfully",
                  isSuccess: true);
              if (Get.currentRoute.contains('CardCrudScreen')) {
                Get.back();
              }
            }

            if (state is CardAddLoadingState) {
              saveLoader = state.isLoad;
              setState(() {});
            }

            if (state is SetDefaultCardLoader) {
              defaultCardLoader = state.isLoad;
              setState(() {});
            }

            if (state is CardRemoveSuccessState) {
              ToastService.showToast(StringUtils.cardRemovedSuccessfully,
                  isSuccess: true);
            }

            if (state is CardRemoveLoadingState) {
              deleteLoader.value = state.isLoad;
            }
          },
          builder: (_, __) {
            return Stack(
              children: [
                SafeArea(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isEdit
                                      ? StringUtils.editCard
                                      : StringUtils.addCard,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          color: const Color(0xFF010101)),
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
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 4.h, top: 10.h),
                                  child: Text('Name',
                                      style: TextStyle(
                                          color: const Color(0xff373737),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w300)),
                                ),
                                commonTextField(
                                  label: 'Please Enter Name',
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter Name';
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: cardName,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 4.h, top: 10.h),
                                  child: Text(
                                    'Card number',
                                    style: TextStyle(
                                      color: const Color(0xff373737),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                commonTextField(
                                  label: 'Please Card number',
                                  readOnly: isEdit,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Card number';
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: cardNumber,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(16),
                                    CardNumberFormatter(),
                                  ],
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 13),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await Get.to(() => const CreditCard())!
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              _cardInfo = value;
                                              cardNumber.text =
                                                  _cardInfo?.number ?? "";
                                            });
                                          }
                                        });
                                      },
                                      child: Image.asset(
                                        AssetsUtils.scanner,
                                        height: 10.h,
                                        width: 10.w,
                                        color: AppColors.darkGray,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 4.h, top: 10.h),
                                            child: Text('Valid until',
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff373737),
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          ),
                                          commonTextField(
                                            label: 'MM/YYYY',
                                            controller: controller,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please Enter Month/Month';
                                              } else {
                                                return null;
                                              }
                                            },
                                            onChanged: (value) {},
                                            maxLength: 6,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]'))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 4.h, top: 10.h),
                                            child: Text('CVV',
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff373737),
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          ),
                                          commonTextField(
                                            label: '***',
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please Enter CVV Number';
                                              } else {
                                                return null;
                                              }
                                            },
                                            maxLength: 3,
                                            controller: cvvNumber,
                                            suffixIcon: const Icon(
                                              Icons.info_outline,
                                              color: AppColors.darkGray,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!(widget.card?.isPrimary ?? false) && isEdit) ...[
                          GestureDetector(
                            onTap: () {
                              widget.cardBloc.add(
                                SetDefaultCardEvent(
                                  id: widget.card?.id ?? "",
                                  onComplete: () {
                                    ToastService.showToast(
                                      "${widget.card?.brand ?? ""} card set as default",
                                      isSuccess: true,
                                    );
                                    if (Get.currentRoute
                                        .contains('CardCrudScreen')) {
                                      Get.back();
                                    }
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "Set as default",
                              style: FontUtils.h16(
                                fontColor: AppColors.terracotta,
                                fontWeight: FWT.medium,
                              ),
                            ),
                          ),
                          20.height,
                        ],
                        GestureDetector(
                          onTap: () async {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }

                            List<String> valid = controller.text.split("/");
                            int expMonth = valid.isNotEmpty
                                ? int.tryParse(valid[0]) ?? 0
                                : 0;
                            int expYear = valid.length > 1
                                ? int.tryParse(valid[1]) ?? 0
                                : 0;

                            Map<String, dynamic> req = {
                              "exp_month": expMonth,
                              "exp_Year": expYear,
                              "name": cardName.text,
                            };

                            if (!isEdit) {
                              req["number"] =
                                  cardNumber.text.replaceAll(" ", "");
                              req["cvc"] = cvvNumber.text;
                            } else {
                              req["id"] = widget.card?.id;
                            }

                            widget.cardBloc.add(
                              CreateOrEditCardEvent(
                                card: req,
                                isAdd: !isEdit,
                              ),
                            );
                          },
                          child: Container(
                            height: 45.h,
                            margin: EdgeInsets.only(
                                bottom: 20.h, left: 20, right: 20),
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: const Color(0xffCE6B53),
                            ),
                            child: Center(
                              child: saveLoader
                                  ? const CircularProgressIndicator(
                                      color: AppColors.whiteColor,
                                    )
                                  : Text(
                                      'Save',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Avenir',
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        if (isEdit && widget.deleteAccess) ...[
                          GestureDetector(
                            onTap: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return Obx(
                                    () => Constant.i.deleteAlertDialog(
                                      title: StringUtils.cards,
                                      desc: StringUtils
                                          .areYouSureDoYouWantToDeleteCard,
                                      onTap: () => widget.cardBloc.add(
                                        RemoveCardEvent(
                                          id: widget.card?.id ?? "",
                                          onSuccess: () {
                                            Get.back();
                                            if (Get.currentRoute
                                                .contains('CardCrudScreen')) {
                                              Get.back();
                                            }
                                          },
                                        ),
                                      ),
                                      buttonLoader: deleteLoader.value,
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 45.h,
                              margin: EdgeInsets.only(
                                  bottom: 20.h, left: 20, right: 20),
                              width: Get.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: const Color(0xffCE6B53),
                              ),
                              child: Center(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Avenir',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (defaultCardLoader) const CustomTextLoader(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget commonTextField({
    String? Function(String?)? validator,
    String? label,
    Widget? suffixIcon,
    TextEditingController? controller,
    int? maxLength,
    Function(String)? onChanged,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      controller: controller,
      readOnly: readOnly,
      onChanged: onChanged,
      maxLength: maxLength,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyle(
        color: Color(0xdd000000),
      ),
      decoration: InputDecoration(
        counterText: '',
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10.w),
        hintText: label,
        hintStyle: TextStyle(
          color: const Color(0xff5F5F5F),
          fontWeight: FontWeight.w300,
          fontSize: 14.sp,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.w,
          ),
        ),
        errorStyle: const TextStyle(color: Colors.red),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: const Color(0xffC7C8CA),
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: const Color(0xffC7C8CA),
            width: 1.w,
          ),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var inputText = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var bufferString = StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    var string = bufferString.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}

class CustomTextLoader extends StatelessWidget {
  const CustomTextLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
      child: Align(
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 25,
                width: 25,
                child: Platform.isIOS
                    ? const CupertinoActivityIndicator()
                    : const CircularProgressIndicator(),
              ),
              (Platform.isIOS ? 10 : 15).width,
              const Text(
                "Please wait...",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Avenir',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
