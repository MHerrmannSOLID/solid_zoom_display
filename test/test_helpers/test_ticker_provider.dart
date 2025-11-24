import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class TestTickerProvider implements TickerProvider{

  TickerCallback tickerCallback = (Duration duration) {};

  @override
  Ticker createTicker(TickerCallback onTick) {
    tickerCallback = onTick;
    return Ticker(onTick);
  }

}