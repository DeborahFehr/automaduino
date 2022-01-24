import 'canvas_layout.dart';
import 'transition.dart';

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
    return "Key " +
        con.start.toString() +
        " connected to Key " +
        con.end.toString() +
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

  String _defaultCode() {
    return '''void setup() {
      // put your setup code here, to run once:

    }

    void loop() {
      // put your main code here, to run repeatedly:

    }''';
  }
}
