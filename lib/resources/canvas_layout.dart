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

  Map toJson() => {
        'key': key.toString(),
        'settings': settings.toJson(),
        'data': data.toJson(),
        'position_dx': position.dx,
        'position_dy': position.dy,
        'outgoingConnection': outgoingConnection,
      };

  PositionedState.fromJson(Map<String, dynamic> json)
      : key = Key(json['key']),
        settings = StateSettings.fromJson(json['settings']),
        data = StateData.fromJson(json['data']),
        position = Offset(
            json['position_dx'] as double, json['position_dy'] as double),
        outgoingConnection = json['outgoingConnection'];
}

/// Draggable Connection is used to draw a line while making a transition
class DragData {
  final Key? key;
  final String name;
  final String selectedOption;
  final bool newBlock;
  final bool newConnection;
  final bool additionalConnection;
  final bool startConnection;

  DragData(this.key, this.name, this.selectedOption, this.newBlock,
      this.newConnection, this.additionalConnection, this.startConnection);
}

/// Draggable Connection is used to draw a line while making a transition
class DraggableConnection {
  final Offset start;
  Offset end;
  final bool point;
  final bool addition;

  DraggableConnection(this.start, this.end, this.point, this.addition);
}
