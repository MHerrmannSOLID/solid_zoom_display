import 'package:flutter/material.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display_example/src/sample_fiducial_map.dart';
import 'package:solid_zoom_display_example/src/sample_touch_interaction.dart';
import 'src/sample_mouse_interaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SOLID zoom display example'),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Center(
            child: SizedBox(
              width: constraints.maxWidth * 0.75,
              height: constraints.maxHeight * 0.80,
              child: Column(
                children: [
                  Text('This is a zoom display example',
                      style: TextStyle(fontSize: constraints.maxHeight * 0.03)),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1)),
                    child: SizedBox(
                      width: constraints.maxWidth * 0.75,
                      height: constraints.maxHeight * 0.75,
                      child: ZoomDisplay(
                        projector: SampleFiducialMap(),
                        vsync: this,
                        backgroundPaint: Paint()
                          ..color =
                              const Color.fromARGB(0xff, 0x2B, 0x2D, 0x42),
                        selectionProjector: MovingDashBoxProjector(vsync: this),
                        mouseInteraction: SampleMouseInteraction(),
                        touchInteraction: SampleTouchInteraction(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
