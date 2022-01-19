import 'package:flutter/gestures.dart';
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

  void updateBlockPosition(Key key, Offset position) {
    _blocks.firstWhere((element) => element.key == key).position = position;
    notifyListeners();
  }

  /// Adds [connection] between two blocks.
  void addConnection(Connection connection) {
    _connections.add(connection);
    notifyListeners();
  }

  void updateConnectionType(Condition condition, conditionType type) {
    _connections
        .firstWhere((element) => element.condition.key == condition.key)
        .condition
        .type = type;
    notifyListeners();
  }

  void updateConnectionValues(Condition condition, List<String> values) {
    _connections
        .firstWhere((element) => element.condition.key == condition.key)
        .condition
        .values = values;
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
  final Color? color;
  final bool newBlock;
  final bool newConnection;
  final Key? key;

  BlockData(this.name, this.color, this.newBlock, this.newConnection, this.key);

  BlockData added() {
    return BlockData(this.name, this.color, false, false, this.key);
  }
}

// Positioned Block is displayed in the build area
class PositionedBlock {
  final Key key;
  final Widget block;
  final BlockData data;
  Offset position;

  PositionedBlock toLocalPosition(RenderBox renderbox) {
    return PositionedBlock(
        this.key, this.block, data, renderbox.globalToLocal(this.position));
  }

  PositionedBlock(this.key, this.block, this.data, this.position);
}

// Connection describes the relationship between a block and a condition
class Connection {
  final Key start;
  final Condition condition;
  List<Key> end;
  Offset position;

  Connection(this.start, this.condition, this.end, this.position);

  @override
  String toString() {
    return "start: " +
        start.toString() +
        ", connection: " +
        condition.toString() +
        ", end: " +
        end.toString();
  }
}

enum conditionType { iff, iffelse, cond, time, value }

// Condition describes the connection
class Condition {
  final Key key;
  conditionType type;
  List<String> values;

  Condition(this.key, this.type, this.values);

  @override
  String toString() {
    return "type: " + type.toString() + ", with values: " + values.toString();
  }
}

// Draggable Connection is used to draw a line while making a connection
class DraggableConnection {
  final Offset start;
  Offset end;

  DraggableConnection(this.start, this.end);
}