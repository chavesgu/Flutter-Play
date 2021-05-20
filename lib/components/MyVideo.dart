import 'dart:io';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_orientation/flutter_orientation.dart';
import 'package:flutter_play/variable.dart';

class MyVideo extends StatefulWidget {
  MyVideo(
    this.url, {
    required this.width,
    required this.height,
    this.controls = true,
    this.autoplay = false,
    this.loop = false,
    this.title = '',
    this.background = Colors.black,
    this.screenChange,
  });

  // 视频地址
  final String url;
  // 视频尺寸比例
  final double width;
  final double height;
  // 是否需要控制栏
  final bool controls;
  // 是否自动播放
  final bool autoplay;
  // 是否循环播放
  final bool loop;
  // 视频标题
  final String title;
  // 视频背景
  final Color background;
  // 切换横竖屏回调
  final Function? screenChange;

  @override
  State<MyVideo> createState() {
    return _MyVideoState();
  }
}

class _MyVideoState extends State<MyVideo> {
  // 指示video资源是否加载完成
  bool _videoInit = false;
  // video控件管理器
  VideoPlayerController? _controller;
  // 记录video播放进度
  Duration _position = Duration(seconds: 0);
  // 记录播放控件ui是否显示(进度条，播放按钮，全屏按钮等等)
  Timer? _timer;
  // bool _hidePlayControl = true;
  double _playControlOpacity = 0;
  // 记录是否全屏
  bool get _isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  @override
  Widget build(BuildContext context) {
    // 全屏时显示当前时间
    DateTime now = DateTime.now();
    String hh = now.hour < 10 ? '0${now.hour}' : '${now.hour}';
    String mm = now.minute < 10 ? '0${now.minute}' : '${now.minute}';
    // 底部播放器控制栏
    Widget _bottomControl = Positioned(
      left: 0,
      bottom: 0,
      child: Container(
        width: widget.width,
        height: _isFullScreen ? 40 + MediaQuery.of(context).padding.bottom : 40,
        padding: _isFullScreen
            ? EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
                left: MediaQuery.of(context).padding.left,
                right: MediaQuery.of(context).padding.right,
              )
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color.fromRGBO(0, 0, 0, .7), Color.fromRGBO(0, 0, 0, .1)],
          ),
        ),
        child: _videoInit
            ? Row(
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 26,
                    icon: Icon(
                      _controller!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller!.value.isPlaying
                            ? _controller!.pause()
                            : _controller!.play();
                        _startPlayControlTimer();
                      });
                    },
                  ),
                  Expanded(
                    child: _VideoProgressIndicator(
                      _controller!,
                      padding: EdgeInsets.all(0),
                      colors: VideoProgressColors(
                        playedColor: Colors.red,
                        bufferedColor: Color.fromRGBO(255, 255, 255, .5),
                        backgroundColor: Color.fromRGBO(255, 255, 255, .2),
                      ),
                      updatingHandler: _startPlayControlTimer,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      durationToTime(_position) +
                          ' / ' +
                          durationToTime(_controller!.value.duration),
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Colors.white,
                            height: 1,
                          ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 26,
                    icon: Icon(
                      _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _toggleFullScreen();
                    },
                  ),
                ],
              )
            : Container(),
      ),
    );

    Widget _topControl = Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: widget.width,
        height: _isFullScreen ? 60 : 40,
        padding: _isFullScreen
            ? EdgeInsets.only(
                left: MediaQuery.of(context).padding.left,
                right: MediaQuery.of(context).padding.right,
              )
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(0, 0, 0, .7), Color.fromRGBO(0, 0, 0, .1)],
          ),
        ),
        child: Column(
          children: <Widget>[
            if (_isFullScreen)
              Container(
                height: 20,
                child: Center(
                  child: Text(
                    '$hh:$mm',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            Container(
              height: 40,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_isFullScreen) {
                        _toggleFullScreen();
                      } else {
                        Get.back();
                      }
                    },
                  ),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
//                              fontSize: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.background,
      child: widget.url != ''
          ? Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _togglePlayControl();
                  },
                  child: _videoInit
                      ? Container(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).padding.left,
                            right: MediaQuery.of(context).padding.right,
                          ),
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: VideoPlayer(_controller!),
                            ),
                          ),
                        )
                      : Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: width(2.0),
                            ),
                          ),
                        ),
                ),
                IgnorePointer(
                  ignoring: _playControlOpacity == 0,
                  child: AnimatedOpacity(
                    opacity: _playControlOpacity,
                    duration: Duration(milliseconds: 300),
                    child: Stack(
                      children: [
                        _topControl,
                        _bottomControl,
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                '暂无视频信息',
                style: TextStyle(color: Colors.white),
              ),
            ),
    );
  }

  @override
  void initState() {
    _urlChange();
    super.initState();
  }

  @override
  void didUpdateWidget(MyVideo oldWidget) {
    if (oldWidget.url != widget.url) {
      _urlChange();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _urlChange() {
    if (widget.url == '') return;
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    setState(() {
      _playControlOpacity = 0;
      _videoInit = false;
      _position = Duration(seconds: 0);
    });
    try {
      switch (getVideoOrigin(widget.url)) {
        case 'network':
          _controller = VideoPlayerController.network(widget.url);
          break;
        case 'assets':
          _controller = VideoPlayerController.asset(widget.url);
          break;
        default:
          _controller = VideoPlayerController.file(File(widget.url));
          break;
      }
    } catch (e) {
      print(e);
    }
    _controller!.initialize().then((_) {
      _controller!.setVolume(1);
      _controller!.setLooping(widget.loop);
      _controller!.addListener(_videoListener);
      setState(() {
        _videoInit = true;
        if (widget.autoplay) _controller!.play();
      });
    });
  }

  void _videoListener() async {
    Duration res = (await _controller!.position)!;
    if (!widget.loop && res >= _controller!.value.duration) {
      _controller!.pause();
      _controller!.seekTo(Duration(seconds: 0));
    }
    setState(() {
      _position = res;
    });
  }

  void _togglePlayControl() {
    if (widget.controls) {
      setState(() {
        if (_playControlOpacity == 0) {
          _playControlOpacity = 1;
          _startPlayControlTimer();
        } else {
          _timer?.cancel();
          _playControlOpacity = 0;
        }
      });
    }
  }

  void _startPlayControlTimer() {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: 3), () {
      setState(() {
        _playControlOpacity = 0;
      });
    });
  }

  void _toggleFullScreen() {
    setState(() {
      if (_isFullScreen) {
        // 设置竖屏
        FlutterOrientation.setOrientation(DeviceOrientation.portraitUp);
      } else {
        // 设置横屏
        FlutterOrientation.setOrientation(DeviceOrientation.landscapeRight);
      }
      _startPlayControlTimer();
      if (widget.screenChange != null) widget.screenChange!();
    });
  }

  String getVideoOrigin(String url) {
    if (RegExp(r"^https?:\/\/\S+").hasMatch(url)) {
      return 'network';
    } else if (RegExp(r"^assets\/\S+").hasMatch(url)) {
      return 'assets';
    }
    return 'file';
  }

  String durationToTime(Duration duration) {
    int h = duration.inHours;
    int m = duration.inMinutes % 60;
    int s = duration.inSeconds % 60;
    return '${h > 0 ? h.toString() + ':' : ''}${m < 10 ? '0' + m.toString() : m}:${s < 10 ? '0' + s.toString() : s}';
  }
}

