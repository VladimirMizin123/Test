import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/main.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
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

  late final Player player = Player();
  late final VideoController controller;

  @override
  void initState() {
    controller = VideoController(player, configuration: configuration.value);

    player.open(Media("asset:///$videoPath"));
    player.setPlaylistMode(PlaylistMode.loop);
    player.stream.error.listen((error) => debugPrint(error));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appLinks = AppLinks();
      appLinks.uriLinkStream.listen((uri) async {
        if (uri.path == '/auth/setNewPassword') {
          final token = PreferenceUtils.getString(forgetPassToken);
          if (token != '') {
            // navigate to password reset screen
            player.pause();
            await Get.offAllNamed('/setNewPassword');
            player.play();
          } else {
            showToast(message: 'Link has Expired', isSuccess: false);
          }
        } else {
          player.pause();
          await Get.offAllNamed('/LoginScreen');
          player.play();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: context.height,
            width: context.width,
            color: Colors.red,
            child: Video(
              controller: controller,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              controls: (state) => const SizedBox.shrink(),
              pauseUponEnteringBackgroundMode: true,
              resumeUponEnteringForegroundMode: true,
            ),
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
                    onPressed: () async {
                      player.pause();
                      await Get.toNamed('/GymEatsMenuScreen');
                      player.play();
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
