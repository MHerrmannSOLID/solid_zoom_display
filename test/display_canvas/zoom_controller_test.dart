import 'dart:math';
import 'dart:ui';
import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/src/display_canvas/zoom_controller.dart';
import 'package:solid_zoom_display/src/types/invalid_point.dart';
import '../test_helpers/test_animation_controller.dart';

void main(){

    test('Zoom controller trigger relayout '
        '--> Should trigger change notification', (){
      var gotChangeNotification = false;
      var zoomController = ZoomController(animationController: TestAnimationController());
      zoomController.addListener(() {gotChangeNotification = true;});
      zoomController.repLayout();
      expect(gotChangeNotification, true);
    });

    test('Zoom controller trigger relayout for image centered in X'
        '--> Image is 200x200 but widget is 300x100 --> images scaled by 0.5  (100x100) '
        '--> that means for x 300 -100 = 200 --> 100 padding left and right --> imgpos.X ~ 100', (){
      final zoomController = ZoomController(animationController: TestAnimationController());
      zoomController.canvasSize = Size(200,200);
      zoomController.widgetScreenSize = Size(300,100);
      zoomController.repLayout();
      final imgPos = zoomController.imgPosition;
      expect(zoomController.zoomFactor, 0.49);
      expect(imgPos.x, 101);
      expect(imgPos.y, 1);
    });

    test('Zoom controller panning image (based on relayout test)'
        '--> After relayout pos id 101,1 and after panning 1,1', (){
      final zoomController = ZoomController(animationController: TestAnimationController());
      zoomController.canvasSize = Size(200,200);
      zoomController.widgetScreenSize = Size(300,100);
      zoomController.repLayout();
      final imgPosBeforePanning = zoomController.imgPosition;
      expect(imgPosBeforePanning.x, 101);
      expect(imgPosBeforePanning.y, 1);
      zoomController.panImageAbout(Point<num>(-100,0));
      final imgPos = zoomController.imgPosition;
      expect(imgPos.x, 1);
      expect(imgPos.y, 1);
    });

    test('Zoom controller scaling about a delta of -224.49 '
        '--> Image position and zoom will match pre-calculated values.', (){
      final zoomController = ZoomController(animationController: TestAnimationController());
      zoomController.canvasSize = Size(200,200);
      zoomController.widgetScreenSize = Size(300,100);
      zoomController.repLayout();

      zoomController.scaleAbout(mousePosition:  Point<num>(100,100),delta: -224);

      var imagePos = zoomController.imgPosition;
      expect(imagePos.x, closeTo(101.224, 0.001));
      expect(imagePos.y, closeTo(-21.176, 0.001));
      expect( zoomController.zoomFactor, 0.59976);
    });

    test('Scaling with scale about '
        '--> expecting a notification on the onZoom callback',(){
      num zoomNotification = double.nan;
      final zoomController = ZoomController(animationController: TestAnimationController(),)..
      zoomHandler = (zoom) => zoomNotification = zoom;
      zoomController.canvasSize = Size(200,200);
      zoomController.widgetScreenSize = Size(300,100);
      expect(zoomNotification, isNaN);
      zoomController.repLayout();
      expect(zoomNotification, closeTo(0.490, 0.001));
      zoomController.scaleAbout(mousePosition:  Point<num>(100,100),delta: -224);
      expect( zoomNotification, 0.59976);
    });

    test('Zoom controller scaling about a delta of -224.49 '
        '--> Zoom changed will be notified through change notifier.', (){
      final zoomController = ZoomController(animationController: TestAnimationController());
      var gotChangeNotification = false;
      zoomController.canvasSize = Size(200,200);
      zoomController.widgetScreenSize = Size(300,100);
      zoomController.repLayout();
      zoomController.addListener(() {gotChangeNotification = true;});

      zoomController.scaleAbout(mousePosition:  Point<num>(100,100),delta: -224);

      expect(gotChangeNotification, true);
    });

    test('Zoom controller scaling about invalid point '
        '--> Zoom call will abort before changing anything.', (){
      final zoomController = ZoomController(animationController: TestAnimationController());
      var gotChangeNotification = false;
      zoomController.canvasSize = Size(200,200);
      zoomController.widgetScreenSize = Size(300,100);
      zoomController.repLayout();
      zoomController.addListener(() {gotChangeNotification = true;});

      zoomController.scaleAbout(mousePosition: InvalidPoint(),delta: -224);

      expect(gotChangeNotification, false);
      expect(zoomController.zoomFactor, 0.49);
      expect(zoomController.imgPosition.x, 101);
      expect(zoomController.imgPosition.y, 1);
    });

    test('Zoom controller Scale to fit animation '
        '--> Zoom position is a calculated and image position as given.', (){
      final zoomedInFactor = 0.59976;
      final animationPos = 0.7;
      final initialZoom = 0.49;
      final testAnimationController = TestAnimationController();
      final zoomController = ZoomController(animationController: testAnimationController);
      zoomController.canvasSize = Size(200,200);
      zoomController.widgetScreenSize = Size(300,100);
      zoomController.repLayout();

      zoomController.scaleAbout(mousePosition:  Point<num>(100,100),delta: -224);

      var imagePos_0 = zoomController.imgPosition;
      expect(imagePos_0.x, closeTo(101.224, 0.001));
      expect(imagePos_0.y, closeTo(-21.176, 0.001));
      expect( zoomController.zoomFactor, zoomedInFactor);

      zoomController.scaleToFit();
      testAnimationController.moveAnimationTo(1.0-animationPos);

      expect( zoomController.zoomFactor, (zoomedInFactor-initialZoom)*animationPos+initialZoom);
      final imagePos_70 = zoomController.imgPosition;
      expect(imagePos_70.x, closeTo( 101.1568,0.001));
      expect(imagePos_70.y, closeTo( -14.5232,0.001));
    });

    test('Zoom controller Scale to fit animation '
        '--> Calls the on change callback on each animation step.', (){
      var changeNotifications = 0;
      final testAnimationController = TestAnimationController();
      final zoomController = ZoomController(animationController: testAnimationController);
      zoomController.canvasSize = Size(200,200);
      zoomController.widgetScreenSize = Size(300,100);
      zoomController.repLayout();
      zoomController.scaleAbout(mousePosition:  Point<num>(100,100),delta: -224);

      zoomController.addListener(()=> changeNotifications++);

      zoomController.scaleToFit();
      testAnimationController.moveAnimationTo(0.1);
      testAnimationController.moveAnimationTo(0.4);
      testAnimationController.moveAnimationTo(0.6);
      testAnimationController.moveAnimationTo(0.8);

      expect(changeNotifications, 5);

    });

    test('Zoom controller Scale to fit animation '
        '--> Calls the onZoom callback on each animation step.', (){
      final testAnimationController = TestAnimationController();
      num lastZoom = double.nan;
      final zoomController = ZoomController(animationController: testAnimationController,)..
      zoomHandler = (zoom) => lastZoom = zoom;
      zoomController.canvasSize = Size(200,200);
      zoomController.widgetScreenSize = Size(300,100);
      zoomController.repLayout();

      expect(lastZoom, closeTo(0.49, 0.01));
      zoomController.scaleAbout(mousePosition:  Point<num>(100,100),delta: -224);
      expect(lastZoom, closeTo(0.59976, 0.00001));

      zoomController.scaleToFit();
      testAnimationController.moveAnimationTo(0.1);
      expect(lastZoom, closeTo(0.588784, 0.00001));
      testAnimationController.moveAnimationTo(0.4);
      expect(lastZoom, closeTo(0.555856, 0.00001));
      testAnimationController.moveAnimationTo(0.6);
      expect(lastZoom, closeTo(0.5339039999999999, 0.00001));
      testAnimationController.moveAnimationTo(0.8);
      expect(lastZoom, closeTo(0.511952, 0.00001));
    });

    test('Zoom controller Scale to fit animation '
        '--> Notifies the onZoom callback on each step.', ()async{
      var changeNotifications = 0;
      final testAnimationController = TestAnimationController();
      final zoomController = ZoomController(animationController: testAnimationController);
      zoomController.canvasSize = Size(200,200);
      zoomController.widgetScreenSize = Size(300,100);
      zoomController.repLayout();
      zoomController.scaleAbout(mousePosition:  Point<num>(100,100),delta: -224);

      zoomController.addListener(()=> changeNotifications++);

      expect(testAnimationController.clearListenersCalled, false);
      zoomController.scaleToFit();
      await Future.delayed(const Duration(milliseconds: 100,));
      expect(testAnimationController.clearListenersCalled, true);

    });

    test('Requesting the image position the widget center coordinate '
        '--> Converts the screen position into the image position .', ()async{
      final testAnimationController = TestAnimationController();
      final zoomController = ZoomController(animationController: testAnimationController);
      zoomController.canvasSize = Size(200,200);
      zoomController.widgetScreenSize = Size(300,100);
      zoomController.repLayout();

      const centerOfWidget =  Offset(150,50);
      var imgPos = zoomController.asImagePosition(centerOfWidget);

      expect(imgPos.x, 100);
      expect(imgPos.y, 100);
    });

    test('Requesting the image position of the screen pos representing the image origin '
        '--> Get the image origin pos (0,0).', ()async{
      final testAnimationController = TestAnimationController();
      final zoomController = ZoomController(animationController: testAnimationController);
      zoomController.canvasSize = Size(200,200);
      zoomController.widgetScreenSize = Size(300,100);
      zoomController.repLayout();

      const imgTopLeftWithinScreen = Offset(101,1);
      var imgPos = zoomController.asImagePosition(imgTopLeftWithinScreen);

      expect(imgPos.x, 0);
      expect(imgPos.y, 0);
    });

    test('Performing a box zoom into a landscape selection '
        '--> Image fills whole canvas so (1,1) returns a valid image position and the zoom is abput 1.47',()async{
      final testAnimationController = TestAnimationController();
      final zoomController = ZoomController(animationController: testAnimationController);
      zoomController.canvasSize = Size(200,200);
      zoomController.widgetScreenSize = Size(300,100);
      zoomController.repLayout();

      zoomController.boxZoomTo(Rectangle(101,100-(100/6),100 , 33 ));
      testAnimationController.moveAnimationTo(1);
      const imgTopLeftWithinScreen = Offset(1,1);
      var imgPos = zoomController.asImagePosition(imgTopLeftWithinScreen);
      expect(imgPos.x, 0);
      expect(imgPos.y, 167);
      expect(zoomController.zoomFactor, closeTo(1.47, 0.01));
    });

    test('Performing a box zoom into a portrait selection '
        '--> Image image is zoomed ad given by the set values',()async{
      final testAnimationController = TestAnimationController();
      final zoomController = ZoomController(animationController: testAnimationController);
      zoomController.canvasSize = Size(200,200);
      zoomController.widgetScreenSize = Size(300,100);
      zoomController.repLayout();

      zoomController.boxZoomTo(Rectangle(101,100,  20, 33 ));
      testAnimationController.moveAnimationTo(1);
      const imgTopLeftWithinScreen = Offset(121,1);
      var imgPos = zoomController.asImagePosition(imgTopLeftWithinScreen);
      expect(imgPos.x, 0);
      expect(imgPos.y, 202);
      expect(zoomController.zoomFactor, closeTo(1.49, 0.01));
    });

    test('Performing a box zoom '
        '--> Expecting an onZoom notification on each zoom step',()async{
      final testAnimationController = TestAnimationController();
      num lastZoom = double.nan;
      final zoomController = ZoomController(animationController: testAnimationController,)..
      zoomHandler = (zoom) => lastZoom = zoom;
      zoomController.canvasSize = Size(200,200);
      zoomController.widgetScreenSize = Size(300,100);
      zoomController.repLayout();

      zoomController.boxZoomTo(Rectangle(101,100-(100/6),100 , 33 ));
      testAnimationController.moveAnimationTo(0.1);
      expect(lastZoom, closeTo(0.5880588235294117, 0.00001));
      testAnimationController.moveAnimationTo(0.3);
      expect(lastZoom, closeTo(0.7841764705882353, 0.00001));
      testAnimationController.moveAnimationTo(0.6);
      expect(lastZoom, closeTo(1.0783529411764707, 0.00001));
      testAnimationController.moveAnimationTo(1);
      expect(zoomController.zoomFactor, closeTo(1.47, 0.01));
    });


}

