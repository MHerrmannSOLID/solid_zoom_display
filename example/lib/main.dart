import 'package:flutter/material.dart';
import 'package:solid_zoom_display_example/src/fiducial_map_example.dart';
import 'package:solid_zoom_display_example/src/models/sample_fiducial_map.dart';
import 'package:solid_zoom_display_example/src/interactions/sample_touch_interaction.dart';
import 'package:solid_zoom_display_example/src/multi_layer_example.dart';
import 'src/interactions/sample_mouse_interaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('SOLID zoom display example'),
      ),
      body: Column(
        children: <Widget>[
          TabBar.secondary(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(text: 'Overview'),
              Tab(text: 'Specifications'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                FiducualMapExample(),
                MyZoomDisplay(),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
