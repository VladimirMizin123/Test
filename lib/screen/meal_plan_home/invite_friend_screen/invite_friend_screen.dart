import 'package:flutter/material.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';

class InviteFriendScreen extends StatelessWidget {
  const InviteFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(children: [
        Image(
          image: AssetImage(AssetsUtils.inviteFriendBg),
          height: screenSize.height,
          width: screenSize.width,
          fit: BoxFit.cover,
        ),
      ]),
    );
  }
}
