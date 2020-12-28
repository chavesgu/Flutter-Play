import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../variable.dart';

class WebView extends StatefulWidget {
  static const name = '/webview';

  WebView(this.url);

  final String url;

  @override
  createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  InAppWebViewController webView;
  int _progress = 0;
  String _windowTitle = 'WebView';

  get url => widget.url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          title: Text(_windowTitle),
          leading: BackButton(
            onPressed: () async {
              if (await webView?.canGoBack()) {
                webView.goBack();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            top: false,
            bottom: false,
            child: Stack(
              children: <Widget>[
                InAppWebView(
                  initialUrl: url,
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      mediaPlaybackRequiresUserGesture: false,
                      javaScriptCanOpenWindowsAutomatically: true,
                    ),
                    android: AndroidInAppWebViewOptions(
                      verticalScrollbarPosition: AndroidVerticalScrollbarPosition.SCROLLBAR_POSITION_RIGHT,
                      cacheMode: AndroidCacheMode.LOAD_CACHE_ELSE_NETWORK
                    ),
                    ios: IOSInAppWebViewOptions(
                      // disallowOverScroll: true,
                      allowsInlineMediaPlayback: true,
                      alwaysBounceVertical: true,
                    ),
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                    // flutter和webview通信
                    webView.addJavaScriptHandler(handlerName: 'push', callback: (arguments) {
                      Navigator.of(context).pushNamed('${WebView.name}?url=${Uri.encodeQueryComponent(arguments.first)}');
                    });
                  },
                  onCreateWindow: (InAppWebViewController controller, CreateWindowRequest request) async {
                    controller.loadUrl(url: request.url);
                    return false;
                  },
                  onProgressChanged: (InAppWebViewController controller, int progress) {
                    setState(() {
                      _progress = progress;
                    });
                  },
                  onTitleChanged: (InAppWebViewController controller, String title) {
                    setState(() {
                      _windowTitle = title;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print("console: " + consoleMessage.message);
                  },
                ),
                _progress!=100?Positioned(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Container(
                        width: width(100),
                        height: width(100),
                        child: CircularProgressIndicator(
                          value: _progress / 100,
                        ),
                      ),
                    ),
                  ),
                ):SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    webView?.removeJavaScriptHandler(handlerName: 'push');
    super.dispose();
  }
}