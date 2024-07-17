import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';

class GetDeviceId {
  Future<String> getId() async {
    try {
      return await FlutterUdid.udid;
    } on MissingPluginException {
      return '';
    }
  }
}