// 播放进度手势操作和进度ui
class _VideoScrubber extends StatefulWidget {
  _VideoScrubber({
    required this.child,
    required this.controller,
    this.updatingHandler,
  });

  final Widget child;
  final VideoPlayerController controller;
  final Function? updatingHandler;

  @override
  _VideoScrubberState createState() => _VideoScrubberState();
}

class _VideoScrubberState extends State<_VideoScrubber> {
  bool _controllerWasPlaying = false;

  VideoPlayerController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    void seekToRelativePosition(Offset globalPosition) {
      final RenderObject? box = context.findRenderObject();
      final Offset tapPos = (box as RenderBox).globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position = controller.value.duration * relative;
      controller.seekTo(position);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.child,
      onHorizontalDragStart: (DragStartDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        _controllerWasPlaying = controller.value.isPlaying;
        if (_controllerWasPlaying) {
          controller.pause();
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
        if (widget.updatingHandler != null) widget.updatingHandler!();
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (_controllerWasPlaying) {
          controller.play();
        }
      },
      onTapDown: (TapDownDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
        if (widget.updatingHandler != null) widget.updatingHandler!();
      },
    );
  }
}

/// Displays the play/buffering status of the video controlled by [controller].
///
/// If [allowScrubbing] is true, this widget will detect taps and drags and
/// seek the video accordingly.
///
/// [padding] allows to specify some extra padding around the progress indicator
/// that will also detect the gestures.
class _VideoProgressIndicator extends StatefulWidget {
  _VideoProgressIndicator(
    this.controller, {
    VideoProgressColors? colors,
    this.allowScrubbing = true,
    this.padding = const EdgeInsets.all(0),
    this.height = 5.0,
    this.updatingHandler,
  }) : colors = colors ?? VideoProgressColors();

