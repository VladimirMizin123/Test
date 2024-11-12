// import 'package:camera/camera.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/screen/journal/barcode_grocery_item_details.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:torch_light/torch_light.dart';

class ScanBarcodeScreen extends StatefulWidget {
  const ScanBarcodeScreen({
    super.key,
    /*required this.cameras*/
  });

  // final List<CameraDescription> cameras;

  @override
  State<ScanBarcodeScreen> createState() => _ScanBarcodeScreenState();
}

class _ScanBarcodeScreenState extends State<ScanBarcodeScreen> {
  final routeName = '/ScanBarcodeScreen';
  bool isFlashlightOn = false;
  bool isSearchFieldOn = false;
  TextEditingController upcNumberController = TextEditingController();
  String upcNumber = '';
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController _qrViewController;
  ScanBarcodeArguments scanBarcodeArguments = Get.arguments;

  //
  // CameraController? controller;
  // QRViewController? qrController;
  // final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  // @override
  // void initState() {
  //   super.initState();
  //   controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
  //   controller!.initialize().then((_) {
  //     if (!mounted) {
  //       return;
  //     }
  //     setState(() {});
  //   });
  // }

  // @override
  // void dispose() {
  //   controller?.dispose();
  //   qrController?.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // if (!controller!.value.isInitialized) {
    //   return Container();
    // }
    return Scaffold(
      backgroundColor: AppColors.darkGray,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.darkGray,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 25.h),
          onPressed: () => Navigator.pop(context),
        ).paddingOnly(left: 10.w),
      ),
      body: isSearchFieldOn == true
          ? Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                autofocus: true,
                keyboardType: TextInputType.number,
                controller: upcNumberController,
                decoration: InputDecoration(
                  hintText: 'Enter UPC Number',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 15.w),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.r),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.r),
                    ),
                  ),
                  suffix: GestureDetector(
                    onTap: () {
                      if (upcNumber.isNotEmpty) {
                        Get.to(
                          () => BarCodeGroceryItemDetails(
                            scanData: upcNumber.toString(),
                            type: scanBarcodeArguments.type,
                            mealType: scanBarcodeArguments.type,
                            selectedDate: scanBarcodeArguments.selectedDateTime,
                          ),
                          transition: Transition.fadeIn,
                        );
                      }
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: upcNumber.isNotEmpty
                            ? const Color(0xffCE6B53)
                            : AppColors.disable,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                onChanged: (value) {
                  upcNumber = value;
                  setState(() {});
                },
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 300.h,
                    width: 300.w,
                    child: QRView(
                      overlay: QrScannerOverlayShape(
                        borderColor: Colors.white,
                        borderRadius: 8.r,
                        borderLength: 10.w,
                        borderWidth: 10.w,
                        cutOutHeight: 300.h,
                        cutOutWidth: 300.w,
                      ),
                      cameraFacing: CameraFacing.back,
                      formatsAllowed: const [
                        BarcodeFormat.upcA,
                        BarcodeFormat.upcE,
                        BarcodeFormat.ean13,
                      ],
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSearchFieldOn = true;
                        });
                      },
                      child: Image.asset(
                        AssetsUtils.searchPen,
                        height: 35.h,
                        width: 35.w,
                      ),
                    ),
                    GestureDetector(
                      onTap: isFlashlightOn
                          ? () async {
                              await TorchLight.disableTorch();
                              setState(() {
                                isFlashlightOn = false; // Update the state
                              });
                            }
                          : () async {
                              await TorchLight.enableTorch();
                              setState(() {
                                isFlashlightOn = true; // Update the state
                              });
                            },
                      child: Image.asset(
                        isFlashlightOn
                            ? AssetsUtils.flashOn
                            : AssetsUtils.flashOff,
                        height: 35.h,
                        width: 35.w,
                      ),
                    ),
                  ],
                )
              ],
            ).paddingOnly(left: 20.w, right: 20.w, bottom: 35.h),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrViewController = controller;
      _qrViewController.resumeCamera();
    });
    _qrViewController.scannedDataStream.listen((scanData) {
      log('scanData: ${scanData.code}');
      // widget.onBarcodeFetched(scanData);
      _qrViewController.dispose();
      // scanBarcodeArguments.journalPlanBloc.add(JournalScanBarcodeEvent(barcode: scanData.code!));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return BarCodeGroceryItemDetails(
          scanData: scanData.code,
          mealType: scanBarcodeArguments.type,
          selectedDate: scanBarcodeArguments.selectedDateTime,
        );
      }));
      // Get.toNamed('/GroceryItemDetails', arguments: GroceryItemDetailsArguments(groceryShoppingData: GroceryShoppingData()));
      // Get.offNamed('/MealDetailsScreen', arguments: MealPlanArguments(isFromScanner: true, productName: '', currentSelectedData: scanBarcodeArguments.selectedDateTime, barcodeNumber: scanData.code));
      // Navigator.of(context).pop();
    });
  }

// void _onQRViewCreated(QRViewController controller) {
//   qrController = controller;
//   controller.scannedDataStream.listen((scanData) {
//     // Handle scanned data
//     print("Scanned Data: ${scanData.code}");
//   });
// }
}

class ScanBarcodeArguments {
  final JournalPlanBloc journalPlanBloc;
  final DateTime? selectedDateTime;
  final String type;

  ScanBarcodeArguments(
      {this.selectedDateTime, required this.journalPlanBloc, this.type = ''});
}
