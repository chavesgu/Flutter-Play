import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../variable.dart';

class AboutPage extends StatefulWidget {
  static const name = '/about';

  AboutPage(this.url);

  final String url;

  @override
  createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  InAppWebViewController webView;
  int _progress = 0;

  get url => widget.url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          title: Text('关于我们'),
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            top: false,
            child: Stack(
              children: <Widget>[
                InAppWebView(
                  initialUrl: url,
                  initialOptions: InAppWebViewGroupOptions(),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                    // flutter和webview通信
                    webView.addJavaScriptHandler(handlerName: 'handlerFooWithArgs', callback: (arguments) {
//                  print(arguments);
//                  Scaffold.of(context).showSnackBar(SnackBar(
//                    content: Text(arguments.toString())
//                  ));
                    });
                  },
                  onProgressChanged: (InAppWebViewController controller, int progress) {
                    setState(() {
                      _progress = progress;
                    });
                  },
                ),
                _progress!=100?Positioned(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Container(
                        width: width(100),
                        height: width(100),
                        child: CircularProgressIndicator(),
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
    webView?.removeJavaScriptHandler(handlerName: 'handlerFooWithArgs');
    super.dispose();
  }
}