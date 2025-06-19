import 'dart:async';

class TimerManager {
  int _seconds = 0;
  int _minutes = 0;
  Timer? timer;
  void Function()? onTick;

  bool isFinished() {
    return _minutes == 0 && _seconds == 0;
  }

  TimerManager(int minutes, int seconds, String color, {this.onTick}) {
    _minutes = minutes;
    _seconds = seconds;
  }

  int getSeconds() {
    return _seconds;
  }

  int getMinutes() {
    return _minutes;
  }

  void setSeconds(int seconds) {
    _seconds = seconds;
  }

  void setMinutes(int minutes) {
    _minutes = minutes;
  }

  void start() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (_seconds == 0 && _minutes == 0) {
        t.cancel();
      } else {
        if (_seconds == 0) {
          _minutes--;
          _seconds = 59;
        } else {
          _seconds--;
        }
      }
      if (onTick != null) onTick!();
    });
  }

  void stop() {
    if (timer != null) {
      timer!.cancel();
    }
  }

  void addSeconds(int seconds) {
    _seconds += seconds;
    if (_seconds < 0) {
      _minutes--;
      _seconds = 60 + _seconds;
      if (_minutes < 0) {
        _minutes = 0;
        _seconds = 0;
      }
    }
    while (_seconds >= 60) {
      _minutes += 1;
      _seconds = _seconds - 60;
    }
  }
}
