import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AboutPage extends StatefulWidget {
  static const name = '/about';

  AboutPage(this.url);

  final String url;

  @override
  createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  InAppWebViewController webView;
  double progress = 0;

  get url => widget.url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('关于我们'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            top: false,
            child: InAppWebView(
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
                  this.progress = progress / 100;
                });
              },
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