import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class TestAnimationController extends Fake implements AnimationController{
  VoidCallback animationCallback = () {};
  bool clearListenersCalled = false;
  double _animationValue = 0.0;

  @override
  void addListener(VoidCallback listener) {
    animationCallback = listener;
  }

  @override
  double get value => _animationValue;


  void moveAnimationTo(double value){
    _animationValue = value;
    animationCallback();
  }

  @override
  TickerFuture forward({ double? from }){
    animationCallback();
    return TickerFuture.complete();
  }

  @override
  void clearListeners(){
    clearListenersCalled = true;
  }
}