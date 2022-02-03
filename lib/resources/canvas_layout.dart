import 'package:flutter/material.dart';
import 'state.dart';

/// Positioned State is displayed in the canvas
class PositionedState {
  final Key key;
  Widget block;
  final StateSettings settings;
  final StateData data;
  Offset position;

  PositionedState toLocalPosition(RenderBox renderbox) {
    return PositionedState(this.key, this.block, this.settings, this.data,
        renderbox.globalToLocal(this.position));
  }

  PositionedState(
      this.key, this.block, this.settings, this.data, this.position);
}

/// Draggable Connection is used to draw a line while making a transition
class DraggableConnection {
  final Offset start;
  Offset end;
  final bool point;

  DraggableConnection(this.start, this.end, this.point);
}
