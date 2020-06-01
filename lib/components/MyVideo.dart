import 'dart:math';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:orientation/orientation.dart';
import 'package:flutter_play/variable.dart';

class MyVideo extends StatefulWidget {
  MyVideo({
    @required this.url,
    @required this.width,
    @required this.height,
    this.autoplay = false,
    this.loop = false,
    this.title = '',
    this.screenChange,
  });

  // 视频地址
  final String url;
  // 视频尺寸比例
  final double width;
  final double height;
  // 是否自动播放
  final bool autoplay;
  // 是否循环播放
  final bool loop;
  // 视频标题
  final String title;
  // 切换横竖屏回调
  final Function screenChange;

  @override
  State<MyVideo> createState() {
    return _MyVideoState();
  }
}

class _MyVideoState extends State<MyVideo> {
  // 指示video资源是否加载完成
  bool _videoInit = false;
  // video控件管理器
  VideoPlayerController _controller;
  // 记录video播放进度
  Duration _position = Duration(seconds: 0);
  // 记录播放控件ui是否显示(进度条，播放按钮，全屏按钮等等)
  Timer _timer;
  bool _hidePlayControl = true;
  double _playControlOpacity = 0;
  // 记录是否全屏
  bool get _isFullScreen => MediaQuery.of(context).orientation==Orientation.landscape;

  @override
  Widget build(BuildContext context) {
    // 全屏时显示当前时间
    DateTime now = DateTime.now();
    String hh = now.hour<10?'0${now.hour}':'${now.hour}';
    String mm = now.minute<10?'0${now.minute}':'${now.minute}';
    // 底部播放器控制栏
    Widget _bottomControl = Positioned(
      left: 0,
      bottom: 0,
      child: Offstage(
        offstage: _hidePlayControl,
        child: AnimatedOpacity(
          opacity: _playControlOpacity,
          duration: Duration(milliseconds: 300),
          child: Container(
            width: widget.width,
            height: _isFullScreen?60:40,
            padding: _isFullScreen?EdgeInsets.only(bottom: 20,left: 20,right: 20):EdgeInsets.zero,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color.fromRGBO(0, 0, 0, .7), Color.fromRGBO(0, 0, 0, .1)],
              ),
            ),
            child: _videoInit?Row(
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 26,
                  icon: Icon(
                    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: (){
                    setState(() {
                      _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                      _startPlayControlTimer();
                    });
                  },
                ),
                Expanded(
                  child: _VideoProgressIndicator(
                    _controller,
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
                    durationToTime(_position)+'/'+durationToTime(_controller.value.duration),
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 26,
                  icon: Icon(
                    _isFullScreen?Icons.fullscreen_exit:Icons.fullscreen,
                    color: Colors.white,
                  ),
                  onPressed: (){
                    _toggleFullScreen();
                  },
                ),
              ],
            ):Container(),
          ),
        ),
      ),
    );

    Widget _topControl = Positioned(
      left: 0,
      top: 0,
      child: Offstage(
        offstage: _hidePlayControl,
        child: AnimatedOpacity(
          opacity: _playControlOpacity,
          duration: Duration(milliseconds: 300),
          child: Container(
            width: widget.width,
            height: _isFullScreen?60:40,
            padding: _isFullScreen?EdgeInsets.only(left: 20,right: 20):EdgeInsets.zero,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromRGBO(0, 0, 0, .7), Color.fromRGBO(0, 0, 0, .1)],
              ),
            ),
            child: Column(
              children: <Widget>[
                Offstage(
                  offstage: !_isFullScreen,
                  child: Container(
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
                ),
                Container(
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      Offstage(
                        offstage: !_isFullScreen,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _toggleFullScreen();
                          },
                        ),
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
        ),
      ),
    );

    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black,
      child: widget.url!=null?Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _togglePlayControl();
            },
            child: _videoInit?
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ):
            Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          _bottomControl,
          _topControl,
        ],
      ):Center(
        child: Text(
          '暂无视频信息',
          style: TextStyle(
            color: Colors.white
          ),
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
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    if (_controller!=null) {
      _controller.removeListener(_videoListener);
      _controller.dispose();
    }
    super.dispose();
  }

  void _urlChange() {
    if (widget.url==null || widget.url=='') return;
    if (_controller!=null) {
      _controller.removeListener(_videoListener);
      _controller.dispose();
    }
    setState(() {
      _hidePlayControl = true;
      _videoInit = false;
      _position = Duration(seconds: 0);
    });
    _controller = VideoPlayerController.network(widget.url);
    _controller.initialize().then((_) {
      _controller.setVolume(1);
      _controller.setLooping(widget.loop);
      _controller.addListener(_videoListener);
      setState(() {
        _videoInit = true;
        if (widget.autoplay) _controller.play();
      });
    });
  }

  void _videoListener() async {
    Duration res = await _controller.position;
    if (res >= _controller.value.duration) {
      _controller.pause();
      _controller.seekTo(Duration(seconds: 0));
    }
    setState(() {
      _position = res;
    });
  }

  void _togglePlayControl() {
    setState(() {
      if (_hidePlayControl) {
        _hidePlayControl = false;
        _playControlOpacity = 1;
        _startPlayControlTimer();
      } else {
        if (_timer!=null) _timer.cancel();
        _playControlOpacity = 0;
        Future.delayed(Duration(milliseconds: 300)).whenComplete(() {
          _hidePlayControl = true;
        });
      }
    });
  }

  void _startPlayControlTimer() {
    if (_timer!=null) _timer.cancel();
    _timer = Timer(Duration(seconds: 3), () {
      setState(() {
        _playControlOpacity = 0;
        Future.delayed(Duration(milliseconds: 300)).whenComplete(() {
          _hidePlayControl = true;
        });
      });
    });
  }

  void _toggleFullScreen() {
    setState(() {
      if (_isFullScreen) {
        OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
      } else {
        OrientationPlugin.forceOrientation(DeviceOrientation.landscapeRight);
      }
      _startPlayControlTimer();
      if (widget.screenChange!=null) widget.screenChange();
    });
  }
}



