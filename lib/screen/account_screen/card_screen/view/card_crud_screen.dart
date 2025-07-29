import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
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
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

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
  final ApiServices _api = ApiServices();
CardFieldInputDetails? _cardFieldInput;
  final formKey = GlobalKey<FormState>();
String? _clientSecret;
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
    } else {
      initStripeCardFlow();
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

Future<void> initStripeCardFlow() async {
  try {
    final response = await _api.get(ApiUrls.getCardIntent);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body)['data'];

      final setupIntentClientSecret = data['cardIntentClientSecret'];
      final ephemeralKey = data['ephemeralKey'];
      final customerId = data['stripeCustomerId'];
      final publishableKey = data['publishableKey'];

      Stripe.publishableKey = publishableKey;

      await Stripe.instance.applySettings(); 

      _clientSecret = setupIntentClientSecret;
    } else {
      print('error Stripe');
    }
  } catch (e) {
    print("Stripe flow: $e");
  }
}

Future<void> confirmCard() async {
  try {
    if (_cardFieldInput == null || !_cardFieldInput!.complete) {
      print(_cardFieldInput);
      print('Please fill in all card details');
      return;
    }

    if (_clientSecret == null) {
      print('Stripe secret not initialized');
      return;
    }

    setState(() => saveLoader = true);

    final billingDetails = BillingDetails(
      name: cardName.text,
    );

    final paymentMethodData = PaymentMethodData(
      billingDetails: billingDetails,
    );

    final params = PaymentMethodParams.card(
      paymentMethodData: paymentMethodData,
    );

    final result = await Stripe.instance.confirmSetupIntent(
      paymentIntentClientSecret: _clientSecret!,
      params: params,
    );

    print('Card setup completed: ${result.id}');
  } catch (e) {
    print('Error saving card: $e');
  } finally {
    setState(() => saveLoader = false);
  }
}

 @override
Widget build(BuildContext context) {
  bool isEdit = widget.card != null;

  return GestureDetector(
    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Text(
                    isEdit ? "Edit Card" : "Add Card",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: const Color(0xFF010101),
                        ),
                  ),
                ),
                Positioned(
                  left: 20,
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
              ],
            ).paddingOnly(left: 20, right: 20, top: 10),

            Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text('Name',
                          style: TextStyle(
                            color: Color(0xff373737),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          )),
                      commonTextField(
                        label: 'Please Enter Name',
                        controller: cardName,
                        validator: (v) => v!.isEmpty ? 'Please Enter Name' : null,
                      ),

                      const SizedBox(height: 20),
                      Text('Card details',
                          style: TextStyle(
                            color: Color(0xff373737),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          )),

                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffCFCFCF)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CardField(
                          enablePostalCode: false,
                          onCardChanged: (details) {
                            setState(() => _cardFieldInput = details);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

                          GestureDetector(
                            onTap: () async {
                await confirmCard();
              },
              child: Container(
                height: 45.h,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20.h),
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
                          'Add Card',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ),

            if (isEdit && widget.deleteAccess)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Obx(
                      () => Constant.i.deleteAlertDialog(
                        title: "Card",
                        desc: "Are you sure you want to delete this card?",
                        onTap: () => widget.cardBloc.add(
                          RemoveCardEvent(
                            id: widget.card?.id ?? "",
                            onSuccess: () {
                              Get.back(); // close dialog
                              if (Get.currentRoute.contains('CardCrudScreen')) {
                                Get.back(); // close screen
                              }
                            },
                          ),
                        ),
                        buttonLoader: deleteLoader.value,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 45.h,
                  margin: EdgeInsets.only(bottom: 20.h, left: 20, right: 20),
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
                      ),
                    ),
                  ),
                ),
              ),

            if (defaultCardLoader) const CustomTextLoader(),
          ],
        ),
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
