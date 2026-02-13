import 'package:url_launcher/url_launcher.dart';

Future<void> openAppStore(String platform, String appstoreId) async {
  final Uri storeUrl;

  if (platform == 'ios') {
    storeUrl = Uri.parse('https://apps.apple.com/app/id$appstoreId');
  } else {
    storeUrl = Uri.parse(
      'https://play.google.com/store/apps/details?id=$appstoreId',
    );
  }

  try {
    await launchUrl(storeUrl, mode: LaunchMode.externalApplication);
  } catch (e) {
    // Silently fail — caller can handle errors if needed
  }
}
