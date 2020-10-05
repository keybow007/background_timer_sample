import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';

/*
* How to run clock timer in background on flutter?
* https://codingwithjoe.com/dart-fundamentals-isolates/
* */

const int INITIAL_SECONDS = 20;

class HomeViewModel extends ChangeNotifier {
  bool isTimerRunning = false;
  int displayTimeSeconds = INITIAL_SECONDS;

  //https://gist.github.com/jebright/a7086adc305615aa3a655c6d8bd90264
  Isolate isolate;
  final receivePort = ReceivePort();


  void start() async {
    isTimerRunning = true;
    isolate = await Isolate.spawn(_startTimer, null);
    receivePort.listen((message) { })
    notifyListeners();
  }

  //Isolate.spawnで呼び出す関数はstaticかtoplevelでないとエラーになる
  //Isolate.spawn expects to be passed a static or top-level function
  static void _startTimer(void _) async {
    Timer.periodic(Duration(seconds: 1), (timer) {
      displayTimeSeconds -= 1;
      if (displayTimeSeconds <= 0 || !isTimerRunning) {
        timer.cancel();
        if (isolate != null) {
          isolate.kill();
          isolate = null;
        }
      }
    });
  }

  void stop() {
    isTimerRunning = false;
    notifyListeners();
  }

  void clear() {
    displayTimeSeconds = INITIAL_SECONDS;
    notifyListeners();
  }


}