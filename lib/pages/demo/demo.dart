import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_play/components/GlobalComponents.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:amap_location/amap_location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter_alert/flutter_alert.dart';
import 'package:extended_image/extended_image.dart';
import 'package:image_cropper/image_cropper.dart';
// import 'package:qiniu_manager/qiniu_manager.dart';
import 'package:push/push.dart';

import 'package:flutter_play/utils/utils.dart';
import 'package:flutter_play/variable.dart';
import 'package:flutter_play/service.dart';
import 'package:flutter_play/pages/demo/testFixed.dart';

class DemoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DemoPageState();
  }
}

class DemoPageState extends State<DemoPage> with AutomaticKeepAliveClientMixin {

  IOWebSocketChannel channel;
  String _data = '';

  File _image;
  String url;

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
      ),
      body: ListView(
        children: <Widget>[
          Wrap(
            spacing: 20,
            children: <Widget>[
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
                onPressed: _toast,
                child: Text('toast'),
              ),
              RaisedButton(
                onPressed: _launchURL,
                child: Text('launch url'),
              ),
              RaisedButton(
                onPressed: ()async {
                  chooseImageSourse();
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
            ],
          ),
          SelectableText(deviceToken),
          Text(message),
          Row(
            children: <Widget>[
              _image!=null?
              Container(
                width: width(500),
                height: width(500),
                child: MyImage(
                  _image,
                ),
              ):
              Container(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    AMapLocationClient.startup(AMapLocationOption(
      desiredAccuracy:CLLocationAccuracy.kCLLocationAccuracyHundredMeters,
    ));
    final token = generateToken(
      'fe5756a59abc11e8a7830242ac640015',
      '0oLcr8AsoQmq',
      '00000005'
    );
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

  _getPosition() async {
    String res = '';
    PermissionStatus permissionStatus = await Permission.location.status;
    bool hasPermission = permissionStatus.isGranted;
    bool unknown = (permissionStatus.isUndetermined) || (permissionStatus.isDenied);
    if (unknown) {
      hasPermission = await Permission.location.request().isGranted;
    }
    if (hasPermission) {
      AMapLocation location  = await AMapLocationClient.getLocation(true);
      if (location.success) {
        res = '纬度:${location.latitude},\n'
          '经度: ${location.longitude}\n'
          'city: ${location.city}\n'
          'country: ${location.country}\n'
          'street: ${location.street}\n'
          'formattedAddress: ${location.formattedAddress}';
      } else {
        res = '定位失败-${location.code}，原因: ${location.description}';
        print(res);
      }
      showAlert(
        context: context,
        barrierDismissible: false,
        title: '位置提示',
        body: res,
        actions: [
          AlertAction(
            text: '确认',
            onPressed: () {
            },
          ),
        ],
      );
    } else {
      showAlert(
        context: context,
        barrierDismissible: false,
        title: '位置提示',
        body: '需要允许访问位置"设置-隐私-位置"',
        actions: [
          AlertAction(
            text: '取消',
            onPressed: () {
            },
          ),
          AlertAction(
            text: '设置',
            onPressed: () {
              openAppSettings();
            },
          )
        ],
      );
    }
  }

  _toast() {
    Toast.show(
      context,
      msg: "这是一个toast",
    );
  }

  _launchURL() async {
    const url = 'https://www.chavesgu.com';
//    const url = 'mqq://';
    launch(
      url,
      forceSafariVC: false,
    );
  }

  _addWS() {
    channel.sink.add('/cancel?qid=1');
    final code = Uri.encodeFull("X\$BTC");
    channel.sink.add('/quote/stkdata?obj=$code&field=ZuiXinJia,ZhangFu&sub=1&qid=1');
  }

  chooseImageSourse() {
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
                    Navigator.pop(context);
                    getImage(SourceType.camera);
                  },
                  child: Text('拍照'),
                ),
              ),
              ButtonTheme(
                minWidth: double.infinity,
                height: 50,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(SourceType.gallery);
                  },
                  child: Text('相册'),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  getImage(SourceType source) async {
    String imagePath;
    List<File> images = await Utils.imagePicker(
      context: context,
      source: source,
      maxImages: 2
    );
    imagePath = images.first.path;
    if (imagePath!=null) {
      File cropImage = await ImageCropper.cropImage(
        sourcePath: imagePath,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
//        cropStyle: CropStyle.circle,
      );
      setState(() {
        print('压缩后:'+cropImage.path);
        _image = cropImage;
      });
    }
  }

  initPush()async {
    bool isPush = await Permission.notification.status.isGranted;
    if (!isPush) {
      isPush = await Permission.notification.request().isGranted;
    }
    if (isPush) {
      String type;
      String appId = "101508155";
      String appKey = "03345fa08814e7d2d81329da87def92cd101da1b12558765b1aabfd216868956";
      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo info = await deviceInfo.androidInfo;
        type = info.manufacturer.toUpperCase();
      }
      if (type=="HUAWEI") {
        appId = "101508155";
        appKey = "03345fa08814e7d2d81329da87def92cd101da1b12558765b1aabfd216868956";
      } else if (type=="XIAOMI") {
        appId = "2882303761518291647";
        appKey = "5201829199647";
      }
      Push.init(
        appId: appId,
        appKey: appKey,
        type: type,
        getToken: (_token) {
          print(111);
          deviceToken = _token;
          setState(() {

          });
        },
        onLaunch: (Map<String, dynamic> _message) {
          message = 'onLaunch: ${_message.toString()}';
          setState(() {

          });
        },
        onMessage: (Map<String, dynamic> _message) {
          message = 'onMessage: ${_message.toString()}';
          setState(() {

          });
        },
        onResume: (Map<String, dynamic> _message) {
          message = 'onResume: ${_message.toString()}';
          setState(() {

          });
        },
      );
    }
  }
}
