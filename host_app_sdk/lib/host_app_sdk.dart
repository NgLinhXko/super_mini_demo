library host_app_sdk;

import 'package:flutter/material.dart';
import 'src/mini_app_widget.dart';

class HostAppSDK {
  static void openMiniApp({
    required BuildContext context,
    required String url,
    required Map<String, dynamic> data,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MiniAppWidget(url: url, initData: data),
      ),
    );
  }
}
