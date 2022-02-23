import 'package:arduino_statemachines/resources/state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'canvas_layout.dart';
import 'transition.dart';
import 'pin_assignment.dart';
import 'arduino_functions.dart';
import 'code_map.dart';

class CodeTranspiler {
  List<PositionedState> blocks = [];
  List<Transition> connections = [];
  List<PinAssignment> pins = [];
  late StartData startPoint;
  late EndData endPoint;
  String mode = "functions";

  CodeTranspiler(
      List<PositionedState> blocks,
      List<Transition> connections,
      List<PinAssignment> pins,
      StartData startPoint,
      EndData endPoint,
      String mode) {
    this.blocks = blocks;
    this.connections = connections;
    this.pins = pins;
    this.startPoint = startPoint;
    this.endPoint = endPoint;
    this.mode = mode;
  }

  CodeMap map = CodeMap({}, {}, {}, {}, {});

  CodeMap? getMap() {
    if (blocks.length == 0) return null;
    _imports();
    _pinList();
    bool end = connections.any((element) => element.endPoint);
    _generateSetup(end);

    switch (mode) {
      case "functions":
        _generateCodeMapFunctions(end);
        break;
      case "abridged":
        _generateCodeMapAbridged(end);
        break;
      case "switch":
        _generateCodeMapSwitch(end);
        break;
    }
    return map;
  }

  void _imports() {
    List<String> components =
        blocks.map((e) => e.data.component).toSet().toList();
    components.forEach((element) {
      StateFunction functionData = returnFunctionByName(element);
      if (functionData.imports != null) {
        map.import[element] = functionData.imports!;
      }
    });
  }

  void _pinList() {
    pins.forEach((element) {
      if (element.variableName != null) {
        if (element.component == "servo") {
          map.pins[element.variableName!] =
              "Servo " + element.variableName! + ";";
        } else {
          map.pins[element.variableName!] = "int " +
              element.variableName! +
              " = " +
              element.pin.toString() +
              ";";
        }
      }
    });
  }

  void _generateSetup(bool end) {
    if (end) {
      map.setup["end"] = "bool end = false;\n";
    }
    pins.forEach((element) {
      if (element.variableName != null) {
        StateFunction function = returnFunctionByName(element.component!);
        map.setup[element.variableName!] = element.component! == "servo"
            ? function.pinSetup(element.variableName!, element.pin.toString())
            : function.pinSetup(element.variableName!);
      }
    });
  }

  /// FUNCTIONS TRANSPILER

  void _generateCodeMapFunctions(bool end) {
    Transition? start =
        connections.firstWhereOrNull((element) => element.startPoint);
    if (start != null) {
      PositionedState startState =
          blocks.firstWhere((element) => element.key == start.end.first);
      _generateLoopFunctions(startState, end);
    }

    if (blocks.length > 0) {
      blocks
          .asMap()
          .forEach((index, block) => _generateStateFunctions(index, block));
    }
  }

  void _generateLoopFunctions(PositionedState state, bool end) {
    String loop = state.settings.variableName + "();\n";
    map.loop["start"] = loop;

    if (end) {
      map.loop["end"] = "if(!end){\n" + loop + "}\n";
      map.loop["endActivated"] = "end = true;";
    }
  }

  void _generateStateFunctions(int index, PositionedState state) {
    if (map.states[state.settings.variableName] == null) {
      map.states[state.settings.variableName] = StateMap("", "", "");
    }
    map.states[state.settings.variableName]!.functionName =
        state.settings.variableName;

    StateFunction arduinoFunction = returnFunctionByNameAndOption(
        state.data.component, state.settings.selectedOption);

    String pinVariable = state.settings.pin == null
        ? ""
        : pins
            .firstWhere((element) =>
                element.pin == state.settings.pin &&
                element.component == state.data.component)
            .variableName!;

    if (state.data.type == "output") {
      map.states[state.settings.variableName]!.action =
          arduinoFunction.action(pinVariable);
    } else {
      map.states[state.settings.variableName]!.action =
          arduinoFunction.action("value", pinVariable);
    }

    Transition? connection =
        connections.firstWhereOrNull((element) => element.start == state.key);

    if (connection != null) {
      map.states[state.settings.variableName]!.transition =
          _generateTransitionFunctions(connection);
    } else {
      map.states[state.settings.variableName]!.transition =
          state.settings.variableName + "();";
    }
  }

