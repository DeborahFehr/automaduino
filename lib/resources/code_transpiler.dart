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
    result += _generateSetup(pins!);

    Transition? start =
        connections!.firstWhereOrNull((element) => element.startPoint);
    if (start != null) {
      PositionedState startState =
          blocks!.firstWhere((element) => element.key == start.end.first);
      result += _generateLoop(startState);
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
    return "void setup() { \n" + setup + "}\n\n";
  }

  String _generateLoop(PositionedState state) {
    // call entry function
    // if end defined: add var
    String loop = state.settings.variableName + "();\n";

    return "void loop() {\n" + loop + "}\n\n";
  }

  String _generateStateFunction(int index, PositionedState state) {
    // define variable of state
    // call state function

    // int vib_val;
    //   vib_val=digitalRead(vib_pin);

    String stateFunctions = state.settings.variableName + "(){\n";

    return stateFunctions + "}\n\n";
  }

  String _generateTransition(PositionedState state) {
    //   if(vib_val==1){
    //     delay(300);
    //     verification();
    //   }
    // depending on transition type
    return "next();\n";
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
