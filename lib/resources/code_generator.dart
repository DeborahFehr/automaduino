import 'canvas_layout.dart';
import 'transition.dart';
import 'arduino_functions.dart';

class CodeGenerator {
  List<PositionedState>? blocks = [];
  List<Transition>? connections = [];

  CodeGenerator(List<PositionedState>? blocks, List<Transition>? connections) {
    this.blocks = blocks;
    this.connections = connections;
  }

  String getCode() {
    return (connections == null) ? _defaultCode() : _generateCode();
  }

  String _connectionsDemo(Transition con) {
    return "State " +
        blocks!
            .firstWhere((element) => element.key == con.start)
            .settings
            .name +
        " connected to State " +
        blocks!
            .firstWhere((element) => element.key == con.end[0])
            .settings
            .name +
        " by condition type " +
        con.condition.type.toString() +
        " with value " +
        con.condition.values[0].toString() +
        "\n";
  }

  String _generateCode() {
    String result = "";
    if (connections!.length > 0) {
      for (Transition con in connections!.toList())
        result = result + _connectionsDemo(con);
    } else {
      result = _defaultCode();
    }
    return result;
  }

  String _pinList(List<String> content) {
    // Result:
    // int relais_pin=6;
    // int vib_pin=7;
    String setup = "";
    content.forEach((element) {
      setup += element + "\n";
    });
    return "void setup() { \n" + setup + "\n" + "}";
  }

  String _generateSetup(List<String> content) {
    // Result:
    // pinMode(relais_pin, OUTPUT);
    // pinMode(vib_pin,INPUT);
    String setup = "";
    content.forEach((element) {
      setup += element + "\n";
    });
    return "void setup() { \n" + setup + "\n" + "}";
  }

  String _generateLoop() {
    // call entry function
    // if end defined: add var
    return "void loop() {"
        "}";
  }

  String _generateStateFunction() {
    // define variable of state
    // call state function

    // int vib_val;
    //   vib_val=digitalRead(vib_pin);

    return "void loop() {"
        "}";
  }

  String _generateTransition() {
    //   if(vib_val==1){
    //     delay(300);
    //     verification();
    //   }
    return "void loop() {"
        "}";
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
