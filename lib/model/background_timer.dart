import 'dart:async';
import 'dart:isolate';

import 'package:background_timer_sample/view_model/home_view_model.dart';
import 'package:flutter/material.dart';

/*
* Isolateは完全に別アプリ！（メモリを共有しない = スレッドではない！）
* => 仮にクラスの中にstaticで関数を定義したとしても、実態は別アプリなので変数の共有もできない！
* => Isolateとのやり取りはメッセージを経由しないといけない！
*
* dart isolate を理解したい
* https://qiita.com/shindex/items/3f7ef622d9244d198ff4
*
* Dartでマルチスレッド（マルチアイソレート）処理
* https://sbfl.net/blog/2014/07/10/multithreading-in-dart/
*
* */

class BackgroundTimer {
  //Isolate.spawnで呼び出す関数はstaticかtoplevelでないとエラーになる
  //Isolate.spawn expects to be passed a static or top-level function
  static int timeSeconds = INITIAL_SECONDS;
  static bool isRunning = false;

  //子供
  static void startTimer(SendPort parentSendPort) async {
    isRunning = true;

    //親から子供への伝達の設定
    //-> 子にも郵便受け（SendPort）を用意して、その住所（SendPort）を親に伝えること
    //https://qiita.com/shindex/items/3f7ef622d9244d198ff4#%E8%A6%AA%E3%81%8B%E3%82%89%E5%AD%90%E3%81%B8%E9%80%9A%E4%BF%A1%E3%81%99%E3%82%8B
    // final receivePort = ReceivePort();
    // final sendPort = receivePort.sendPort;
    // parentSendPort.send(sendPort);

    Timer.periodic(Duration(seconds: 1), (timer) {

      timeSeconds--;
      //子供から親への伝達（ここからしかデータは渡せないので時間もちゃんと返してあげないといけない）
      parentSendPort.send(SendData(
        isRunning: isRunning,
        timeSeconds: timeSeconds,
      ),);

      if (timeSeconds <= 0 || !isRunning) {
        timer.cancel();
        //子供から親への伝達
        isRunning = false;
        parentSendPort.send(SendData(
          isRunning: isRunning,
          timeSeconds: timeSeconds,
        ));
      }
    });
  }
}