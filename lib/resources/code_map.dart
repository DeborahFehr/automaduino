/// State Settings describes the data structure of the draggable state
class CodeMap {
  Map<String, String> import;
  Map<String, String> pins;
  Map<String, String> setup;
  Map<String, String> loop;
  Map<String, StateMap> states;

  CodeMap(this.import, this.pins, this.setup, this.loop, this.states);

  String setupWrapper() {
    String result = setup.containsKey("switch") ? setup["switch"]! : "";
    result += "void setup() { \n";
    setup.forEach((key, value) {
      if (key != "end" && key != "switch") {
        result += value + "\n";
      }
    });
    result += "}\n";

    return result;
  }

  String loopWrapper(String content) {
    String result = "void loop() {\n" + content + "}\n\n";
    return result;
  }

  String getCode(String mode) {
    String result = "//Imports:\n";
    import.forEach((key, value) {
      result += value + "\n";
    });
    result += "\n";
    result += "//Pins:\n";
    pins.forEach((key, value) {
      result += value + "\n";
    });
    result += "\n";
    if (setup.containsKey("end")) {
      result += setup["end"] ?? "" + "";
    }
    result += setupWrapper() + "\n";
    switch (mode) {
      case "functions":
        result += _getFunctionsCode();
        break;
      case "abridged":
        result += _getAbridgedCode();
        break;
      case "switch":
        result += _getSwitchCode();
        break;
    }
    return result;
  }

  String _getFunctionsCode() {
    String result = "";
    String loopContent = "";
    if (loop.containsKey("end")) {
      loopContent += loop["end"] ?? "" + "\n";
    } else {
      loopContent += loop["start"] ?? "" + "\n";
    }
    result += loopWrapper(loopContent) + "\n";
    states.forEach((key, value) {
      result += value.stateFunctionCode() + "\n";
    });

    return result;
  }

  String _getAbridgedCode() {
    String result = "";
    String loopContent = "";
    if (loop.containsKey("end")) {
      loopContent += loop["end"] ?? "";
    } else {
      loopContent += loop["start"] ?? "";
    }
    result += loopWrapper(loopContent);

    return result;
  }

  String _getSwitchCode() {
    String result = "";
    String loopContent = "";
    if (loop.containsKey("end")) {
      loopContent += loop["end"] ?? "" + "\n";
    } else {
      loopContent += loop["start"] ?? "" + "\n";
    }
    result += loopWrapper(loopContent) + "\n";
    states.forEach((key, value) {
      result += value.stateFunctionCode() + "\n";
    });

    return result;
  }

  String returnHighlightString(
      String? mapName, String? variableName, String mode,
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
        result = this.loop[variableName] ?? "";
        break;
      case "states":
        if (this.states.containsKey(variableName)) {
          switch (type!) {
            case "state":
              result = mode == "abridged"
                  ? this.states[variableName]!.stateAbridgedCode()
                  : this.states[variableName]!.stateFunctionCode();
              break;
            case "action":
              result = this.states[variableName]!.action;
              break;
            case "transition":
              result = this.states[variableName]!.transition;
              break;
          }
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

  @override
  String toString() {
    return "functionName: " +
        functionName +
        ", action: " +
        action +
        ", transition: " +
        transition;
  }

  String stateFunctionCode() {
    String result = "void " + functionName + "(){\n";
    result += action + "\n";
    result += transition + "\n";
    result += "}\n";
    return result;
  }

  String stateAbridgedCode() {
    String result = action + "\n";
    result += transition;
    return result;
  }

  StateMap(this.functionName, this.action, this.transition);
}
