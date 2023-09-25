import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/create_new_password/create_new_password_screen.dart';

String apiKey = "AIzaSyAcB_GmcECnoEZ5dg373aOezNEVZCxUn98"; //from google json
String appId = '1:1041946139722:android:4ab099b1807f65c6555ab3'; //from firebase
String messagingSenderId = '1041946139722';
String projectId = 'gymeats-44b7a'; // from google json

Future<void> initDynamicLinks() async {
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();
  debugPrint('initialLink uri: $initialLink');
  handleDeepLink(initialLink);

  FirebaseDynamicLinks.instance.onLink
      .listen((PendingDynamicLinkData? linkData) {
    handleDeepLink(linkData);
  });
}

void handleDeepLink(PendingDynamicLinkData? initialLink) {
  if (initialLink != null) {
    final Uri deepLink = initialLink.link;

    debugPrint('initialLink deepLink: $deepLink');

    // Handle the deep link here, e.g., parse the resetToken
    String resetToken = deepLink.queryParameters['resetToken'].toString();
    if (resetToken.isNotEmpty && resetToken != '') {
      // GetPage(
      //   name: '/CreateNewPasswordScreen',
      //   page: () => const CreateNewPasswordScreen(),
      //   arguments: resetToken,
      // );
      Get.toNamed('/setNewPassword', arguments: resetToken);
    }
  }
}
