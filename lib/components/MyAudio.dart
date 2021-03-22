import 'package:audioplayers/audioplayers.dart';

class MyAudio {
  static AudioPlayer? _instance;

  PlayerMode mode;

  AudioPlayerState? get state => _instance?.state;

  Duration _duration = Duration();
  Duration get duration => _duration;

  Duration _position = Duration();
  Duration get position => _position;

  Stream<Duration>? get onDurationChanged => _instance?.onDurationChanged;
  Stream<Duration>? get onPositionChanged => _instance?.onAudioPositionChanged;
  Stream<void>? get onPlayComplete => _instance?.onPlayerCompletion;

  MyAudio({
    this.mode = PlayerMode.MEDIA_PLAYER,
  }) {
    if (_instance == null) {
      _instance = AudioPlayer(playerId: 'my_audio', mode: mode);
      _instance!.setReleaseMode(ReleaseMode.STOP);
      _instance!.onDurationChanged.listen((Duration d) {
        print('get duration: $d');
        _duration = d;
      });
      _instance!.onAudioPositionChanged.listen((Duration p) {
        _position = p;
      });
      _instance!.onPlayerError.listen((msg) {
        _duration = Duration();
        _position = Duration();
      });
    }
  }

  Future<bool> setUrl(String url) async {
    _position = Duration();
    _duration = Duration();
    int result = await _instance!.setUrl(url);
    return result == 1;
  }

  Future<bool> play(String url) async {
    int result = await _instance!.play(url);
    return result == 1;
  }

  Future<bool> playAsset(String localPath) async {
    int result = await _instance!.play(localPath, isLocal: true);
    return result == 1;
  }

  Future<bool> pause() async {
    int result = await _instance!.pause();
    return result == 1;
  }

  Future<bool> stop() async {
    int result = await _instance!.stop();
    return result == 1;
  }

  Future<bool> resume() async {
    int result = await _instance!.resume();
    return result == 1;
  }

  Future<bool> seek(Duration duration) async {
    int result = await _instance!.seek(duration);
    if (state == AudioPlayerState.PAUSED) _instance!.resume();
    return result == 1;
  }

  Future<bool> setVolume(double volume) async {
    int result = await _instance!.setVolume(volume);
    return result == 1;
  }

  void dispose() {
    _instance?.dispose();
  }
}
