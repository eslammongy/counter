import 'dart:async';
import 'package:counter_app/bloc/ticker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:counter_app/bloc/timer_events.dart';
import 'package:counter_app/bloc/timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static const int _duration = 60;
  final Ticker _ticker;
  StreamSubscription<int> _tickerSubsription;
  TimerBloc({@required Ticker ticker})
      : assert(ticker != null),
        _ticker = ticker,
        super(TimerInitial(_duration));

  @override
  Stream<TimerState> mapEventToState(TimerEvent event) async* {
    //start
    if (event is TimerStarted) {
      yield* _mapTimerStartedToState(event);
    } // paused
    else if (event is TimerPaused) {
      yield* __mapTimerPausedToState(event);
    } // resume
    else if (event is TimerResumed) {
      yield* _mapTimerResumedToState(event);
    } // reset
    else if (event is TimerReset) {
      yield* _mapTimerResetToState(event);
    }
    //ticked
    else if (event is TimerTicked) {
      yield* _mapTimerTickedToState(event);
    }
  }

  @override
  Future<void> close() {
    _tickerSubsription.cancel();
    return super.close();
  }

  Stream<TimerState> _mapTimerStartedToState(TimerStarted start) async* {
    yield TimerRunInProgress(start.duration);
    _tickerSubsription?.cancel();
    _tickerSubsription = _ticker
        .tick(ticks: start.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  Stream<TimerState> _mapTimerResumedToState(TimerResumed resumed) async* {
    if (state is TimerRunPause) {
      _tickerSubsription.resume();
      yield TimerRunInProgress(state.duration);
    }
  }

  Stream<TimerState> _mapTimerResetToState(TimerReset reset) async* {
    _tickerSubsription.cancel();
    yield TimerInitial(_duration);
  }

  Stream<TimerState> __mapTimerPausedToState(TimerPaused paused) async* {
    if (state is TimerRunInProgress) {
      _tickerSubsription?.pause();
      yield TimerRunPause(state.duration);
    }
  }

  Stream<TimerState> _mapTimerTickedToState(TimerTicked tick) async* {
    yield tick.duration > 0
        ? TimerRunInProgress(tick.duration)
        : TimerRunComplete();
  }
}
