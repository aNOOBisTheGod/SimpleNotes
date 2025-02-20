import 'package:flutter/services.dart';

enum AppFlavors { dev, prod }

class FlavorsManager {
  AppFlavors getAppMode() {
    if (appFlavor == 'dev') {
      return AppFlavors.dev;
    } else {
      return AppFlavors.prod;
    }
  }
}
