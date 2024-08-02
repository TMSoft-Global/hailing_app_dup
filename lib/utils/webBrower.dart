import 'package:flutter/material.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebBrowser extends StatefulWidget {
  final String? url, previousPage, title;
  final Map<String, dynamic>? meta;

  const WebBrowser({
    super.key,
    @required this.previousPage,
    @required this.url,
    @required this.title,
    this.meta,
  });

  @override
  State<WebBrowser> createState() => _WebBrowerState();
}

class _WebBrowerState extends State<WebBrowser> {
  WebViewController? _controller;

  void _initialiseWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          // onNavigationRequest: (NavigationRequest request) {
          //   if (request.url.startsWith('https://www.youtube.com/')) {
          //     return NavigationDecision.prevent;
          //   }
          //   return NavigationDecision.navigate;
          // },
        ),
      )
      ..loadRequest(Uri.parse(widget.url!));
  }

  @override
  void initState() {
    super.initState();
    _initialiseWebView();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool invoke) {
        if (invoke) {
          return;
        }
        _onClose();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title!),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.close, color: BColors.black),
              onPressed: () => _onClose(),
            ),
          ),
          body: WebViewWidget(controller: _controller!)),
    );
  }

  void _onClose() {
    Navigator.of(context).pop();
    if (widget.previousPage == "back") {
      Navigator.of(context).pop();
    }
  }
}
