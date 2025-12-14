import 'package:flutter/material.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display_example/src/display_embedding.dart';
import 'package:solid_zoom_display_example/src/interactions/sample_mouse_interaction.dart';
import 'package:solid_zoom_display_example/src/point_cloud_view/sample_fiducial_map.dart';
import 'package:solid_zoom_display_example/src/interactions/sample_touch_interaction.dart';

class PointCloudDemo extends StatefulWidget {
  const PointCloudDemo({super.key});

  @override
  State<PointCloudDemo> createState() => PointCloudDemoState();
}

class PointCloudDemoState extends State<PointCloudDemo>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DisplayEmbedding(
      child: ZoomDisplay(
        projector: SampleFiducialMap(),
        vsync: this,
        backgroundPaint: Paint()
          ..color = const Color.fromARGB(0xff, 0x2B, 0x2D, 0x42),
        selectionProjector: MovingDashBoxProjector(vsync: this),
        mouseInteraction: SampleMouseInteraction(),
        touchInteraction: SampleTouchInteraction(),
      ),
    );
  }
}
