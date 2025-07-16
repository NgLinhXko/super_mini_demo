import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:host_app_sdk/host_app_sdk.dart';

import 'components/LoadMiniScreen.dart';

void main() {
  runApp(const HostApp());
}

class HostApp extends StatelessWidget {
  const HostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Host App',
        home: Scaffold(
          appBar: AppBar(
            title: Text("HostApp"),
          ),
          backgroundColor: Colors.white,
          body: HostAppScreen(),
        ));
  }
}

class HostAppScreen extends StatefulWidget {
  const HostAppScreen({super.key});

  @override
  State<HostAppScreen> createState() => _HostAppScreenState();
}

class _HostAppScreenState extends State<HostAppScreen> {
  late final TextEditingController _inputController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _inputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _inputController,
            decoration: const InputDecoration(
              labelText: 'Enter anything',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              print('Token: $value');
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              openWithSDK();
              // openWithFile();
            },
            child: Text(
              'Click to go mini App w link deploy',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              // openMiniApp();
              openMiniScreenApp();
            },
            child: Text(
              'Click to go mini App w localhost',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void openWithSDK() {
    final data = {
      "token": _inputController.text,
    };
    HostAppSDK.openMiniApp(
        context: context, url: "https://miniflutterapp.web.app", data: data);
    // ..loadRequest(Uri.parse('https://miniflutterapp.web.app'));
    // ..loadRequest(Uri.parse('http://10.0.2.2:3000'));
  }

  void openMiniScreenApp() {
    final data = {
      "token": _inputController.text,
    };
    HostAppSDK.openMiniApp(
        context: context, url: "http://10.0.2.2:3000", data: data);
    // ..loadRequest(Uri.parse('https://miniflutterapp.web.app'));
    // ..loadRequest(Uri.parse('http://10.0.2.2:3000'));
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => MiniAppScreen()),
    // );
  }
}
