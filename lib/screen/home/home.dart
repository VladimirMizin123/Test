import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/models/sign_up_model.dart';
import 'package:video_player/video_player.dart';
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
  //final videoPath = "assets/video/big_buck_bunny_720p_30mb.mp4";
  final videoPath = "assets/video/gym_eats_presentation.mp4";
  late VideoPlayerController _videoPlayerController;
  // late ChewieController chewieController;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.asset(videoPath)
      ..initialize().then((_) => setState(() {
            _videoPlayerController.play();
            _videoPlayerController.setLooping(true);
          }));
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
      body: Stack(
        children: [
          if (_videoPlayerController.value.isInitialized)
            Center(
              child: VideoPlayer(_videoPlayerController),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  SizedBox(height: 50.h),
                  buildButton(
                    context: context,
                    title: StringUtils.letsEat,
                    onPressed: () {
                      Get.toNamed('/GymEatsMenuScreen');
                    },
                    bgColor: AppColors.letsEatButton,
                    textColor: AppColors.letsEat,
                  ).paddingSymmetric(horizontal: 20),
                  SizedBox(height: 40.h),
                ],
              )
            ],
          ),
        ],
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
