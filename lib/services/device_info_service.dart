import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  final deviceInfo = DeviceInfoPlugin();
  Future<String?> getDeviceId() async {
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;

      // *GETTING UNIQUE ID FOR IOS DEVICE
      return iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;

      // *GETTING UNIQUE ID FOR ANDROID DEVICE
      return androidDeviceInfo.id;
    }
  }
}
