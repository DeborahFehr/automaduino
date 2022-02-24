import 'package:arduino_statemachines/resources/state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'transition.dart';
import 'canvas_layout.dart';
import 'pin_assignment.dart';
import 'settings.dart';

/// describes the state of the application
/// implements Provider
class AutomaduinoState extends ChangeNotifier {
  final List<PositionedState> _blocks = [];
  final List<Transition> _connections = [];
  final List<PinAssignment> _pinAssignments = [];
  final StartData _startPoint = StartData(false, UniqueKey(), startPosition);
  final EndData _endPoint = EndData(false, UniqueKey(), endPosition);
  Map<String, String?>? _highlight;

  List<Transition> get connections => _connections;

  List<PositionedState> get blocks => _blocks;

  List<PinAssignment> get pinAssignments => _pinAssignments;

  StartData get startPoint => _startPoint;

  EndData get endPoint => _endPoint;

  Map<String, String?>? get highlight => _highlight;

  /// Add a state to the block list
  void addBlock(PositionedState block) {
    _blocks.add(block);
    notifyListeners();
  }

  /// Delete a state from the block list and remove its connections
  void deleteBlock(PositionedState block) {
    List<Transition> availableConnections = _connections
        .where((element) => element.end.contains(block.key))
        .toList();
    availableConnections
        .where((element) =>
            element.condition.type != "ifelse" &&
            element.condition.type != "cond")
        .forEach((connection) {
      PositionedState? reset = _blocks
          .firstWhereOrNull((element) => element.key == connection.start);
      // if no block was found it was connected to the startPoint
      reset != null
          ? reset.outgoingConnection = false
          : startPoint.connected = false;
    });
    _connections.removeWhere((element) =>
        element.start == block.key || element.end.contains(block.key));
    _blocks.removeWhere((element) => element == block);
    _blocks.forEach((element) {
      element.settings.variableName = ("function_" +
              blocks.indexOf(element).toString() +
              "_" +
              element.settings.name)
          .replaceAll(RegExp(' |ü|ä|ö|ß'), "_");
    });
    notifyListeners();
  }

  /// Add a connection between two blocks
  void addConnection(Transition connection) {
    _connections.add(connection);
    if (!connection.startPoint) {
      _blocks
          .firstWhere((element) => element.key == connection.start)
          .outgoingConnection = true;
    }
    notifyListeners();
  }

  /// Add another connection (if type is ifelse or cond)
  void addAdditionalConnection(Key start, Key end) {
    if (!connections
        .firstWhere((element) => element.start == start)
        .end
        .contains(end)) {
      _connections.firstWhere((element) => element.start == start).end.add(end);
      notifyListeners();
    }
  }

  /// delete a connection between two blocks
  void deleteConnection(Transition connection) {
    if (!connection.startPoint) {
      _blocks
          .firstWhere((element) => element.key == connection.start)
          .outgoingConnection = false;
    }
    _connections.removeWhere((element) => element == connection);
    notifyListeners();
  }

  /// update the connection type
  void updateConnectionType(Condition condition, String type) {
    Transition connection = _connections
        .firstWhere((element) => element.condition.key == condition.key);
    // if type was a multi connection: keep only first connection
    if (connection.condition.type == "cond" ||
        connection.condition.type == "ifelse") {
      connection.end = [connection.end.first];
      connection.condition.values = [connection.condition.values.first];
    }
    connection.condition.type = type;
    notifyListeners();
  }

  /// updates the connection values
  void updateConnectionValues(Condition condition, List<String> values) {
    _connections
        .firstWhere((element) => element.condition.key == condition.key)
        .condition
        .values = values;
    notifyListeners();
  }

  /// delete a connection in a cond transition
  void deleteCondValue(Transition transition, int position) {
    Transition connection =
        _connections.firstWhere((element) => element.start == transition.start);
    connection.end.removeAt(position);
    connection.condition.values.removeAt(position);
    notifyListeners();
  }

  /// return variable name for a specific block
  String getBlockVariableNameFromKey(Key key) {
    return _blocks
        .firstWhere((element) => element.key == key)
        .settings
        .variableName;
  }

