import 'package:background_timer_sample/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/home_screen.dart';

void main() {
  runApp(ChangeNotifierProvider<HomeViewModel>(
    create: (_) => HomeViewModel(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BackgroundTimerSample",
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
