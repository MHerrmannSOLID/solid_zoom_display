import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display_example/src/display_embedding.dart';
import 'package:solid_zoom_display_example/src/interactions/sample_mouse_interaction.dart';
import 'package:solid_zoom_display_example/src/interactions/sample_touch_interaction.dart';

class ImageDisplayDemo extends StatefulWidget {
  const ImageDisplayDemo({super.key});

  @override
  State<ImageDisplayDemo> createState() => _ImageDisplayDemoState();
}

class _ImageDisplayDemoState extends State<ImageDisplayDemo>
    with TickerProviderStateMixin {
  ui.Image? _image;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final response =
          await http.get(Uri.parse('https://picsum.photos/1200/700'));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        _image = frame.image;
        _isLoading = false;
        setState(() {});
      }
    } catch (e) {
      print('Error loading image: $e');
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DisplayEmbedding(
      child: ZoomDisplay(
        projector: _isLoading ? EmptyProjector() : SampleImagePainter(_image!),
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

class EmptyProjector extends DisplayProjector {
  @override
  void copyToContext(Canvas canvas) {
    // Do nothing
  }

  @override
  Size get size => const Size(1, 1);
}

class SampleImagePainter extends DisplayProjector {
  ui.Image image;

  SampleImagePainter(this.image);

  @override
  void copyToContext(Canvas canvas) {
    canvas.drawImage(image, Offset.zero, Paint());
    canvas.drawRect(
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.red
          ..strokeWidth = 10);
  }

  @override
  Size get size => Size(image.width.toDouble(), image.height.toDouble());
}