  final VideoPlayerController controller;
  final VideoProgressColors colors;
  final bool allowScrubbing;
  final EdgeInsets padding;
  final double height;
  final Function? updatingHandler;

  @override
  createState() => _VideoProgressIndicatorState();
}

class _VideoProgressIndicatorState extends State<_VideoProgressIndicator> {
  _VideoProgressIndicatorState() {
    listener = () {
      setState(() {});
    };
  }

  VoidCallback? listener;

  VideoPlayerController get controller => widget.controller;

  VideoProgressColors get colors => widget.colors;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener!);
  }

  @override
  void deactivate() {
    controller.removeListener(listener!);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Widget progressIndicator;
    if (controller.value.isInitialized) {
      final int duration = controller.value.duration.inMilliseconds;
      final int position = controller.value.position.inMilliseconds;

      int maxBuffering = 0;
      for (DurationRange range in controller.value.buffered) {
        final int end = range.end.inMilliseconds;
        if (end > maxBuffering) {
          maxBuffering = end;
        }
      }

      progressIndicator = FractionallySizedBox(
        heightFactor: 1,
        child: Center(
          child: Container(
            height: widget.height,
            child: Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                LinearProgressIndicator(
                  value: maxBuffering / duration,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colors.bufferedColor),
                  backgroundColor: colors.backgroundColor,
                ),
                LinearProgressIndicator(
                  value: position / duration,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      progressIndicator = LinearProgressIndicator(
        value: null,
        valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
        backgroundColor: colors.backgroundColor,
      );
    }
    final Widget paddedProgressIndicator = Padding(
      padding: widget.padding,
      child: progressIndicator,
    );
    if (widget.allowScrubbing) {
      return _VideoScrubber(
        child: paddedProgressIndicator,
        controller: controller,
        updatingHandler: widget.updatingHandler,
      );
    } else {
      return paddedProgressIndicator;
    }
  }
}

class VideoProgressColors {
  const VideoProgressColors({
    this.playedColor = const Color.fromRGBO(255, 0, 0, 0.7),
    this.bufferedColor = const Color.fromRGBO(50, 50, 200, 0.4),
    this.backgroundColor = const Color.fromRGBO(200, 200, 200, 0.5),
  });

  final Color playedColor;

  final Color bufferedColor;

  final Color backgroundColor;
}
