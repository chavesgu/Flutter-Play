import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:flutter_play/components/MyCircularProgressIndicator.dart';
import 'package:flutter_play/components/MyLoading.dart';
import 'package:flutter_play/components/MyToast.dart';
import 'package:flutter_play/variable.dart';
import 'package:images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

// 工具类
class Utils {

  // 选取照片
  static Future<List<Media>> imagePicker({
    BuildContext context,
    PickType pickType = PickType.image,
    bool gif = true,
    SourceType source = SourceType.gallery,
    int count = 1,
    CropOption cropOpt,
    double quality,
    int maxSize,
  }) async {
    String permissionReason = '';
    bool hasPermission = false;
    List<Media> output;
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
      try {
        if (source==SourceType.gallery) {
          output = await ImagesPicker.pick(
            count: count,
            pickType: pickType,
            gif: gif,
            cropOpt: cropOpt,
            maxSize: maxSize,
            quality: quality,
          );
        }
        if (source==SourceType.camera) {
          output = await ImagesPicker.openCamera(
            pickType: pickType,
            cropOpt: cropOpt,
            maxSize: maxSize,
            quality: quality,
          );
        }
      } catch(e) {
        print(e);
        output = null;
      }
      return output;
    } else {
      showAlert(
        context: context ?? globalContext,
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

  // 节流
  static final Map<int, Throttling> _throttleMap = Map();
  static throttle(Function fn, Duration duration) {
    Throttling thr;
    int ms = duration.inMilliseconds;
    if (_throttleMap.containsKey(ms)) {
      thr = _throttleMap[ms];
    } else {
      thr = Throttling(duration: duration);
      _throttleMap[ms] = thr;
    }
    thr.throttle(() {
      fn();
    });
  }
  // 防抖
  static final Map<int, Debouncing> _debounceMap = Map();
  static debounce(Function fn, Duration duration) {
    Debouncing deb;
    int ms = duration.inMilliseconds;
    if (_debounceMap.containsKey(ms)) {
      deb = _debounceMap[ms];
    } else {
      deb = Debouncing(duration: duration);
      _debounceMap[ms] = deb;
    }
    deb.debounce(() {
      fn();
    });
  }
}

class Loading {
  static OverlayEntry _currentEntry;
  static Timer _timer;

  static void show({
    BuildContext context,
    String msg,
    bool mask = true,
    Duration duration = const Duration(seconds: 60),
  }) async {
    if (_currentEntry!=null) return;

    OverlayState overlayState = context!=null ? Overlay.of(context) : globalOverlayState;
    _currentEntry = OverlayEntry(
      opaque: false,
      builder: (_) {
        Widget wrap;
        Widget content = MyLoading(
          msg: msg,
          duration: duration,
          onComplete: () {
            hide();
          },
        );
        wrap = Center(
          child: content,
        );
        if (mask) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
//            color: Colors.red,
              child: wrap,
            ),
          );
        }
        return wrap;
      },
    );
    overlayState.insert(_currentEntry);
  }

  static void hide() {
    _currentEntry?.remove();
    _currentEntry = null;
    _timer?.cancel();
  }
}

class Toast {
  static Function _complete;
  static OverlayEntry _currentEntry;

  static void show({
    BuildContext context,
    @required String msg,
    bool mask = true,
    Duration duration = const Duration(milliseconds: 1200),
    ToastPosition position = ToastPosition.middle,
    Function complete,
  }) async {
    if (_currentEntry!=null) return;

    OverlayState overlayState = context!=null ? Overlay.of(context) : globalOverlayState;
    _complete = complete;
    _currentEntry = OverlayEntry(
      opaque: false,
      builder: (_) {
        Widget wrap;
        Widget content = MyToast(
          msg: msg,
          duration: duration,
          onComplete: () {
            hide();
          },
        );
        if (position!=ToastPosition.middle) {
          wrap = Column(
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
        wrap = Center(
          child: content,
        );
        if (mask) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
//            color: Colors.red,
              child: wrap,
            ),
          );
        }
        return wrap;
      },
    );
    overlayState.insert(_currentEntry);
    
//    await Future.delayed(duration);

//    hide();
  }

  static void hide() {
    _currentEntry?.remove();
    _currentEntry = null;
    if (_complete!=null) _complete();
    _complete = null;
  }
}

class Throttling {
  Duration _duration;
  Duration get duration => this._duration;
  set duration(Duration value) {
    assert(duration is Duration && !duration.isNegative);
    this._duration = value;
  }

  bool _isReady = true;
  bool get isReady => isReady;
  Future<void> get _waiter => Future.delayed(this._duration);
  // ignore: close_sinks
  final StreamController<bool> _stateSC =
  new StreamController<bool>.broadcast();

  Throttling({Duration duration = const Duration(seconds: 1)})
    : assert(duration is Duration && !duration.isNegative),
      this._duration = duration ?? Duration(seconds: 1) {
    this._stateSC.sink.add(true);
  }

  dynamic throttle(Function func) {
    if (!this._isReady) return null;
    this._stateSC.sink.add(false);
    this._isReady = false;
    _waiter
      ..then((_) {
        this._isReady = true;
        this._stateSC.sink.add(true);
      });
    return Function.apply(func, []);
  }

  StreamSubscription<bool> listen(Function(bool) onData) =>
    this._stateSC.stream.listen(onData);

  dispose() {
    this._stateSC.close();
  }
}

class Debouncing {
  Duration _duration;
  Duration get duration => this._duration;
  set duration(Duration value) {
    assert(duration is Duration && !duration.isNegative);
    this._duration = value;
  }

  Timer _waiter;
  bool _isReady = true;
  bool get isReady => isReady;
  // ignore: close_sinks
  StreamController<dynamic> _resultSC =
  new StreamController<dynamic>.broadcast();
  // ignore: close_sinks
  final StreamController<bool> _stateSC =
  new StreamController<bool>.broadcast();

  Debouncing({Duration duration = const Duration(seconds: 1)})
    : assert(duration is Duration && !duration.isNegative),
      this._duration = duration ?? Duration(seconds: 1) {
    this._stateSC.sink.add(true);
  }

  Future<dynamic> debounce(Function func) async {
    if (this._waiter?.isActive ?? false) {
      this._waiter?.cancel();
      this._resultSC.sink.add(null);
    }
    this._isReady = false;
    this._stateSC.sink.add(false);
    this._waiter = Timer(this._duration, () {
      this._isReady = true;
      this._stateSC.sink.add(true);
      this._resultSC.sink.add(Function.apply(func, []));
    });
    return this._resultSC.stream.first;
  }

  StreamSubscription<bool> listen(Function(bool) onData) =>
    this._stateSC.stream.listen(onData);

  dispose() {
    this._resultSC.close();
    this._stateSC.close();
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