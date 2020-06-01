import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:flutter_play/variable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

// 工具类
class Utils {

  // 选取照片
  static Future<List<File>> imagePicker({ @required BuildContext context, SourceType source = SourceType.gallery, int maxImages = 1, int quality = 100 })async {
    String permissionReason = '';
    bool hasPermission = false;
    List<File> output = [];
    if (source==SourceType.gallery) {
      Permission _permission = Platform.isIOS?Permission.photos:Permission.storage;
      PermissionStatus permissionStatus = await _permission.status;
      hasPermission = permissionStatus.isGranted;
      bool unknown = (permissionStatus.isUndetermined) || (permissionStatus.isDenied);
      if (unknown) {
        hasPermission = await _permission.request().isGranted;
      }
      if (!hasPermission) {
        permissionReason = '需要打开${Platform.isIOS?'相册读写':'文件读写'}权限，前往"设置"';
      }
    }
    if (source==SourceType.camera) {
      PermissionStatus permissionStatus = await Permission.camera.status;
      hasPermission = permissionStatus.isGranted;
      bool unknown = (permissionStatus.isUndetermined) || (permissionStatus.isDenied);
      if (unknown) {
        // microphone
        hasPermission = await Permission.camera.request().isGranted;
      }
      if (!hasPermission) {
        permissionReason = '需要打开相机权限，前往"设置"';
      }
    }
    if (hasPermission) {
      if (source==SourceType.gallery) {
        if (maxImages > 1) {
          List<Asset> images = await MultiImagePicker.pickImages(
            maxImages: maxImages
          );
          Iterable<Future<ByteData>> futureByteDataList = images.map((Asset image) {
            return image.getByteData(quality: quality);
          });
          List<ByteData> byteDataList = await Future.wait(futureByteDataList);
          Iterable<Future<File>> futureFileList = byteDataList.map((ByteData byteData) {
            return bytesToFile(byteData);
          });
          output = await Future.wait(futureFileList);
        } else {
          File image = await ImagePicker.pickImage(
            source: ImageSource.gallery,
            imageQuality: quality,
          );
          output = [image];
        }
      }
      if (source==SourceType.camera) {
        File image = await ImagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: quality,
        );
        output = [image];
      }
      return output;
    } else {
      showAlert(
        context: context,
        barrierDismissible: false,
        title: '提示',
        body: permissionReason,
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
      return null;
    }
  }

// 二进制转file
  static Future<File> bytesToFile(ByteData byteData) async {
    Directory tempDir = Directory.systemTemp ?? await getTemporaryDirectory();
    String tempPath = tempDir.path; // /tmp ?? /Library/Caches

//      Directory appDocDir = await getApplicationDocumentsDirectory();
//      String appDocPath = appDocDir.path;

    ByteBuffer buffer = byteData.buffer;
    return new File(tempPath+'/'+Uuid().v4()).writeAsBytes(
      buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
}

class Toast {
  static OverlayEntry _currentEntry;
  static Function _complete;

  static void show(BuildContext context, {
    String msg,
    bool mask = false,
    Duration duration = const Duration(milliseconds: 1200),
    ToastPosition position = ToastPosition.middle,
    Function complete,
  }) {
    if (_currentEntry!=null) return;

    _complete = complete;
    _currentEntry = OverlayEntry(
      opaque: mask,
      builder: (_) {
        Widget content = ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(width(8))),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: width(500)
            ),
            color: Color.fromRGBO(0, 0, 0, .7),
            padding: EdgeInsets.only(
              left: width(30),
              right: width(30),
              top: width(20),
              bottom: width(20)
            ),
            child: Text(
              msg,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                height: 1.2,
                fontSize: width(30),
                color: Colors.white,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        );
        if (position!=ToastPosition.middle) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: position==ToastPosition.top?vh/5:vh*4/5
                ),
                child: content,
              )
            ],
          );
        }
        return Center(
          child: content,
        );
      },
    );
    Overlay.of(context).insert(_currentEntry);

    Timer(duration, () {
      hide();
    });
  }

  static void hide() {
    _currentEntry?.remove();
    _currentEntry = null;
    if (_complete!=null) _complete();
    _complete = null;
  }
}

enum SourceType {
  camera,
  gallery,
}

enum ToastPosition {
  top,
  middle,
  bottom
}