// 播放进度手势操作和进度ui
class _VideoScrubber extends StatefulWidget {
  _VideoScrubber({
    @required this.child,
    @required this.controller,
    this.updatingHandler,
  });

  final Widget child;
  final VideoPlayerController controller;
  final Function updatingHandler;

  @override
  _VideoScrubberState createState() => _VideoScrubberState();
}

class _VideoScrubberState extends State<_VideoScrubber> {
  bool _controllerWasPlaying = false;

  VideoPlayerController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    void seekToRelativePosition(Offset globalPosition) {
      final RenderBox box = context.findRenderObject();
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position = controller.value.duration * relative;
      controller.seekTo(position);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.child,
      onHorizontalDragStart: (DragStartDetails details) {
        if (!controller.value.initialized) {
          return;
        }
        _controllerWasPlaying = controller.value.isPlaying;
        if (_controllerWasPlaying) {
          controller.pause();
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!controller.value.initialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
        if (widget.updatingHandler!=null) widget.updatingHandler();
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (_controllerWasPlaying) {
          controller.play();
        }
      },
      onTapDown: (TapDownDetails details) {
        if (!controller.value.initialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
        if (widget.updatingHandler!=null) widget.updatingHandler();
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
      VideoProgressColors colors,
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
  final Function updatingHandler;

  @override
  createState() => _VideoProgressIndicatorState();
}

class _VideoProgressIndicatorState extends State<_VideoProgressIndicator> {
  _VideoProgressIndicatorState() {
    listener = () {
      setState(() {});
    };
  }

  VoidCallback listener;

  VideoPlayerController get controller => widget.controller;

  VideoProgressColors get colors => widget.colors;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Widget progressIndicator;
    if (controller.value.initialized) {
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
                  valueColor: AlwaysStoppedAnimation<Color>(colors.bufferedColor),
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