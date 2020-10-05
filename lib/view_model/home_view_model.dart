import 'dart:async';
import 'dart:isolate';

import 'package:background_timer_sample/model/background_timer.dart';
import 'package:flutter/material.dart';

/*
* How to run clock timer in background on flutter?
* https://codingwithjoe.com/dart-fundamentals-isolates/
*
* dart isolate を理解したい（これいいよ！）
* https://qiita.com/shindex/items/3f7ef622d9244d198ff4
*
* Isolate間のやり取りは、たとえ同じクラス内にいたとしても、同じ変数は共有できず、メッセージで介さないといけない
*
* 参考コード
* https://gist.github.com/jebright/a7086adc305615aa3a655c6d8bd90264
* */

const int INITIAL_SECONDS = 20;

//Isolate間でのデータ伝達のためのデータクラス
@immutable
class SendData {
  final bool isRunning;
  final int timeSeconds;

  SendData({this.isRunning, this.timeSeconds});
}

class HomeViewModel extends ChangeNotifier {
  bool isTimerRunning = false;
  bool isPause = false;
  int displayTimeSeconds = INITIAL_SECONDS;

  //https://gist.github.com/jebright/a7086adc305615aa3a655c6d8bd90264
  Isolate isolate;
  final receivePort = ReceivePort();

  void start() async {
    isTimerRunning = true;
    final sendPort = receivePort.sendPort;

    //バックグラウンド
    isolate = await Isolate.spawn(BackgroundTimer.startTimer, sendPort);
    receivePort.listen((data) {
      final sendData = data as SendData;
      isTimerRunning = sendData.isRunning;
      displayTimeSeconds = sendData.timeSeconds;
      print("isTimerRunning: $isTimerRunning");
      print("displayTimeSeconds: $displayTimeSeconds");
      if (!isTimerRunning) {
        closeIsolate();
      }
      notifyListeners();
    });


  }

  void pause() {
    //isTimerRunning = false;
    //closeIsolate();
    isPause = true;
    isolate.pause(isolate.pauseCapability);
    notifyListeners();
  }

  void clear() {
    //displayTimeSeconds = INITIAL_SECONDS;
    displayTimeSeconds = INITIAL_SECONDS;
    notifyListeners();
  }

  void closeIsolate() {
    if (isolate != null) {
      receivePort.close();
      isolate.kill(priority: Isolate.immediate);
      isolate = null;
    }
  }

  void resume() {
    isPause = false;
    isolate.resume(isolate.pauseCapability);
    notifyListeners();
  }
}
