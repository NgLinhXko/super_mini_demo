import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MiniAppWidget extends StatefulWidget {
  final String url;
  final Map<String, dynamic> initData;

  const MiniAppWidget({
    Key? key,
    required this.url,
    required this.initData,
  }) : super(key: key);

  @override
  State<MiniAppWidget> createState() => _MiniAppWidgetState();
}

class _MiniAppWidgetState extends State<MiniAppWidget> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) async {
            final script =
                'window.receiveFromHost(${jsonEncode(widget.initData)})';
            await _controller.runJavaScript(script);

            await _controller.runJavaScript('''
              window.receiveFromMini = function(data) {
                console.log("Mini gửi về Host:", data);
                if (data && data.reload) {
                  window.location.reload();
                }
              };
            ''');

            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) setState(() => _isLoading = false);
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
