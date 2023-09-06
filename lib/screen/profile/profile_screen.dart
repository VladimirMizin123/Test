import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        ListTile(
          title: const Text('LogOut'),
          onTap: () {
            PreferenceUtils.clearPrefs();
            Get.offAllNamed('LoginScreen');
          },
        )
      ]),
    );
  }
}
