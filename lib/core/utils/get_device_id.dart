import 'package:flutter_udid/flutter_udid.dart';

class GetDeviceId {
  Future<String> getId() async {
    return await FlutterUdid.udid;
  }
}
