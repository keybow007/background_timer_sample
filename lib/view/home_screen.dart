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
        print("timer: ${displayTimeSeconds.toString()}");
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
                  icon: (isTimerRunning)
                      ? Icon(Icons.pause_circle_outline)
                      : Icon(Icons.play_circle_outline),
                  onPressed: (isTimerRunning)
                      ? () => _stop(context)
                      : () => _start(context),
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

  _stop(BuildContext context) {
    final viewModel = context.read<HomeViewModel>();
    viewModel.stop();
  }

  _start(BuildContext context) {
    final viewModel = context.read<HomeViewModel>();
    viewModel.start();
  }
}
