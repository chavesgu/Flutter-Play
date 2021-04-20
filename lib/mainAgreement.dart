import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_play/main.dart';
import 'package:flutter_play/utils/utils.dart';
import 'package:flutter_play/variable.dart';
import 'package:get_storage/get_storage.dart';

class MainAgreement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (ctx, _) {
          uiInit(ctx);
          return Container(
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: SizedBox(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Text(
                              '隐私协议',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.black.withOpacity(0.9),
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            child: TextButton(
                              child: Text('同意'),
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(width(16)),
                                ),
                              ),
                              onPressed: () async {
                                GetStorage storage = GetStorage();
                                storage.write('agree', true);
                                // main
                                startApp();
                              },
                            ),
                          ),
                          TextButton(
                            child: Text('不同意'),
                            style: TextButton.styleFrom(
                              primary: Colors.grey,
                              backgroundColor: Colors.black12,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(width(16)),
                              ),
                            ),
                            onPressed: () {
                              MyDialog(
                                  content: '如果不同意隐私协议，FlutterPlay将无法为您提供服务',
                                  showCancel: true,
                                  cancelText: '退出应用',
                                  confirmText: '再看看',
                                  onCancel: () {
                                    Platform.isIOS
                                        ? exit(0)
                                        : SystemNavigator.pop();
                                  });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
