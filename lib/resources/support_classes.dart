import 'package:flutter/material.dart';

class StateModel extends ChangeNotifier {
  /// Internal, private state
  final List<PositionedBlock> _blocks = [];
  final List<Connection> _connections = [];

  List<Connection> get connections => _connections;

  List<PositionedBlock> get blocks => _blocks;

  /// Adds [block] to building area.
  void addBlock(PositionedBlock block) {
    _blocks.add(block);
    notifyListeners();
  }

  /// Adds [connection] between two blocks.
  void addConnection(Connection connection) {
    _connections.add(connection);
    notifyListeners();
  }

  /// Removes all blocks and connections.
  void clear() {
    _blocks.clear();
    _connections.clear();
    notifyListeners();
  }
}

// Buildarea Draggable describes the type of draggables that can appear
class BuildareaDraggable {
  final Widget block;
  final bool newBlock;
  final bool arrow;

  BuildareaDraggable(this.block, this.newBlock, this.arrow);
}

// Block Data describes the data structure of the draggable
class BlockData {
  final String name;
  final Color color;
  final bool newBlock;

  BlockData(this.name, this.color, this.newBlock);
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
