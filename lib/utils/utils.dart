import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';

class AppUtils {
  static Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor ?? ('<ios-hardcode>${Random().nextDouble() * 99999}');
    } else if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    } else if (Platform.isWindows) {
    } else if (Platform.isMacOS) {}
    return (await deviceInfo.webBrowserInfo).userAgent ?? ('<web-hardcode>${Random().nextDouble() * 99999}');
  }

  static String generateRoomCode() => (Random().nextInt(1000000) + 100000).toString();
}
