/// State Settings describes the data structure of the draggable state
class CodeMap {
  Map<String, String> import;
  Map<String, String> pins;
  Map<String, String> setup;
  Map<String, String> loop;
  Map<String, StateMap> states;

  CodeMap(this.import, this.pins, this.setup, this.loop, this.states);

  String setupWrapper() {
    String result = "void setup() { \n";
    setup.forEach((key, value) {
      result += value + "\n";
    });
    result += "}\n\n";
    return result;
  }

  String loopWrapper() {
    String result = "void loop() {\n";
    loop.forEach((key, value) {
      result += value + "\n";
    });
    result += "}\n\n";
    return result;
  }

  String getCode() {
    String result = "";
    result += "//Pins:\n";
    import.forEach((key, value) {
      result += value + "\n";
    });
    pins.forEach((key, value) {
      result += value + "\n";
    });
    result += setupWrapper() + "\n";
    result += loopWrapper() + "\n";
    states.forEach((key, value) {
      result += value.stateCode() + "\n";
    });
    return result;
  }

  String returnHighlightString(String? mapName, String? variableName,
      {String? type}) {
    String result = "";
    if (mapName == null || variableName == null) return result;
    switch (mapName) {
      case "import":
        result = this.import[variableName]!;
        break;
      case "pins":
        result = this.pins[variableName]!;
        break;
      case "setup":
        result = this.setup[variableName]!;
        break;
      case "loop":
        result = this.loop[variableName]!;
        break;
      case "states":
        switch (type!) {
          case "state":
            result = this.states[variableName]!.stateCode();
            break;
          case "action":
            result = this.states[variableName]!.action;
            break;
          case "transition":
            result = this.states[variableName]!.transition;
            break;
        }
        break;
    }

    return result;
  }
}

class StateMap {
  String functionName;
  String action;
  String transition;

  String stateCode() {
    String result = "void " + functionName + "(){\n";
    result += action + "\n";
    result += transition + "\n";
    result += "}\n\n";
    return result;
  }

  StateMap(this.functionName, this.action, this.transition);
}
