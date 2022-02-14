import 'package:arduino_statemachines/resources/state.dart';
import 'package:collection/collection.dart';
import 'canvas_layout.dart';
import 'transition.dart';
import 'pin_assignment.dart';
import 'arduino_functions.dart';
import 'states_data.dart';
import 'code_map.dart';

class CodeTranspiler {
  List<PositionedState>? blocks = [];
  List<Transition>? connections = [];
  List<PinAssignment>? pins = [];
  StartData? startPoint;
  EndData? endPoint;

  CodeTranspiler(List<PositionedState>? blocks, List<Transition>? connections,
      List<PinAssignment>? pins, StartData? startPoint, EndData? endPoint) {
    this.blocks = blocks;
    this.connections = connections;
    this.pins = pins;
    this.startPoint = startPoint;
    this.endPoint = endPoint;
  }

  CodeMap map = CodeMap({}, {}, {}, {}, {});

  CodeMap? getMap() {
    if (connections == null) return null;
    _generateCodeMap();
    return map;
  }

  void _generateCodeMap() {
    _pinList();
    bool end = connections!.any((element) => element.endPoint);
    _generateSetup(end);

    Transition? start =
        connections!.firstWhereOrNull((element) => element.startPoint);
    if (start != null) {
      PositionedState startState =
          blocks!.firstWhere((element) => element.key == start.end.first);
      _generateLoop(startState, end);
    }

    if (blocks!.length > 0) {
      blocks!
          .asMap()
          .forEach((index, block) => _generateStateFunction(index, block));
    }
  }

  void _pinList() {
    pins!.forEach((element) {
      if (element.variableName != null) {
        map.pins[element.variableName!] = "int " +
            element.variableName! +
            " = " +
            element.pin.toString() +
            ";\n";
      }
    });
  }

  void _generateSetup(bool end) {
    if (end) {
      map.setup["end"] = "bool end = false;\n\n";
    }
    pins!.forEach((element) {
      if (element.variableName != null) {
        String type = returnDataByName(element.component!).type == "output"
            ? "OUTPUT"
            : "INPUT";
        map.setup[element.variableName!] =
            "pinMode(" + element.variableName! + ", " + type + ");\n";
      }
    });
  }

  void _generateLoop(PositionedState state, bool end) {
    String loop = state.settings.variableName + "();\n";
    map.loop["start"] = loop;

    if (end) {
      map.loop["end"] = "if(!end){\n" + loop + "}\n";
    }
  }

  void _generateStateFunction(int index, PositionedState state) {
    if (map.states[state.settings.variableName] == null) {
      map.states[state.settings.variableName] = StateMap("", "", "");
    }
    map.states[state.settings.variableName]!.functionName =
        state.settings.variableName;

    StateFunction arduinoFunction = returnFunctionByNameAndOption(
        state.data.component, state.settings.selectedOption);

    String pinVariable = state.settings.pin == null
        ? ""
        : pins!
            .firstWhere((element) =>
                element.pin == state.settings.pin &&
                element.component == state.data.component)
            .variableName!;

    if (state.data.type == "output") {
      map.states[state.settings.variableName]!.action =
          arduinoFunction.function(pinVariable);
    } else {
      map.states[state.settings.variableName]!.action =
          arduinoFunction.function("value", pinVariable);
    }

    Transition? connection =
        connections!.firstWhereOrNull((element) => element.start == state.key);

    if (connection != null) {
      map.states[state.settings.variableName]!.transition =
          _generateTransition(connection) + "\n";
    }
  }

  String _generateTransition(Transition connection) {
    String transitionFunction = "";

    String nextFunction = "";

    if (connection.endPoint) {
      transitionFunction += "end = true;\n";
      nextFunction = "loop";
    } else {
      PositionedState endState =
          blocks!.firstWhere((element) => element.key == connection.end.first);
      nextFunction = endState.settings.variableName;
    }

    switch (connection.condition.type) {
      case "then":
        transitionFunction += transitionThen(nextFunction);
        break;
      case "if":
        transitionFunction += transitionIf(
            "value", nextFunction, connection.condition.values.first);
        break;
      case "ifelse":
        String elseFunction = "";
        if (connection.end.length > 1) {
          elseFunction = blocks!
              .firstWhere((element) => element.key == connection.end[1])
              .settings
              .variableName;
        }
        transitionFunction += transitionIfElse("value", nextFunction,
            elseFunction, connection.condition.values.first);
        break;
      case "cond":
        List<String> functionNames = [];
        List<String> conditionValues = [];
        for (int i = 0; i < connection.end.length; i++) {
          StateSettings settings = blocks!
              .firstWhere((element) => element.key == connection.end[i])
              .settings;
          functionNames.add(settings.variableName);
          conditionValues.add(connection.condition.values[i]);
        }
        transitionFunction += transitionCond(functionNames, conditionValues);
        break;
      case "time":
        transitionFunction +=
            transitionTime(nextFunction, connection.condition.values.first);
        break;
    }

    return transitionFunction;
  }
}
