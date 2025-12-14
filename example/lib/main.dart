import 'package:flutter/material.dart';
import 'package:solid_zoom_display_example/src/image_view/image_display_demo.dart';
import 'package:solid_zoom_display_example/src/point_cloud_view/point_cloud_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('SOLID zoom display example'),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.cloud_outlined)),
                Tab(icon: Icon(Icons.beach_access_sharp)),
                Tab(icon: Icon(Icons.brightness_5_sharp)),
              ],
            ),
          ),
          body: const TabBarView(
            children: <Widget>[
              ImageDisplayDemo(),
              PointCloudDemo(),
              Center(child: Text("It's sunny here")),
            ],
          ),
        ),
      ),
    );
  }
}