  /// update the name of the state and change its variableName
  void updateStateName(Key key, String name) {
    PositionedState state = _blocks.firstWhere((element) => element.key == key);
    state.settings.name = name;
    state.settings.variableName =
        ("function_" + blocks.indexOf(state).toString() + "_" + name)
            .replaceAll(RegExp(' |ü|ä|ö|ß'), "_");
    notifyListeners();
  }

  /// replace pin list with new list
  void addPinList(List<PinAssignment> pins) {
    _pinAssignments.clear();
    pins.forEach((element) {
      _pinAssignments.add(element);
    });
    notifyListeners();
  }

  /// update a single pin value in a block
  void updatePin(Key key, int? pin) {
    PositionedState state = _blocks.firstWhere((element) => element.key == key);
    state.settings.pin = pin;
    notifyListeners();
  }

  /// returns if a block needs a pin assignment
  bool unassignedPinsInBlocks() {
    return _blocks.any((element) => element.settings.pin == null);
  }

  /// returns the name of a pin variable by its pin and component
  String getVariableNameByPinAndComponent(int pin, String component) {
    return _pinAssignments
        .firstWhere(
            (element) => element.pin == pin && element.component == component)
        .variableName!;
  }

  /// disables the endPoint
  void hideEndPoint() {
    endPoint.available = false;
    _connections.removeWhere((element) => element.end.contains(endPoint.key));
    notifyListeners();
  }

  /// shows the endPoint
  void showEndPoint() {
    _endPoint.position = endPosition;
    endPoint.available = true;
    notifyListeners();
  }

  /// disables the endPoint
  void connectStartPoint() {
    _startPoint.connected = true;
    notifyListeners();
  }

  /// sets the information for the highlight map
  void setHighlightMap(String mapName, String variableName, {String? type}) {
    _highlight = {
      "mapName": mapName,
      "variableName": variableName,
      "type": type
    };
    notifyListeners();
  }

  /// returns the state in map form for the data export
  Map<String, dynamic> stateToMap() {
    Map<String, dynamic> result = {};

    List<Map> blockList = [];
    _blocks.forEach((element) {
      blockList.add(element.toJson());
    });
    List<Map> connectionsList = [];
    _connections.forEach((element) {
      connectionsList.add(element.toJson());
    });
    List<Map> pinList = [];
    _pinAssignments.forEach((element) {
      pinList.add(element.toJson());
    });
    result["_blocks"] = blockList;
    result["_connections"] = connectionsList;
    result["_pinAssignments"] = pinList;
    result["_startPoint"] = _startPoint.toJson();
    result["_endPoint"] = _endPoint.toJson();

    return result;
  }

  /// translates a json map to a state object
  void mapToState(Map<String, dynamic> map) {
    List<dynamic> blockList = map["_blocks"];
    _blocks.clear();
    blockList.forEach((element) {
      _blocks.add(PositionedState.fromJson(element));
    });

    List<dynamic> connectionsList = map["_connections"];
    _connections.clear();
    connectionsList.forEach((element) {
      _connections.add(Transition.fromJson(element));
    });

    List<dynamic> pinList = map["_pinAssignments"];
    _pinAssignments.clear();
    pinList.forEach((element) {
      _pinAssignments.add(PinAssignment.fromJson(element));
    });

    Map startJson = map["_startPoint"];
    _startPoint.connected = startJson['connected'];
    Offset startPosition = Offset(
        startJson['position_dx'] as double, startJson['position_dy'] as double);
    _startPoint.position = startPosition;

    Map endJson = map["_endPoint"];
    _endPoint.available = endJson['available'];
    Offset endPosition = Offset(
        endJson['position_dx'] as double, endJson['position_dy'] as double);
    _endPoint.position = endPosition;

    notifyListeners();
  }

  /// Resets the state object
  void reset() {
    _blocks.clear();
    _connections.clear();
    _pinAssignments.clear();
    _startPoint.connected = false;
    _startPoint.position = startPosition;
    _endPoint.available = false;
    _endPoint.position = endPosition;
    notifyListeners();
  }
}
