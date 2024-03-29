import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:webview_flutter/webview_flutter.dart';

import '../../variable.dart';

class MyWebView extends StatefulWidget {
  static const name = '/webview';

  MyWebView();

  @override
  createState() => _WebViewState();
}

class _WebViewState extends State<MyWebView>
    with SingleTickerProviderStateMixin {
  InAppWebViewController? controller;
  int _progress = 0;
  String _windowTitle = 'WebView';
  StateSetter titleStateSetter = (VoidCallback fn) {};
  StateSetter progressStateSetter = (VoidCallback fn) {};

  get url => Get.parameters['url'] ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        title: StatefulBuilder(
          builder: (context, _setState) {
            titleStateSetter = _setState;
            return Text(_windowTitle);
          },
        ),
        leading: BackButton(
          onPressed: () async {
            if (controller != null && await controller!.canGoBack()) {
              controller!.goBack();
            } else {
              Get.back();
            }
          },
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            top: false,
            bottom: true,
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                ),
                InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.parse(url)),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      supportZoom: false,
                      mediaPlaybackRequiresUserGesture: false,
                      transparentBackground: true,
                      // javaScriptCanOpenWindowsAutomatically: true,
                    ),
                    android: AndroidInAppWebViewOptions(
                      verticalScrollbarPosition:
                          AndroidVerticalScrollbarPosition
                              .SCROLLBAR_POSITION_RIGHT,
                      cacheMode: AndroidCacheMode.LOAD_CACHE_ELSE_NETWORK,
                    ),
                    ios: IOSInAppWebViewOptions(
                      disallowOverScroll: false,
                      allowsInlineMediaPlayback: true,
                      alwaysBounceVertical: true,
                      suppressesIncrementalRendering: true,
                      limitsNavigationsToAppBoundDomains: true,
                    ),
                  ),
                  onWebViewCreated: (InAppWebViewController c) {
                    controller = c;
                    // flutter和webview通信
                    controller!.addJavaScriptHandler(
                        handlerName: 'push',
                        callback: (arguments) {
                          Get.toNamed(
                              '${MyWebView.name}?url=${Uri.encodeQueryComponent(arguments.first)}');
                        });
                  },
                  onCreateWindow: (InAppWebViewController controller,
                      CreateWindowAction request) async {
                    controller.loadUrl(
                        urlRequest: URLRequest(url: request.request.url));
                    return false;
                  },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    progressStateSetter(() {
                      _progress = progress;
                    });
                  },
                  onTitleChanged:
                      (InAppWebViewController controller, String? title) {
                    if (title != null) {
                      titleStateSetter(() {
                        _windowTitle = title;
                      });
                    }
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print("console: " + consoleMessage.message);
                  },
                ),
                StatefulBuilder(builder: (context, _setState) {
                  progressStateSetter = _setState;
                  return _progress != 100
                      ? Positioned(
                          width: vw,
                          top: 0,
                          left: 0,
                          child: LinearProgressIndicator(
                            value: _progress / 100,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xff07c160)),
                            minHeight: 2,
                          ),
                        )
                      : SizedBox.shrink();
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller?.removeJavaScriptHandler(handlerName: 'push');
    super.dispose();
  }
}
