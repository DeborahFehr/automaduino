import 'package:flutter/material.dart';
import 'state.dart';

/// Positioned State is displayed in the canvas
class PositionedState {
  final Key key;
  final StateSettings settings;
  final StateData data;
  Offset position;
  bool outgoingConnection;

  PositionedState toLocalPosition(RenderBox renderbox) {
    return PositionedState(this.key, this.settings, this.data,
        renderbox.globalToLocal(this.position), this.outgoingConnection);
  }

  PositionedState(this.key, this.settings, this.data, this.position,
      this.outgoingConnection);
}

/// Draggable Connection is used to draw a line while making a transition
class DraggableConnection {
  final Offset start;
  Offset end;
  final bool point;
  final bool addition;

  DraggableConnection(this.start, this.end, this.point, this.addition);
}
