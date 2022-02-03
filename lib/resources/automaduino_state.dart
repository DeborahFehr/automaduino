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

  List<Transition> get connections => _connections;

  List<PositionedState> get blocks => _blocks;

  List<PinAssignment> get pinAssignments => _pinAssignments;

  StartData get startPoint => _startPoint;

  EndData get endPoint => _endPoint;

  /// Adds [block] to building area.
  void addBlock(PositionedState block) {
    _blocks.add(block);
    notifyListeners();
  }

  void updateBlockPosition(Key key, Offset position) {
    _blocks.firstWhere((element) => element.key == key).position = position;
    notifyListeners();
  }

  /// Adds [connection] between two blocks.
  void addConnection(Transition connection) {
    _connections.add(connection);
    notifyListeners();
  }

  void updateConnectionType(Condition condition, String type) {
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

  void updateStateName(Key key, String name, Widget block) {
    PositionedState state = _blocks.firstWhere((element) => element.key == key);
    state.settings.name = name;
    state.settings.variableName =
        (blocks.indexOf(state).toString() + "_" + name).replaceAll(" ", "_");
    state.block = block;

    notifyListeners();
  }

  void addPinList(List<PinAssignment> pins) {
    _pinAssignments = pins;
    notifyListeners();
  }

  void updatePin(Key key, int? pin, Widget block) {
    PositionedState state = _blocks.firstWhere((element) => element.key == key);
    state.settings.pin = pin;
    state.block = block;
    notifyListeners();
  }

  void updateStartPosition(Offset position) {
    _startPoint.position = position;
    notifyListeners();
  }

  void updateEndPosition(Offset position) {
    _endPoint.position = position;
    notifyListeners();
  }

  void startPointConnected() {
    _startPoint.connected = true;
    notifyListeners();
  }

  /// Removes all blocks and connections.
  void clear() {
    _blocks.clear();
    _connections.clear();
    notifyListeners();
  }
}
