import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_play/components/MyCircularProgressIndicator.dart';
import 'package:flutter_play/components/MyLoading.dart';
import 'package:flutter_play/components/MyToast.dart';
import 'package:flutter_play/components/Popup.dart';
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
    if (source == SourceType.gallery) {
      Permission _permission =
          Platform.isIOS ? Permission.photos : Permission.storage;
      PermissionStatus permissionStatus = await _permission.status;
      hasPermission = permissionStatus.isGranted;
      bool unknown =
          (permissionStatus.isUndetermined) || (permissionStatus.isDenied);
      if (unknown) {
        hasPermission = await _permission.request().isGranted;
      }
      if (!hasPermission) {
        permissionReason = '需要打开${Platform.isIOS ? '相册读写' : '文件读写'}权限，前往"设置"';
      }
    }
    if (source == SourceType.camera) {
      PermissionStatus permissionStatus = await Permission.camera.status;
      hasPermission = permissionStatus.isGranted;
      bool unknown =
          (permissionStatus.isUndetermined) || (permissionStatus.isDenied);
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
        if (source == SourceType.gallery) {
          output = await ImagesPicker.pick(
            count: count,
            pickType: pickType,
            gif: gif,
            cropOpt: cropOpt,
            maxSize: maxSize,
            quality: quality,
          );
        }
        if (source == SourceType.camera) {
          output = await ImagesPicker.openCamera(
            pickType: pickType,
            cropOpt: cropOpt,
            maxSize: maxSize,
            quality: quality,
          );
        }
      } catch (e) {
        print(e);
        output = null;
      }
      return output;
    } else {
      MyDialog(
          context: context,
          title: '提示',
          content: permissionReason,
          confirmText: '前往设置',
          onConfirm: () {
            openAppSettings();
          }
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
    return new File(tempPath + '/' + Uuid().v4()).writeAsBytes(
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

// Custom Dialog
// there is no show method,because allow multiple dialogs
class MyDialog {
  MyDialog({
    BuildContext context,
    this.title = '提示',
    this.content = '弹窗内容',
    this.confirmText = '确认',
    this.cancelText = '取消',
    this.confirmColor = const Color(0xff576b95),
    this.cancelColor = const Color.fromRGBO(0, 0, 0, 0.9),
    this.showCancel = false,
    this.onConfirm,
    this.onCancel,
  }) {
    assert(content is String || content is InlineSpan, 'content must be string or InlineSpan');
    _context = context;
    _show();
  }

  static int _length = 0;

  final String title;
  final dynamic content;
  final String confirmText;
  final String cancelText;
  final Color confirmColor;
  final Color cancelColor;
  final bool showCancel;
  final Function onConfirm;
  final Function onCancel;
  BuildContext _context;
  OverlayEntry _currentEntry;
  Popup _popup;

  void _show() {
    OverlayState overlayState =
        _context != null ? Overlay.of(_context) : globalOverlayState;
    Widget titleWidget = FractionallySizedBox(
      widthFactor: 1,
      child: Padding(
        padding: EdgeInsets.only(
          top: 32,
          bottom: 16,
          left: 24,
          right: 24,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black.withOpacity(0.9),
            fontSize: width(34),
            fontWeight: FontWeight.w700,
            height: 1.7,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
    Widget contentWidget = FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: EdgeInsets.only(
          left: width(48),
          right: width(48),
        ),
        margin: EdgeInsets.only(
          bottom: 32,
        ),
        child: Text.rich(
          (content is String)?TextSpan(text: content):content,
          // textAlign: TextAlign.justify,
          softWrap: true,
          overflow: TextOverflow.fade,
          style: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: width(34),
            fontWeight: FontWeight.normal,
            height: 1.4,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
    Widget controlWidget = FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
          width: width(1),
          color: Colors.black.withOpacity(0.1),
        ))),
        child: Row(
          children: [
            if (showCancel)
              Expanded(
                child: _TapEffect(
                  onTap: () async {
                    await hide();
                    if (onCancel != null) onCancel();
                  },
                  child: Center(
                    child: Text(
                      cancelText,
                      style: TextStyle(
                        fontSize: width(34),
                        fontWeight: FontWeight.w700,
                        color: cancelColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            if (showCancel)
              Container(
                width: width(1),
                color: Colors.black.withOpacity(0.1),
              ),
            Expanded(
              child: _TapEffect(
                onTap: () async {
                  await hide();
                  if (onConfirm != null) onConfirm();
                },
                child: Center(
                  child: Text(
                    confirmText,
                    style: TextStyle(
                      fontSize: width(34),
                      fontWeight: FontWeight.w700,
                      color: confirmColor,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    _popup = Popup(
      // mask: _length == 0,
      child: Container(
        width: vw - width(100),
        margin: EdgeInsets.only(
          left: width(50),
          right: width(50),
        ),
        constraints: BoxConstraints(
          maxHeight: vh * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(width(24)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            titleWidget,
            contentWidget,
            controlWidget,
          ],
        ),
      ),
      handleHide: () {
        hide(quick: true);
      },
    );
    _currentEntry = OverlayEntry(
      opaque: false,
      builder: (_) {
        return _popup;
      },
    );
    overlayState.insert(_currentEntry);
    _length++;
  }

  Future<void> hide({ bool quick = false }) async {
    if (_popup!=null && !quick) {
      await _popup.hide();
      _popup = null;
    }
    _currentEntry?.remove();
    _currentEntry = null;
    _length--;
  }
}

class Loading {
  static OverlayEntry _currentEntry;
  static Popup _popup;
  static Timer _timer;

  static void show({
    BuildContext context,
    String msg,
    bool mask = true,
    Duration maxDuration = const Duration(seconds: 60),
  }) async {
    if (_currentEntry != null) return;

    OverlayState overlayState =
        context != null ? Overlay.of(context) : globalOverlayState;
    _popup = Popup(
      mask: false,
      child: MyLoading(
        msg: msg,
      ),
    );
    _currentEntry = OverlayEntry(
      opaque: false,
      builder: (_) {
        return _popup;
      },
    );
    overlayState.insert(_currentEntry);
    _timer?.cancel();
    _timer = Timer(maxDuration, () {
      hide();
    });
  }

  static Future<void> hide({ bool quick = false }) async {
    if (_popup!=null && !quick) {
      await _popup.hide();
      _popup = null;
    }
    _timer?.cancel();
    _timer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class Toast {
  static OverlayEntry _currentEntry;
  static Popup _popup;
  static Timer _timer;

  static void show({
    BuildContext context,
    @required String msg,
    Duration maxDuration = const Duration(milliseconds: 1200),
    ToastPosition position = ToastPosition.middle,
  }) async {
    if (_currentEntry != null) return;

    OverlayState overlayState =
        context != null ? Overlay.of(context) : globalOverlayState;
    EdgeInsetsGeometry padding;
    MainAxisAlignment mainAxisAlignment;
    switch (position) {
      case ToastPosition.top:
        padding = EdgeInsets.only(top: vh / 5);
        mainAxisAlignment = MainAxisAlignment.start;
        break;
      case ToastPosition.bottom:
        padding = EdgeInsets.only(top: vh * 4 / 5);
        mainAxisAlignment = MainAxisAlignment.start;
        break;
      default:
        padding = EdgeInsets.zero;
        mainAxisAlignment = MainAxisAlignment.center;
    }
    _popup = Popup(
      mask: false,
      child: SizedBox(
        height: vh,
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Padding(
              padding: padding,
              child: MyToast(
                msg: msg,
              ),
            )
          ],
        ),
      ),
    );
    _currentEntry = OverlayEntry(
      opaque: false,
      builder: (_) {
        return _popup;
      },
    );
    overlayState.insert(_currentEntry);
    _timer?.cancel();
    _timer = Timer(maxDuration, () {
      hide();
    });
  }

  static Future<void> hide() async {
    if (_popup!=null) {
      await _popup.hide();
      _popup = null;
    }
    _timer?.cancel();
    _timer = null;
    _currentEntry?.remove();
    _currentEntry = null;
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

// fz
class _TapEffect extends StatefulWidget {
  _TapEffect({
    this.child,
    this.onTap,
  });

  final Widget child;
  final GestureTapCallback onTap;

  @override
  State<StatefulWidget> createState() => _TapEffectState();
}

class _TapEffectState extends State<_TapEffect> {
  bool isTap = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() {
          isTap = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isTap = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isTap = false;
        });
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          color: isTap ? Color.fromRGBO(236, 236, 236, 1) : Colors.white,
          child: widget.child,
        ),
      ),
    );
  }
}

enum SourceType {
  camera,
  gallery,
}

enum ToastPosition { top, middle, bottom }