  String _generateTransitionFunctions(Transition connection) {
    String transitionFunction = "";

    String nextFunction = "";

    if (connection.endPoint) {
      transitionFunction += "end = true;\n";
      nextFunction = "loop";
    } else {
      PositionedState endState =
          blocks.firstWhere((element) => element.key == connection.end.first);
      nextFunction = endState.settings.variableName;
    }

    switch (connection.condition.type) {
      case "then":
        transitionFunction += nextFunction + "();";
        break;
      case "if":
        transitionFunction += transitionIf(
            "value", nextFunction + "();", connection.condition.values.first);
        break;
      case "ifelse":
        String elseFunction = "";
        if (connection.end.length > 1) {
          elseFunction = blocks
                  .firstWhere((element) => element.key == connection.end[1])
                  .settings
                  .variableName +
              "();";
        }
        transitionFunction += transitionIfElse("value", nextFunction + "();",
            elseFunction, connection.condition.values.first);
        break;
      case "cond":
        List<String> functionNames = [];
        List<String> conditionValues = [];
        for (int i = 0; i < connection.end.length; i++) {
          StateSettings settings = blocks
              .firstWhere((element) => element.key == connection.end[i])
              .settings;
          functionNames.add(settings.variableName + "();");
          conditionValues.add(connection.condition.values[i]);
        }
        transitionFunction += transitionCond(functionNames, conditionValues);
        break;
      case "time":
        transitionFunction += transitionTime(
            nextFunction + "();", connection.condition.values.first);
        break;
    }

    return transitionFunction;
  }

  /// ABRIDGED TRANSPILER

  void _generateCodeMapAbridged(bool end) {
    Transition? start =
        connections.firstWhereOrNull((element) => element.startPoint);
    if (start != null) {
      PositionedState startState =
          blocks.firstWhere((element) => element.key == start.end.first);
      _generateLoopAbridged(startState, end);
    }
  }

  void _generateLoopAbridged(PositionedState state, bool end) {
    String loop = _generateStateAbridged(state, null);
    map.loop["start"] = loop;

    if (end) {
      map.loop["end"] = "if(!end){\n" + loop + "}\n";
      map.loop["endActivated"] = "end = true;";
    }
  }

  String _generateStateAbridged(PositionedState state, PositionedState? loop) {
    String result = "";
    if (map.states[state.settings.variableName] == null) {
      map.states[state.settings.variableName] = StateMap("", "", "");
    }
    map.states[state.settings.variableName]!.functionName =
        state.settings.variableName;

    StateFunction arduinoFunction = returnFunctionByNameAndOption(
        state.data.component, state.settings.selectedOption);

    String pinVariable = state.settings.pin == null
        ? ""
        : pins
            .firstWhere((element) =>
                element.pin == state.settings.pin &&
                element.component == state.data.component)
            .variableName!;

    String action = "";
    if (state.data.type == "output") {
      action = arduinoFunction.action(pinVariable);
    } else {
      action = arduinoFunction.action("value", pinVariable);
    }

    map.states[state.settings.variableName]!.action = action;

    Transition? connection =
        connections.firstWhereOrNull((element) => element.start == state.key);

    if (connection != null) {
      String nextAction = "";
      if (loop == null) {
        if (_findLoop(state, [], connection)) {
          result += "while(true){\n";
          nextAction = _generateTransitionAbridged(connection, state);
        } else {
          nextAction = _generateTransitionAbridged(connection, null);
        }
      } else {
        nextAction = _generateTransitionAbridged(connection, loop);
      }
      result += action + "\n";
      map.states[state.settings.variableName]!.transition = nextAction;
      result += nextAction;
    } else {
      action = "while(true){\n" + action + "\n}\n";
      result += action;
      map.states[state.settings.variableName]!.action = action;
    }
    return result;
  }

  bool _findLoop(
      PositionedState start, List<Key> visited, Transition? connection) {
    if (connection == null) {
      return false;
    } else {
      bool result = false;
      connection.end.forEach((endKey) {
        PositionedState follower =
            blocks.firstWhere((element) => element.key == endKey);
        if (visited.contains(follower.key))
          result = false;
        else {
          if (follower.key == start.key) {
            result = true;
          } else {
            visited.add(follower.key);
            result = _findLoop(
                start,
                visited,
                connections
                    .firstWhereOrNull((con) => con.start == follower.key));
          }
        }
      });
      return result;
    }
  }

  String _generateTransitionAbridged(
      Transition connection, PositionedState? loop) {
    String transitionFunction = "";

    PositionedState? nextState;

    if (connection.endPoint) {
      transitionFunction += "end = true;";
    } else {
      PositionedState endState =
          blocks.firstWhere((element) => element.key == connection.end.first);
      nextState = endState;
    }

    if (loop != null && loop.key == nextState!.key) {
      return "}\n";
    }

    if (nextState != null) {
      String nestedCode = _generateStateAbridged(nextState, loop);
      switch (connection.condition.type) {
        case "then":
          transitionFunction += nestedCode;
          break;
        case "if":
          transitionFunction += transitionIf(
              "value", nestedCode, connection.condition.values.first);
          break;
        case "ifelse":
          PositionedState? elseState;
          if (connection.end.length > 1) {
            elseState = blocks
                .firstWhere((element) => element.key == connection.end[1]);
          }
          transitionFunction += transitionIfElse(
              "value",
              nestedCode,
              elseState != null ? _generateStateAbridged(elseState, loop) : "",
              connection.condition.values.first);
          break;
        case "cond":
          List<String> nestedCond = [];
          List<String> conditionValues = [];
          for (int i = 0; i < connection.end.length; i++) {
            PositionedState condState = blocks
                .firstWhere((element) => element.key == connection.end[i]);
            nestedCond.add(_generateStateAbridged(condState, loop));
            conditionValues.add(connection.condition.values[i]);
          }
          transitionFunction += transitionCond(nestedCond, conditionValues);
          break;
        case "time":
          transitionFunction +=
              transitionTime(nestedCode, connection.condition.values.first);
          break;
      }
    }

    return transitionFunction;
  }

