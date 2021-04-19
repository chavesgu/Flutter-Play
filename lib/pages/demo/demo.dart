import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_orientation/flutter_orientation.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_play/components/GlobalComponents.dart';
import 'package:flutter_play/store/model.dart';

import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as authError;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_amap/flutter_amap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:vibration/vibration.dart';
import 'package:push/push.dart';
import 'package:mob/mob.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart';

import 'package:flutter_play/utils/utils.dart';
import 'package:flutter_play/variable.dart';
import 'package:flutter_play/service/service.dart';
import 'package:flutter_play/router/path.dart';

class DemoPage extends StatefulWidget {
  static const String title = 'demo';
  static const Icon icon = Icon(Icons.build);

  DemoPage({
    this.drawerKey,
  });

  final GlobalKey<InnerDrawerState>? drawerKey;

  @override
  State<StatefulWidget> createState() {
    return DemoPageState();
  }
}

class DemoPageState extends State<DemoPage> with AutomaticKeepAliveClientMixin {
  IOWebSocketChannel? channel;
  String _data = '';

  dynamic _image;
  String? url;

  double progress = 0;

  String deviceToken = '';
  String message = '';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(IconFont.scan),
            onPressed: () {
              HapticFeedback.heavyImpact();
              goScan();
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Wrap(
            spacing: 20,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  widget.drawerKey?.currentState?.open();
                },
                child: Text('open drawer'),
              ),
              ElevatedButton(
                onPressed: () {
                  _getDeviceInfo();
                },
                child: Text('get device info'),
              ),
              ElevatedButton(
                onPressed: () {
                  openAppSettings();
                },
                child: Text('open app setting'),
              ),
              ElevatedButton(
                onPressed: _getPosition,
                child: Text('get position'),
              ),
              ElevatedButton(
                onPressed: _dialog,
                child: Text('dialog'),
              ),
              ElevatedButton(
                onPressed: _toast,
                child: Text('toast'),
              ),
              ElevatedButton(
                onPressed: _loading,
                child: Text('3s loading'),
              ),
              ElevatedButton(
                onPressed: _launchURL,
                child: Text('launch url'),
              ),
              ElevatedButton(
                onPressed: () {
                  chooseImageSource();
                },
                child: Text('take photo'),
              ),
              ElevatedButton(
                child: Text('init Push'),
                onPressed: () {
                  initPush();
                },
              ),
              ElevatedButton(
                child: Text('view pdf'),
                onPressed: () {
                  Get.toNamed(
                      '${PDFView.name}?url=${Uri.encodeComponent('https://cdn.chavesgu.com/profile.pdf')}');
                },
              ),
              ElevatedButton(
                child: Text('view webview'),
                onPressed: () {
                  Get.toNamed(
                      '${MyWebView.name}?url=${Uri.encodeQueryComponent('https://www.chavesgu.com/webview/')}');
                },
              ),
              ElevatedButton(
                child: Text('test fullscreen'),
                onPressed: () {
                  Orientation current = MediaQuery.of(context).orientation;
                  if (current == Orientation.portrait) {
                    FlutterOrientation.setOrientation(
                        DeviceOrientation.landscapeRight);
                  } else {
                    FlutterOrientation.setOrientation(
                        DeviceOrientation.portraitUp);
                  }
                },
              ),
              ElevatedButton(
                child: Text('random username'),
                onPressed: () {
                  UserModel userModel = Get.find<UserModel>();
                  userModel.title.value =
                      'chavesgu-${Random().nextInt(100).toString()}';
                },
              ),
              ElevatedButton(
                child: Text('phone login'),
                onPressed: () {
                  _mobLogin();
                },
              ),
              // ElevatedButton(
              //   child: Text('phone sms'),
              //   onPressed: () {
              //     Mob.sendSMS('17621106537');
              //   },
              // ),
              // ElevatedButton(
              //   child: Text('verify sms'),
              //   onPressed: () {
              //     Mob.verifySMS('17621106537', '998495').then((value) {
              //       print('verify success');
              //     }).catchError((e) {
              //       print('verify fail: ${e.message}');
              //     });
              //   },
              // ),
              ElevatedButton(
                child: Text('custom page'),
                onPressed: () {
                  navigator?.push(CustomRouteBuilder(
                    enterWidget: TestFixedPage(),
                  ));
                },
              ),
              ElevatedButton(
                child: Text('canvas1'),
                onPressed: () {
                  Get.toNamed(CanvasPage.name);
                },
              ),
              ElevatedButton(
                child: Text('close app'),
                onPressed: () {
                  Platform.isIOS ? exit(0) : SystemNavigator.pop();
                },
              ),
              ElevatedButton.icon(
                icon: Icon(IconFont.wechat),
                label: Text('wechat login'),
                onPressed: () {
                  _wxLogin();
                },
              ),
              ElevatedButton.icon(
                icon: Icon(IconFont.wechat),
                label: Text('wechat share'),
                onPressed: () {
                  _wxShare();
                },
              ),
              ElevatedButton(
                child: Text('set clipboard'),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: '测试 copy'));
                  Toast.show('copy success');
                },
              ),
              ElevatedButton(
                child: Text('get clipboard'),
                onPressed: () async {
                  ClipboardData? data =
                      await Clipboard.getData(Clipboard.kTextPlain);
                  Toast.show('剪贴板内容: ${data?.text}');
                },
              ),
              ElevatedButton(
                child: Text('faceid or fingerprint'),
                onPressed: () {
                  _localAuth();
                },
              ),
              ElevatedButton(
                child: Text('HapticFeedback'),
                onPressed: () async {
                  Vibration.vibrate(duration: 10);
                },
              ),
              ElevatedButton(
                child: Text('chart demo'),
                onPressed: () {
                  Get.toNamed(ChartDemo.name);
                },
              ),
            ],
          ),
          SelectableText(deviceToken),
          Text(message),
          if (_image != null)
            Row(
              children: [
                SizedBox(
                  width: width(500),
                  height: width(500),
                  child: MyImage(
                    _image,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    Amap.setKey(
      androidKey: '798d80979d68058e033d8d403145ba0d',
      iosKey: 'bfea8a8172612b2f2de52e256fcdbc66',
    );
    Amap.init(AMapLocationOption());
//    final token = generateToken(
//      'fe5756a59abc11e8a7830242ac640015',
//      '0oLcr8AsoQmq',
//      '00000005'
//    );
//    channel = IOWebSocketChannel.connect("ws://apiv0.fantaiai.com/ws?token=$token");
//    channel.stream.listen((data) {
//      setState(() {
//        _data = utf8.decode(data);
//      });
//    });
    super.initState();
  }

  @override
  void dispose() {
//    channel.sink.close();
    Amap.dispose();
    super.dispose();
  }

  _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      MyDialog(
        context: context,
        title: '提示',
        content: 'name: ${info.name},\n'
            'localizedModel: ${info.localizedModel},\n'
            'version: ${info.systemVersion},\n'
            'uuid: ${info.identifierForVendor}',
      );
    }
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      MyDialog(
        context: context,
        title: '提示',
        content: 'brand: ${info.brand},\n'
            'manufacturer: ${info.manufacturer},\n'
            'version: ${info.version.release},\n'
            'androidId: ${info.androidId}',
      );
    }
  }

  _getPosition() async {
    String res = '';
    bool hasPermission = await Permission.location.request().isGranted;
    if (hasPermission) {
      Loading.show(msg: '获取定位中');
      try {
        AMapLocation? position = await Amap.getLocation();
        // Map address = await Service.geoCoder(longitude: position.longitude, latitude: position.latitude!);
        if (position!.success) {
          res = position.formattedAddress ?? '';
        } else {
          res = '定位失败: ${position.code},${position.description}';
        }
      } catch (e) {
        res = '定位失败: $e';
      }
      await Loading.hide();
      MyDialog(
        context: context,
        title: '位置提示',
        content: res,
      );
    } else {
      MyDialog(
        context: context,
        title: '位置提示',
        content: '需要允许访问位置,"设置-隐私-位置"',
        confirmText: '前往设置',
        onConfirm: () {
          openAppSettings();
        },
      );
    }
  }

  _dialog() {
    MyDialog(
      context: context,
      content: TextSpan(children: [
        WidgetSpan(
          child: GestureDetector(
            onTap: () {
              MyDialog(context: context, content: 'twice dialog');
            },
            child: MyImage(
              'https://cdn.chavesgu.com/avatar.jpg',
              width: 50,
              height: 50,
            ),
          ),
        ),
        TextSpan(text: '      ← try click')
      ]),
    );
  }

  _toast() {
    Toast.show(
      "这是一个toast",
      // maxDuration: Duration(seconds: 20),
      // position: ToastPosition.top,
    );
  }

  _loading() {
    Loading.show(
      msg: "加载中",
      maxDuration: Duration(seconds: 3),
    );
  }

  _launchURL() async {
    String url =
        'https://help.wechat.com/app/${DateTime.now().millisecondsSinceEpoch}';
    launch(
      url,
      universalLinksOnly: true,
      forceSafariVC: false,
    );
  }

  _addWS() {
    channel?.sink.add('/cancel?qid=1');
    final code = Uri.encodeFull("X\$BTC");
    channel?.sink
        .add('/quote/stkdata?obj=$code&field=ZuiXinJia,ZhangFu&sub=1&qid=1');
  }

  chooseImageSource() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            height: 120 + bottomAreaHeight,
            padding: EdgeInsets.only(bottom: bottomAreaHeight),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SizedBox.expand(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context, SourceType.camera);
                      },
                      child: Text('拍照'),
                    ),
                  ),
                ),
                Divider(height: 1),
                Expanded(
                  child: SizedBox.expand(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context, SourceType.gallery);
                      },
                      child: Text('相册'),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).then((popValue) {
      if (popValue is SourceType) getImage(popValue);
    });
  }

  getImage(SourceType source) async {
    List<Media>? images = await Utils.imagePicker(
      source: source,
      count: 2,
      // pickType: PickType.all,
      // quality: .5,
      // maxSize: 600,
      cropOpt: CropOption(),
      language: Language.System,
    );
    if (images != null) {
      setState(() {
        _image = images.first.path;
      });
    }
  }

  initPush() async {
    bool isPush = await Permission.notification.status.isGranted;
    if (!isPush) {
      isPush = await Permission.notification.request().isGranted;
    }
    if (isPush || Platform.isAndroid) {
      String? type;
      AppConfig? app;
      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo info = await deviceInfo.androidInfo;
        type = info.manufacturer.toUpperCase();
      }
      if (type == "HUAWEI") {
        app = HUAWEI(appId: "101508155");
        // appKey = "03345fa08814e7d2d81329da87def92cd101da1b12558765b1aabfd216868956";
      } else if (type == "XIAOMI") {
        app = XIAOMI(appId: "2882303761518975690", appKey: "5401897576690");
      } else if (type == "OPPO" || type == "REALME" || type == "ONEPLUS") {
        app = OPPO(
            appKey: "1e72718f848f49b78a39ea1305c13e4c",
            appSecret: "18eb6e4b9e8243a1985832b92b63e5af");
      } else if (type == "MEIZU") {
        app =
            MEIZU(appId: "138382", appKey: "08eaa9c39ffe48b5b2f63e9d7cc6866c");
      }
      Push.init(
          app: app,
          type: type,
          getToken: (_token) {
            deviceToken = _token;
            setState(() {});
          },
          onLaunch: (Map<String, dynamic> _message) {
            message = 'onLaunch: ${_message.toString()}';
            setState(() {});
          },
          onMessage: (Map<String, dynamic> _message) {
            message = 'onMessage: ${_message.toString()}';
            setState(() {});
          },
          onResume: (Map<String, dynamic> _message) {
            message = 'onResume: ${_message.toString()}';
            setState(() {});
          },
          onError: (e) {
            MyDialog(
              content: e,
            );
          });
    }
  }

  void throttle() {
    Utils.throttle(() {
      DateTime now = DateTime.now();
      print('throttle:' + now.toString());
    }, Duration(seconds: 2));
  }

  void debounce() {
    Utils.debounce(() {
      DateTime now = DateTime.now();
      print('debounce:' + now.toString());
    }, Duration(seconds: 2));
  }

  void goScan() async {
    bool hasPermission = await Permission.camera.request().isGranted;
    if (hasPermission) {
      Get.toNamed(ScanPage.name);
    } else {
      MyDialog(
        context: context,
        title: '扫码提示',
        content: '扫码需要允许相机权限',
        confirmText: '前往设置',
        onConfirm: () {
          openAppSettings();
        },
      );
    }
  }

  void _mobLogin() async {
    if (await Mob.isSupportLogin) {
      Mob.login(success: (res) {
        Toast.show(res.token!);
      });
    } else {
      Toast.show('暂不支持一键登录');
    }
  }

  void _wxLogin() async {
    sendWeChatAuth(scope: "snsapi_userinfo", state: "login_test");
    StreamSubscription? subscription;
    subscription = weChatResponseEventHandler.listen((res) {
      if (res is WeChatAuthResponse) {
        subscription?.cancel();
        Toast.show('获取code: ${res.code}');
      }
    });
  }

  void _wxShare() async {
    shareToWeChat(WeChatShareMiniProgramModel(
      webPageUrl: 'https://www.chavesgu.com',
      userName: 'gh_0d6dcb6a7b49',
      path: 'pages/index/index',
      thumbnail: WeChatImage.network('https://cdn.chavesgu.com/logo.png'),
    ));
    StreamSubscription? subscription;
    subscription = weChatResponseEventHandler.listen((res) {
      if (res is WeChatShareResponse) {
        subscription?.cancel();
        Toast.show('分享完成');
      }
    });
  }

  void _localAuth() async {
    LocalAuthentication localAuth = LocalAuthentication();
    List<BiometricType> list = await localAuth.getAvailableBiometrics();
    print(list);
    String errorText = '';
    if (list.isEmpty) {
      errorText = '该设备不支持生物认证';
      MyDialog(
        content: errorText,
      );
      return;
    }
    String type = list.contains(BiometricType.fingerprint) ? '指纹' : '面容';
    try {
      bool allow = await localAuth.authenticate(
          biometricOnly: true,
          localizedReason: "身份认证",
          stickyAuth: true,
          useErrorDialogs: false,
          androidAuthStrings: AndroidAuthMessages(
              biometricHint: '$type认证', cancelButton: '取消'));
      errorText = allow ? '认证成功' : '认证失败';
    } on PlatformException catch (e) {
      print(e);
      switch (e.code) {
        case authError.passcodeNotSet:
        case authError.notEnrolled:
          errorText = '该设备未设置$type';
          break;
        case authError.notAvailable:
          errorText = '该设备不支持生物认证';
          break;
      }
    }
    MyDialog(
      content: errorText,
    );
  }
}
