import 'package:flutter/material.dart';
import 'transition.dart';
import 'canvas_layout.dart';
import 'pin_assignment.dart';

/// describes the state of the application
/// implements Provider
class AutomaduinoState extends ChangeNotifier {
  final List<PositionedState> _blocks = [];
  final List<Transition> _connections = [];
  final List<PinAssignment> _pinAssignments = [];

  List<Transition> get connections => _connections;

  List<PositionedState> get blocks => _blocks;

  List<PinAssignment> get pinAssignments => _pinAssignments;

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
    state.block = block;

    notifyListeners();
  }

  void updateStateSelectedOption(Key key, String option, Widget block) {
    PositionedState state = _blocks.firstWhere((element) => element.key == key);
    state.settings.selectedOption = option;
    state.block = block;
    notifyListeners();
  }

  void addPin(PinAssignment pin) {
    _pinAssignments.add(pin);
    notifyListeners();
  }

  void removePin(PinAssignment pin) {
    _pinAssignments.removeWhere((el) => el.pin == pin.pin);
    notifyListeners();
  }

  /// Removes all blocks and connections.
  void clear() {
    _blocks.clear();
    _connections.clear();
    notifyListeners();
  }
}
