import 'support_classes.dart';

class CodeGenerator {
  List<PositionedBlock>? blocks = [];
  List<Connection>? connections = [];

  CodeGenerator(List<PositionedBlock>? blocks, List<Connection>? connections) {
    this.blocks = blocks;
    this.connections = connections;
  }

  String getCode() {
    return (connections == null) ? _defaultCode() : _generateCode();
  }

  String _connectionsDemo(Connection con) {
    return "Key " +
        con.start.toString() +
        " connected to Key" +
        con.end.toString() +
        " via condition: " +
        con.condition +
        "\n";
  }

  String _generateCode() {
    String result = "";
    if (connections!.length > 0) {
      for (Connection con in connections!.toList())
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