  /// SWITCH TRANSPILER

  void _generateCodeMapSwitch(bool end) {
    Transition? start =
        connections.firstWhereOrNull((element) => element.startPoint);
    if (start != null) {
      int startState =
          blocks.indexWhere((element) => element.key == start.end.first);

      map.setup["switch"] = "int state = " + startState.toString() + ";\n";
      _generateLoopSwitch(end);
    }

    if (blocks.length > 0) {
      blocks
          .asMap()
          .forEach((index, block) => _generateStateSwitch(index, block));
    }
  }

  void _generateLoopSwitch(bool end) {
    String loop = "switch(state){\n";

    if (blocks.length > 0) {
      blocks.asMap().forEach((index, block) => loop += "case " +
          index.toString() +
          ":\n" +
          block.settings.variableName +
          "();\nbreak;\n");
    }

    loop += "default:\n break;\n}\n";

    map.loop["start"] = loop;

    if (end) {
      map.loop["end"] = "if(!end){\n" + loop + "}\n";
      map.loop["endActivated"] = "end = true;\n";
    }
  }

  void _generateStateSwitch(int index, PositionedState state) {
    if (map.states[state.settings.variableName] == null) {
      map.states[state.settings.variableName] = StateMap("", "", "");
    }
    map.states[state.settings.variableName]!.functionName =
        state.settings.variableName;

    StateFunction arduinoFunction = returnFunctionByNameAndOption(
        state.data.component, state.settings.selectedOption);

    String pinVariable = state.settings.pin == null
        ? ""
        : pins
            .firstWhere((element) =>
                element.pin == state.settings.pin &&
                element.component == state.data.component)
            .variableName!;

    if (state.data.type == "output") {
      map.states[state.settings.variableName]!.action =
          arduinoFunction.action(pinVariable);
    } else {
      map.states[state.settings.variableName]!.action =
          arduinoFunction.action("value", pinVariable);
    }

    Transition? connection =
        connections.firstWhereOrNull((element) => element.start == state.key);

    if (connection != null) {
      map.states[state.settings.variableName]!.transition =
          _generateTransitionSwitch(connection);
    }
  }

  String _generateTransitionSwitch(Transition connection) {
    String transitionFunction = "";

    String nextFunction = "";

    int stateId = 0;

    if (connection.endPoint) {
      transitionFunction += "end = true;";
    } else {
      stateId =
          blocks.indexWhere((element) => element.key == connection.end.first);
      nextFunction = "state = " + stateId.toString() + ";";
    }

    switch (connection.condition.type) {
      case "then":
        transitionFunction += nextFunction;
        break;
      case "if":
        transitionFunction += transitionIf(
            "value", nextFunction, connection.condition.values.first);
        break;
      case "ifelse":
        String elseFunction = "state = ";
        if (connection.end.length > 1) {
          elseFunction += blocks
                  .indexWhere((element) => element.key == connection.end[1])
                  .toString() +
              ";";
        }
        transitionFunction += transitionIfElse("value", nextFunction,
            elseFunction, connection.condition.values.first);
        break;
      case "cond":
        List<String> functionNames = [];
        List<String> conditionValues = [];
        for (int i = 0; i < connection.end.length; i++) {
          int id =
              blocks.indexWhere((element) => element.key == connection.end[i]);
          functionNames.add("state = " + id.toString() + ";");
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

/// Transition Functions describe functions as defined for conditionTypes
String transitionIf(String variable, String function, String value) {
  return "if(" + variable + " " + value + "){\n" + function + "\n}";
}

String transitionIfElse(
    String variable, String function, String elseFunction, String value) {
  String result =
      "if(" + variable + " " + value + "){\n" + function + "\n}\nelse{\n";
  if (elseFunction != "") {
    result += elseFunction + "\n";
  }

  result += "\n}";
  return result;
}

String transitionCond(List<String> functions, List<String> conditions) {
  String result = "";
  result += "switch (value) {";

  for (int i = 0; i < functions.length; i++) {
    result += "case " + conditions[i] + ":\n";
    result += functions[i] + "\n";
    result += "break;\n";
  }

  result += "default:\nbreak;\n}";
  return result;
}

String transitionTime(String function, String time) {
  return "delay(" + time + ");\n" + function;
}
