import 'package:flutter/material.dart';

// Buildarea Draggable describes the type of draggables that can appear
class BuildareaDraggable {
  final Widget block;
  final bool newBlock;
  final bool arrow;

  BuildareaDraggable(this.block, this.newBlock, this.arrow);
}

// Positioned Block is displayed in the build area
class PositionedBlock {
  final Key key;
  final Widget block;
  Offset position;

  PositionedBlock(this.key, this.block, this.position);
}

// Connection describes the relationship between two blocks in the buildarea
class Connection {
  final Key start;
  Key end;
  String condition;

  Connection(this.start, this.end, this.condition);

  @override
  String toString() {
    return "start: " +
        start.toString() +
        ", end: " +
        end.toString() +
        ", condition: " +
        condition;
  }
}
