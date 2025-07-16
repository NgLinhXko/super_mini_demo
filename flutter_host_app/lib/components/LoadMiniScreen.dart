import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MiniAppWFile extends StatefulWidget {
  const MiniAppWFile({super.key});

  @override
  State<MiniAppWFile> createState() => _MiniAppWFileState();
}

class _MiniAppWFileState extends State<MiniAppWFile> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          debugPrint("File index.html loaded: $url");
          // sendDataToMini();
        },
      ))
      ..loadFlutterAsset('assets/build/web/index.html');
  }

  void sendDataToMini() {
    final data = {
      "token": "linhngoc_12345",
      "action": "login",
    };
    final jsCode = 'window.receiveFromHost(${jsonEncode(data)})';
    _controller.runJavaScript(jsCode);
    print("✅ Sent data to mini app from file.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini App From File'),
      ),
      body: Expanded(child: WebViewWidget(controller: _controller)),
    );
  }
}

// class MiniAppWithFile2 extends StatefulWidget {
//   @override
//   _MiniAppWithFile2State createState() => _MiniAppWithFile2State();
// }
//
// class _MiniAppWithFile2State extends State<MiniAppWithFile2> {
//   late InAppWebViewController _controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Mini App Demo")),
//       body: InAppWebView(
//         initialFile: 'assets/build/web/index.html',
//         initialOptions: InAppWebViewGroupOptions(
//           crossPlatform: InAppWebViewOptions(
//             javaScriptEnabled: true,
//             allowFileAccessFromFileURLs: true,
//             allowUniversalAccessFromFileURLs: true,
//             useShouldInterceptAjaxRequest: false, // ⚠️ Thêm dòng này
//             supportZoom: false, // ✳️ tránh bật auto zoom lỗi
//             // disableDefaultErrorPageHandling: true,
//           ),
//           android: AndroidInAppWebViewOptions(
//             useShouldInterceptRequest: false, // ⚠️ Cực quan trọng trên Android thấp
//           ),
//         ),
//         onWebViewCreated: (controller) async {
//           _controller = controller;
//           print("wwebb by file is createddddddd================");
//
//           // Đợi mini app load xong, sau đó gửi dữ liệu
//           Future.delayed(Duration(seconds: 1), () async {
//             final data = {
//               'token': 'linhne',
//             };
//
//             await _controller.evaluateJavascript(source: '''
//               window.postMessage(${jsonEncode(data)}, "*");
//             ''');
//           });
//         },
//
//         // Tùy chọn: Lắng nghe console log từ mini app
//         onConsoleMessage: (controller, message) {
//           print("📦 JS LOG: ${message.message}");
//         },
//       ),
//     );
//   }
// }

class MiniAppScreen extends StatefulWidget {
  const MiniAppScreen({super.key});

  @override
  State<MiniAppScreen> createState() => _MiniAppScreenState();
}

class _MiniAppScreenState extends State<MiniAppScreen> {
  late final WebViewController _controller;
  bool _isLoading = true; // 👉 trạng thái loading

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) async {
            debugPrint(" Bắt đầu load: $url");
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) async {
            debugPrint(" Load xong: $url");
            Future.delayed(const Duration(seconds: 10), () {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            });
            final data = {"token": 'tokennn'};
            final script = 'window.receiveFromHost(${jsonEncode(data)})';
            print('Running JS script neeeee =======: $script');
            await _controller.runJavaScript(script);

            await _controller.runJavaScript('''
  window.receiveFromMini = function(data) {
    console.log("Mini gửi về Host:", data);
    if (data && data.reload) {
      window.location.reload(); // 🔁 reload lại chính trang web
    }
  };
''');
          },
          onWebResourceError: (error) {
            debugPrint(" Lỗi khi load WebView:");
            debugPrint("   Error Code: ${error.errorCode}");
            debugPrint("   Description: ${error.description}");
            debugPrint("   Failing URL: ${error.url}");
            Future.delayed(const Duration(seconds: 10), () {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            });
          },
        ),
      )
      // ..loadRequest(Uri.parse('https://miniflutterapp.web.app'));
      ..loadRequest(Uri.parse('http://10.0.2.2:3000'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(), // 👉 loading indicator
            ),
        ],
      ),
    );
  }
}
