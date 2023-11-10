import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:ml_card_scanner/ml_card_scanner.dart';

class CreditCard extends StatefulWidget {
  const CreditCard({Key? key}) : super(key: key);

  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  // CardDetails? _cardDetails;
  // CardScanOptions scanOptions = const CardScanOptions(
  //   scanCardHolderName: true, scanExpiryDate: true,
  //   enableDebugLogs: true,
  //   validCardsToScanBeforeFinishingScan: 5,
  //   // possibleCardHolderNamePositions: [
  //   //   CardHolderNameScanPosition.aboveCardNumber,
  //   // ],
  // );
  // //
  // Future<void> scanCard() async {
  //   final CardDetails? cardDetails =
  //       await CardScanner.scanCard(scanOptions: scanOptions);
  //
  //   print('------->>>>${cardDetails!.cardNumber}');
  //
  //   print('--------------------->>>$cardDetails');
  // }

  CardInfo? _cardInfo;
  final ScannerWidgetController _controller = ScannerWidgetController();
  @override
  void initState() {
    _controller
      ..setCardListener((value) {
        setState(() {
          _cardInfo = value;

          Get.back(result: _cardInfo);
          print('==_cardInfo====>$_cardInfo');
        });
      })
      ..setErrorListener((exception) {
        if (kDebugMode) {
          print('Error: ${exception.message}');
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // MaterialButton(
              //   color: Colors.blue,
              //   onPressed: () async {
              //     // scanCard();
              //   },
              //   child: const Text('scan card'),
              // ),
              // Text('$_cardDetails'),
              Expanded(
                child: ScannerWidget(
                  controller: _controller,
                  overlayOrientation: CardOrientation.landscape,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
