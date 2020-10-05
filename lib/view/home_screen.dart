import 'package:background_timer_sample/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, model, child) {
        final isTimerRunning = model.isTimerRunning;
        final displayTimeSeconds = model.displayTimeSeconds;
        final isPause = model.isPause;
        //print("timer: ${displayTimeSeconds.toString()}");
        return Scaffold(
          floatingActionButton: (isTimerRunning)
              ? Container()
              : FloatingActionButton(
                  child: Icon(Icons.clear),
                  onPressed: () => _clear(context),
                ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 240.0,
                  icon: (isTimerRunning && !isPause)
                      ? Icon(Icons.pause_circle_outline)
                      : Icon(Icons.play_circle_outline),
                  onPressed: (isTimerRunning && !isPause)
                      ? () => _pause(context)
                      : (!isTimerRunning)
                          ? () => _start(context)
                          : () => _resume(context),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  displayTimeSeconds.toString(),
                  style: TextStyle(fontSize: 60.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _clear(BuildContext context) {
    final viewModel = context.read<HomeViewModel>();
    viewModel.clear();
  }

  _pause(BuildContext context) {
    final viewModel = context.read<HomeViewModel>();
    viewModel.pause();
  }

  _start(BuildContext context) {
    final viewModel = context.read<HomeViewModel>();
    viewModel.start();
  }

  _resume(BuildContext context) {
    final viewModel = context.read<HomeViewModel>();
    viewModel.resume();
  }
}
