import 'dart:async';
import 'dart:convert';
import 'dart:js';
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:mp_mini_app/CallbackToHostMethod.dart';
import 'package:mp_mini_app/DataManager.dart';
import 'package:mpflutter_core/mpflutter_core.dart';
import 'package:mpflutter_wechat_button/mpflutter_wechat_button.dart';

// final ValueNotifier<UserStateModel> userInfoNotifier =
// ValueNotifier(UserStateModel(LoadState.loading, "..."));

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // js.context['receiveFromHost'] = allowInterop((dynamic jsonData) {
  //
  //   String? username;
  //
  //   if (jsonData is JsObject) {
  //     username = jsonData['username'];
  //   } else if (jsonData is String) {
  //     try {
  //       final data = jsonDecode(jsonData);
  //       username = data['username'];
  //     } catch (e) {
  //     }
  //   }
  //
  //   if (username != null) {
  //     userInfoNotifier.value = UserStateModel(LoadState.success, username);
  //   } else {
  //     userInfoNotifier.value = UserStateModel(LoadState.fail, "Unknown");
  //   }
  // });

  // // Timeout sau 5 giây nếu không có dữ liệu
  // Future.delayed(const Duration(seconds: 5), () {
  //   if (userInfoNotifier.value.state == LoadState.loading) {
  //     print("⏰ Timeout nhận dữ liệu");
  //     userInfoNotifier.value = UserStateModel(LoadState.fail, "Timeout");
  //   }
  // });

  runApp(const MiniApp());
}

class MiniApp extends StatelessWidget {
  const MiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Mini App')),
        body: ContentView(),
      ),
    );
  }
}

class ContentView extends StatefulWidget {
  const ContentView({super.key});

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  final ValueNotifier<UserStateModel> stateData =
      ValueNotifier<UserStateModel>(UserStateModel(LoadState.loading, "..."));
  @override
  void initState() {
    super.initState();

    DataManager().getTokenFromMini(onState: (state) {
      stateData.value = state;
    });
    print("ContentView mounted");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder<UserStateModel>(
        valueListenable: stateData,
        builder: (context, value, _) {
          final state = value.state;
          final username = value.username;

          if (state == LoadState.loading) {
            return const CircularProgressIndicator();
          } else if (state == LoadState.success) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome, $username to MiniApp!',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                // TextButton(
                //   onPressed: () {
                //     CallbackToHostMethod.instance.sendReloadCommandToHost();
                //   },
                //   child: Text("Click Me"),
                // ),
                MPFlutter_Wechat_Button(
                  child: MaterialButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onPressed: () {
                      print("Button clicked");
                      CallbackToHostMethod.instance.sendReloadCommandToHost();
                    },
                    child: const Text(
                      'Test MPButton',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 10),
                Text('Load failed: $username',
                    style: const TextStyle(fontSize: 16)),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    print("ContentView disposed");
    super.dispose();
  }
}
