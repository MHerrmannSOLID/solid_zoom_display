// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:flutter/material.dart';

export 'src/zoom_display.dart';
export 'src/interaction/interaction_controller.dart';
export 'src/types/display_projector.dart';
export 'src/types/selection.dart';
export 'src/interaction/display_touch_interaction.dart';
export 'src/interaction/display_mouse_interaction.dart';
export 'src/interaction/selection_overlays/moving_dash_box_projector.dart';
export 'package:solid_zoom_display/src/types/event/mouse_event.dart';
export 'package:solid_zoom_display/src/types/event/touch_event.dart';

typedef ContextMenuBuilder = Widget Function(BuildContext context, Offset offset);

