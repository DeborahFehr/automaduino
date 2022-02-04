import 'package:arduino_statemachines/resources/state.dart';
import 'package:collection/collection.dart';
import 'canvas_layout.dart';
import 'transition.dart';
import 'pin_assignment.dart';
import 'arduino_functions.dart';
import 'states_data.dart';

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

  String getCode() {
    return (connections == null) ? _defaultCode() : _generateCode();
  }

  String _generateCode() {
    String result = "";
    result += _pinList(pins!);

    bool end = connections!.any((element) => element.endPoint);
    if (end) {
      result += "bool end = false;\n\n";
    }

    result += _generateSetup(pins!);

    Transition? start =
        connections!.firstWhereOrNull((element) => element.startPoint);
    if (start != null) {
      PositionedState startState =
          blocks!.firstWhere((element) => element.key == start.end.first);
      result += _generateLoop(startState, end);
    }

    if (blocks!.length > 0) {
      blocks!.asMap().forEach(
          (index, block) => result += _generateStateFunction(index, block));
    } else {
      result = _defaultCode();
    }
    return result;
  }

  String _pinList(List<PinAssignment> pins) {
    String initPins = "//Pins:\n";
    pins.forEach((element) {
      initPins += "int " +
          element.variableName! +
          " = " +
          element.pin.toString() +
          ";\n";
    });
    return initPins + "\n";
  }

  String _generateSetup(List<PinAssignment> pins) {
    String setup = "";
    pins.forEach((element) {
      String type = returnDataByName(element.component!).type == "output"
          ? "OUTPUT"
          : "INPUT";
      setup += "pinMode(" + element.variableName! + ", " + type + ");\n";
    });
    return "void setup() { \n" +
        setup
        //+ "Serial.begin(9600);\n"
        +
        "}\n\n";
  }

  String _generateLoop(PositionedState state, bool end) {
    String loop = state.settings.variableName + "();\n";

    if (end) {
      loop = "if(!end){\n" + loop + "}\n";
    }

    return "void loop() {\n" + loop + "}\n\n";
  }

  String _generateStateFunction(int index, PositionedState state) {
    // define variable of state
    // call state function

    // int vib_val;
    //   vib_val=digitalRead(vib_pin);

    String stateFunctions = "void " + state.settings.variableName + "(){\n";

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
      stateFunctions += arduinoFunction.function(pinVariable);
    } else {
      stateFunctions += arduinoFunction.function("value", pinVariable);
    }

    stateFunctions += "\n";

    Transition? connection =
        connections!.firstWhereOrNull((element) => element.start == state.key);

    if (connection != null) {
      stateFunctions += _generateTransition(connection) + "\n";
    }

    return stateFunctions + "}\n\n";
  }

  String _generateTransition(Transition connection) {
    //   if(vib_val==1){
    //     delay(300);
    //     verification();
    //   }

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
        transitionFunction += transitionIf(
            "value", nextFunction, connection.condition.values.first);
        break;
      case "cond":
        transitionFunction += transitionIf(
            "value", nextFunction, connection.condition.values.first);
        break;
      case "time":
        transitionFunction +=
            transitionTime(nextFunction, connection.condition.values.first);
        break;
    }

    return transitionFunction;
  }

  String _defaultCode() {
    return '''void setup() {
      // put your setup code here, to run once:

    }

    void loop() {
      // put your main code here, to run repeatedly:

    }''';
  }
}
