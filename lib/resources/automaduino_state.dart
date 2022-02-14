import 'package:arduino_statemachines/resources/state.dart';
import 'package:flutter/material.dart';
import 'transition.dart';
import 'canvas_layout.dart';
import 'pin_assignment.dart';

/// describes the state of the application
/// implements Provider
class AutomaduinoState extends ChangeNotifier {
  final List<PositionedState> _blocks = [];
  final List<Transition> _connections = [];
  List<PinAssignment> _pinAssignments = [];
  final StartData _startPoint = StartData(false, UniqueKey(), Offset(40, 40));
  final EndData _endPoint = EndData(true, UniqueKey(), Offset(140, 140));
  Map<String, String?>? _highlight;

  List<Transition> get connections => _connections;

  List<PositionedState> get blocks => _blocks;

  List<PinAssignment> get pinAssignments => _pinAssignments;

  StartData get startPoint => _startPoint;

  EndData get endPoint => _endPoint;

  Map<String, String?>? get highlight => _highlight;

  /// Adds [block] to building area.
  void addBlock(PositionedState block) {
    _blocks.add(block);
    notifyListeners();
  }

  void deleteBlock(PositionedState block) {
    List<Transition> availableConnections = _connections
        .where((element) => element.end.contains(block.key))
        .toList();
    availableConnections
        .where((element) =>
            element.condition.type != "ifelse" &&
            element.condition.type != "cond")
        .forEach((connection) {
      _blocks
          .firstWhere((element) => element.key == connection.start)
          .outgoingConnection = false;
    });
    _connections.removeWhere((element) =>
        element.start == block.key || element.end.contains(block.key));
    _blocks.removeWhere((element) => element == block);
    _blocks.forEach((element) {
      element.settings.variableName =
          (blocks.indexOf(element).toString() + "_" + element.settings.name)
              .replaceAll(" ", "_");
    });
    notifyListeners();
  }

  void updateBlockPosition(Key key, Offset position) {
    _blocks.firstWhere((element) => element.key == key).position = position;
    notifyListeners();
  }

  /// Adds [connection] between two blocks.
  void addConnection(Transition connection) {
    _connections.add(connection);
    if (!connection.startPoint) {
      _blocks
          .firstWhere((element) => element.key == connection.start)
          .outgoingConnection = true;
    }
    notifyListeners();
  }

  void addAdditionalConnection(Key start, Key end) {
    if (!_connections.any((element) => element.end.contains(end))) {
      _connections.firstWhere((element) => element.start == start).end.add(end);
      notifyListeners();
    }
  }

  void deleteConnection(Transition connection) {
    if (!connection.startPoint) {
      _blocks
          .firstWhere((element) => element.key == connection.start)
          .outgoingConnection = false;
    }
    _connections.removeWhere((element) => element == connection);
    notifyListeners();
  }

  void updateConnectionType(Condition condition, String type) {
    Transition connection = _connections
        .firstWhere((element) => element.condition.key == condition.key);

    if (connection.condition.type == "cond" ||
        connection.condition.type == "ifelse") {
      connection.end = [connection.end.first];
    }
    connection.condition.type = type;
    notifyListeners();
  }

  void updateConnectionValues(Condition condition, List<String> values) {
    _connections
        .firstWhere((element) => element.condition.key == condition.key)
        .condition
        .values = values;
    notifyListeners();
  }

  void deleteCondValue(Transition transition, int position) {
    Transition connection =
        _connections.firstWhere((element) => element.start == transition.start);
    connection.end.removeAt(position);
    connection.condition.values.removeAt(position);
    notifyListeners();
  }

  void updateStateName(Key key, String name) {
    PositionedState state = _blocks.firstWhere((element) => element.key == key);
    state.settings.name = name;
    state.settings.variableName =
        (blocks.indexOf(state).toString() + "_" + name).replaceAll(" ", "_");

    notifyListeners();
  }

  void addPinList(List<PinAssignment> pins) {
    _pinAssignments = pins;
    notifyListeners();
  }

  void updatePin(Key key, int? pin) {
    PositionedState state = _blocks.firstWhere((element) => element.key == key);
    state.settings.pin = pin;
    notifyListeners();
  }

  bool unassignedPin() {
    return _blocks.any((element) => element.settings.pin == null);
  }

  void updateStartPosition(Offset position) {
    _startPoint.position = position;
    notifyListeners();
  }

  void updateEndPosition(Offset position) {
    _endPoint.position = position;
    notifyListeners();
  }

  void hideEndPoint() {
    endPoint.available = false;
    _connections.removeWhere((element) => element.end.contains(endPoint.key));
    notifyListeners();
  }

  void showEndPoint() {
    _endPoint.position = Offset(140, 140);
    endPoint.available = true;
    notifyListeners();
  }

  void startPointConnected() {
    _startPoint.connected = true;
    notifyListeners();
  }

  void setHighlight(String mapName, String variableName, {String? type}) {
    _highlight = {
      "mapName": mapName,
      "variableName": variableName,
      "type": type
    };
    notifyListeners();
  }

  /// Removes all blocks and connections.
  void reset() {
    _blocks.clear();
    _connections.clear();
    _pinAssignments.clear();
    _startPoint.connected = false;
    _startPoint.position = Offset(40, 40);
    _endPoint.available = true;
    _endPoint.position = Offset(140, 140);
    notifyListeners();
  }
}
