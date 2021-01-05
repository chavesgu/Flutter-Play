import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_orientation/flutter_orientation.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_play/components/CustomAnimatePage.dart';
import 'package:flutter_play/components/GlobalComponents.dart';
import 'package:flutter_play/store/model.dart';

import 'package:images_picker/images_picker.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:amap_location/amap_location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
// import 'package:qiniu_manager/qiniu_manager.dart';
import 'package:push/push.dart';
import 'package:mob_login/mob_login.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart';

import 'package:flutter_play/utils/utils.dart';
import 'package:flutter_play/variable.dart';
import 'package:flutter_play/service.dart';
import 'package:flutter_play/routerPath.dart';

class DemoPage extends StatefulWidget {
  static const String title = 'demo';
  static const Icon icon = Icon(Icons.build);

  DemoPage({
    this.drawerKey,
  });

  final GlobalKey<InnerDrawerState> drawerKey;

  @override
  State<StatefulWidget> createState() {
    return DemoPageState();
  }
}

class DemoPageState extends State<DemoPage> with AutomaticKeepAliveClientMixin {
  IOWebSocketChannel channel;
  String _data = '';

  dynamic _image;
  String url;

  double progress = 0;

  String deviceToken = '';
  String message = '';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text('Demo'), toolbarHeight: 50, actions: [
        IconButton(
          icon: Icon(const IconData(0xe610, fontFamily: 'iconfont')),
          onPressed: () {
            HapticFeedback.heavyImpact();
            goScan();
          },
        )
      ]),
      body: ListView(
        children: <Widget>[
          Wrap(
            spacing: 20,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  widget.drawerKey?.currentState?.open();
                },
                child: Text('open drawer'),
              ),
              RaisedButton(
                onPressed: () {
                  _getDeviceInfo();
                },
                child: Text('get device info'),
              ),
              RaisedButton(
                onPressed: () {
                  openAppSettings();
                },
                child: Text('open app setting'),
              ),
              RaisedButton(
                onPressed: _getPosition,
                child: Text('get position'),
              ),
              RaisedButton(
                onPressed: _dialog,
                child: Text('dialog'),
              ),
              RaisedButton(
                onPressed: _toast,
                child: Text('toast'),
              ),
              RaisedButton(
                onPressed: _loading,
                child: Text('3s loading'),
              ),
              RaisedButton(
                onPressed: _launchURL,
                child: Text('launch url'),
              ),
              RaisedButton(
                onPressed: () {
                  chooseImageSource();
                },
                child: Text('take photo'),
              ),
              RaisedButton(
                child: Text('init Push'),
                onPressed: () {
                  initPush();
                },
              ),
              RaisedButton(
                child: Text('test fixed'),
                onPressed: () {
                  Navigator.of(context).pushNamed(TestFixedPage.name);
                },
              ),
              RaisedButton(
                child: Text('test ocr'),
                onPressed: () {
                  goOCR();
                },
              ),
              RaisedButton(
                child: Text('view pdf'),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      '${PDFView.name}?url=${Uri.encodeComponent('https://cdn.chavesgu.com/profile.pdf')}');
                },
              ),
              RaisedButton(
                  child: Text('view webview'),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        '${MyWebView.name}?url=${Uri.encodeQueryComponent('https://www.chavesgu.com/webview/')}');
                  }),
              RaisedButton(
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
              RaisedButton(
                child: Text('random username'),
                onPressed: () {
                  var setName = context.read<UserModel>().setUserName;
                  setName(Random().nextInt(100).toString());
                },
              ),
              RaisedButton(
                child: Text('phone login'),
                onPressed: () {
                  MobLogin.login();
                },
              ),
              RaisedButton(
                child: Text('custom page'),
                onPressed: () {
                  Navigator.of(context).push(CustomRouteBuilder(
                    enterWidget: TestFixedPage(),
                  ));
                },
              ),
              RaisedButton(
                child: Text('canvas1'),
                onPressed: () {
                  Navigator.of(context).pushNamed(CanvasPage.name);
                },
              ),
              RaisedButton(
                child: Text('canvas2'),
                onPressed: () {
                  Navigator.of(context).pushNamed(CanvasPage2.name);
                },
              ),
              RaisedButton(
                child: Text('close app'),
                onPressed: () {
                  Platform.isIOS ? exit(0) : SystemNavigator.pop();
                },
              ),
              RaisedButton(
                child: Text('wechat login'),
                onPressed: () {
                  _wxLogin();
                },
              ),
              RaisedButton(
                child: Text('wechat share'),
                onPressed: () {
                  _wxShare();
                },
              ),
              RaisedButton(
                child: Text('set clipboard'),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: '测试 copy'));
                  Toast.show(msg: 'copy success');
                },
              ),
              RaisedButton(
                child: Text('get clipboard'),
                onPressed: () async {
                  ClipboardData data =
                      await Clipboard.getData(Clipboard.kTextPlain);
                  Toast.show(msg: '剪贴板内容: ${data.text}');
                },
              ),
            ],
          ),
          SelectableText(deviceToken),
          Text(message),
          Row(
            children: <Widget>[
              _image != null
                  ? Container(
                      width: width(500),
                      height: width(500),
                      child: MyImage(
                        _image,
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    AMapLocationClient.startup(AMapLocationOption(
      desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters,
    ));
    // ios高德
    AMapLocationClient.setApiKey("bfea8a8172612b2f2de52e256fcdbc66");
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
    AMapLocationClient.shutdown();
//    channel.sink.close();
//    audioPlayer.dispose();
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
            'uuid: ${info.identifierForVendor},\n'
            'localizedModel: ${info.localizedModel},\n'
            'model: ${info.model}',
        confirmText: '确认',
      );
    }
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      MyDialog(
        context: context,
        title: '提示',
        content: 'brand: ${info.brand},\n'
            'hardware: ${info.hardware},\n'
            'product: ${info.product},\n'
            'manufacturer: ${info.manufacturer},\n'
            'model: ${info.model},\n'
            'androidId: ${info.androidId}',
        confirmText: '确认',
      );
    }
  }

  _getPosition() async {
    String res = '';
    PermissionStatus permissionStatus = await Permission.location.status;
    bool hasPermission = permissionStatus.isGranted;
    bool unknown =
        (permissionStatus.isUndetermined) || (permissionStatus.isDenied);
    if (unknown) {
      hasPermission = await Permission.location.request().isGranted;
    }
    if (hasPermission) {
      AMapLocation location = await AMapLocationClient.getLocation(true);
      if (location.success) {
        res = '纬度:${location.latitude},\n'
            '经度: ${location.longitude}\n'
            'city: ${location.city}\n'
            'country: ${location.country}\n'
            'street: ${location.street}\n'
            'formattedAddress: ${location.formattedAddress}';
      } else {
        res = '定位失败-${location.code}，原因: ${location.description}';
      }
      MyDialog(
        context: context,
        title: '位置提示',
        content: res,
        confirmText: '确认',
      );
    } else {
      MyDialog(
          context: context,
          title: '位置提示',
          content: '需要允许访问位置,"设置-隐私-位置"',
          confirmText: '前往设置',
          onConfirm: () {
            openAppSettings();
          });
    }
  }

  _dialog() {
    MyDialog(
      context: context,
      content: TextSpan(children: [
        WidgetSpan(
          child: GestureDetector(
            onTap: () {
              MyDialog(
                context: context,
                content: 'twice dialog'
              );
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
      msg: "这是一个toast",
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
    channel.sink.add('/cancel?qid=1');
    final code = Uri.encodeFull("X\$BTC");
    channel.sink
        .add('/quote/stkdata?obj=$code&field=ZuiXinJia,ZhangFu&sub=1&qid=1');
  }

  chooseImageSource() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            height: 100 + bottomAreaHeight,
            padding: EdgeInsets.only(bottom: bottomAreaHeight),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                ButtonTheme(
                  minWidth: double.infinity,
                  height: 50,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context, SourceType.camera);
                    },
                    child: Text('拍照'),
                  ),
                ),
                ButtonTheme(
                  minWidth: double.infinity,
                  height: 50,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context, SourceType.gallery);
                    },
                    child: Text('相册'),
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
    List<Media> images = await Utils.imagePicker(
      source: source,
      count: 2,
      // pickType: PickType.all,
      // quality: .5,
      // maxSize: 600,
      cropOpt: CropOption(),
    );
    if (images != null) {
      setState(() {
        print(images.first.size);
        _image = images.first.path;
      });
    }
  }

  initPush() async {
    bool isPush = await Permission.notification.status.isGranted;
    if (!isPush) {
      isPush = await Permission.notification.request().isGranted;
    }
    if (isPush) {
      String type;
      String appId = "101508155";
      String appKey =
          "03345fa08814e7d2d81329da87def92cd101da1b12558765b1aabfd216868956";
      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo info = await deviceInfo.androidInfo;
        type = info.manufacturer.toUpperCase();
      }
      if (type == "HUAWEI") {
        appId = "101508155";
        appKey =
            "03345fa08814e7d2d81329da87def92cd101da1b12558765b1aabfd216868956";
      } else if (type == "XIAOMI") {
        appId = "2882303761518291647";
        appKey = "5201829199647";
      }
      Push.init(
        appId: appId,
        appKey: appKey,
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
      );
    }
  }

  void goOCR() async {
    Navigator.of(context).pushNamed(TestOCR.name);
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
    PermissionStatus permissionStatus = (await Permission.camera.status);
    bool hasPermission = permissionStatus == PermissionStatus.granted;
    bool unknown =
        (permissionStatus.isUndetermined) || (permissionStatus.isDenied);
    if (unknown) {
      hasPermission = await Permission.camera.request().isGranted;
    }
    if (hasPermission) {
      Navigator.of(context).pushNamed(ScanPage.name);
    } else {
      MyDialog(
          context: context,
          title: '扫码提示',
          content: '扫码需要允许相机权限',
          confirmText: '前往设置',
          onConfirm: () {
            openAppSettings();
          });
    }
  }

  void _wxLogin() async {
    sendWeChatAuth(scope: "snsapi_userinfo", state: "login_test");
    StreamSubscription subscription;
    subscription = weChatResponseEventHandler.listen((res) {
      if (res is WeChatAuthResponse) {
        subscription?.cancel();
        Toast.show(msg: '获取code: ${res.code}');
      }
    });
  }

  void _wxShare() async {
    shareToWeChat(WeChatShareWebPageModel('https://www.chavesgu.com',
        scene: WeChatScene.SESSION));
    StreamSubscription subscription;
    subscription = weChatResponseEventHandler.listen((res) {
      if (res is WeChatShareResponse) {
        subscription?.cancel();
        Toast.show(msg: '分享完成');
      }
    });
  }
}
