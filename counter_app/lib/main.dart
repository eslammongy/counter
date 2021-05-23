import 'package:counter_app/bloc/timer_bloc.dart';
import 'package:counter_app/ui/timer.dart';
import 'package:flutter/material.dart';
import 'package:counter_app/bloc/ticker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        accentColor: Color.fromRGBO(72, 74, 126, 1),
        brightness: Brightness.dark,
      ),
      title: 'Flutter Timer',
      home: BlocProvider(
        create: (context) => TimerBloc(ticker: Ticker()),
        child: TimerScreen(),
      ),
    );
  }
}
