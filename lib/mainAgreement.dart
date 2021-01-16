import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_play/main.dart';
import 'package:flutter_play/utils/utils.dart';
import 'package:flutter_play/variable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainAgreement extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LayoutBuilder(
        builder: (ctx, _) {
          uiInit(ctx, _);
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
                            child: FlatButton(
                              child: Text('同意'),
                              color: Colors.blue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(width(16))
                              ),
                              onPressed: () async {
                                SharedPreferences sp = await SharedPreferences.getInstance();
                                sp.setBool('agree', true);
                                // main
                                startApp();
                              },
                            ),
                          ),
                          FlatButton(
                            child: Text('不同意'),
                            color: Colors.black12,
                            textColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(width(16))
                            ),
                            onPressed: () {
                              MyDialog(
                                content: '如果不同意隐私协议，FlutterPlay将无法为您提供服务',
                                showCancel: true,
                                cancelText: '退出应用',
                                confirmText: '再看看',
                                onCancel: () {
                                  Platform.isIOS ? exit(0) : SystemNavigator.pop();
                                }
                              );
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