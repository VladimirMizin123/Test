// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

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
      body: Column(
        children: [
          // Expanded(
          //   child: Container(
          //     height: 300.h,
          //     width: 300.w,
          //     child: QRView(
          //       overlay: QrScannerOverlayShape(
          //         borderColor: Colors.white,
          //         borderRadius: 8.r,
          //         borderLength: 30.w,
          //         borderWidth: 10.w,
          //         cutOutHeight: 300.h,
          //         cutOutWidth: 300.w,
          //       ),
          //       cameraFacing: CameraFacing.front,
          //       key: _qrKey,
          //       onQRViewCreated: _onQRViewCreated,
          //     ),
          //   ),
          // ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                AssetsUtils.searchPen,
                height: 35.h,
                width: 35.w,
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
                  isFlashlightOn ? AssetsUtils.flashOn : AssetsUtils.flashOff,
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
// void _onQRViewCreated(QRViewController controller) {
//   qrController = controller;
//   controller.scannedDataStream.listen((scanData) {
//     // Handle scanned data
//     print("Scanned Data: ${scanData.code}");
//   });
// }
}
