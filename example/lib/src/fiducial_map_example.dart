import 'package:flutter/material.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display_example/src/interactions/sample_mouse_interaction.dart';
import 'package:solid_zoom_display_example/src/interactions/sample_touch_interaction.dart';
import 'package:solid_zoom_display_example/src/models/sample_fiducial_map.dart';

class FiducualMapExample extends StatefulWidget {
  const FiducualMapExample({super.key});

  @override
  State<FiducualMapExample> createState() => _FiducualMapExampleState();
}

class _FiducualMapExampleState extends State<FiducualMapExample>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
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
                      ..color = const Color.fromARGB(0xff, 0x2B, 0x2D, 0x42),
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
    });
  }
}
