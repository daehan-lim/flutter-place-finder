import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class MapLauncherService {
  static Future<void> openInMap(String queryAddress) async {
    final encoded = Uri.encodeComponent(queryAddress);

    if (Platform.isIOS) {
      final appName = 'com.daehan.firstApp';
      final naverUri = Uri.parse(
        'nmap://search?query=$encoded&appname=$appName',
      );

      if (await canLaunchUrl(naverUri)) {
        await launchUrl(naverUri, mode: LaunchMode.externalApplication);
        print('opened in Naver Map');
      } else {
        print('Naver Map not available. Falling back to Apple Maps');
        final appleUri = Uri.parse('http://maps.apple.com/?q=$encoded');
        if (await canLaunchUrl(appleUri)) {
          await launchUrl(appleUri, mode: LaunchMode.externalApplication);
        } else {
          print('Failed to open Apple Maps');
        }
      }
    } else {
      final geoUri = Uri.parse('geo:0,0?q=$encoded');
      try {
        await launchUrl(geoUri, mode: LaunchMode.externalApplication);
      } catch (e) {
        print('Could not launch map: $e');
      }
    }
  }
}