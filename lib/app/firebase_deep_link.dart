/*import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

String apiKey = 'AIzaSyAcB_GmcECnoEZ5dg373aOezNEVZCxUn98'; //from google json
String appId = '1:1041946139722:android:dd7ce0ccf0b82cf2555ab3'; //from firebase
String messagingSenderId= '1041946139722';
String projectId = 'gymeats-44b7a'; // from google json

Future<void>  initDynamicLinks() async {
  final PendingDynamicLinkData? initialLink =
  await FirebaseDynamicLinks.instance.getInitialLink();
  if (initialLink != null) {
    final Uri deepLink = initialLink.link;
    print('Deeplinks uri:${deepLink.path}');
    if (deepLink.path == '/ShowApiDataScreen') {

    } else if (deepLink.path == '/GoogleMapScreen') {

    } else if (deepLink.path == '/UserSignUpScreen') {

    }
  }
}*/


/*
Future<void> initDynamicLinks() async {
  final PendingDynamicLinkData? data =
  await FirebaseDynamicLinks.instance.getInitialLink();
  _handleDeepLink(data!);
  FirebaseDynamicLinks.instance.onLink;
  FirebaseDynamicLinks.instance.onLink(
    onSuccess: (PendingDynamicLinkData dynamicLink) async {
      _handleDeepLink(dynamicLink);
    },
    onError: (OnLinkErrorException e) async {
      print('Error handling dynamic link: ${e.message}');
    },
  );
}

void _handleDeepLink(PendingDynamicLinkData data) {
  final Uri deepLink = data.link;

  if (deepLink != null) {
    // Handle the deep link as needed
    print('Deep link received: $deepLink');
    // Example: Navigate to a specific screen based on the deep link
    // Navigator.pushNamed(context, deepLink.path);
  }
}
*/
