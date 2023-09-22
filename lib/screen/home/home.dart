import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/models/sign_up_model.dart';
import '../../constant/string_utils.dart';
import '../../app/sharedPrefrence.dart';
import '../../widget/app_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final routeName = '/';
  final videoPath = "assets/video/gym_eats_presentation.mp4";
  // late VideoPlayerController videoPlayerController;
  // late ChewieController chewieController;

  @override
  void initState() {
    AssetsUtils.welcomeBg;
    AssetsUtils.welcomeLogo;
    super.initState();
    // videoPlayerController =
    //     VideoPlayerController.networkUrl(Uri.parse(videoPath));
    // videoPlayerController.initialize().then((value) {
    //   setState(() {});
    // });
    // chewieController = ChewieController(
    //   videoPlayerController: videoPlayerController,
    //   autoPlay: true,
    //   looping: true,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // print(
    //     "Is Vide Controller Initialized : ${videoPlayerController.value.isInitialized}");
    return Scaffold(
      body: Container(
        height: size.height.h,
        width: size.width.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetsUtils.welcomeBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Image.asset(
                  AssetsUtils.welcomeLogo,
                  height: 160.h,
                  width: 160.w,
                ),
                SizedBox(height: 50.h),
                buildButton(
                  context: context,
                  title: StringUtils.letsEat,
                  onPressed: () {
                    Get.toNamed('/GymEatsMenuScreen');
                  },
                  bgColor: AppColors.letsEatButton,
                  textColor: AppColors.letsEat,
                ),
                SizedBox(height: 40.h),
              ],
            )
          ],
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   videoPlayerController.dispose();
  //   // chewieController.dispose();
  // }
}

//
// Stack(
//   children: [
//     SizedBox.expand(
//       child: FittedBox(
//         fit: BoxFit.cover,
//         child: SizedBox(
//           width: videoController.value.size.width,
//           height: videoController.value.size.height,
//           child: VideoPlayer(videoController),
//         ),
//       ),
//     ),
//   ],
// ),
