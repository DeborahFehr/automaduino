/// State Functions describe functions called in states

class StateFunction {
  String name;
  String option;
  Function function;

  StateFunction(this.name, this.option, this.function);
}

List<StateFunction> sensorFunctions = [
  StateFunction("Motion Sensor", "Read Digital", digitalRead),
  // returns true or false
  StateFunction("Temperature Sensor", "Read Data", () => print("todo")),
  StateFunction("Humidity Sensor", "Read Analog", analogRead),
  StateFunction("Vibration Sensor", "Read Digital", digitalRead),
  StateFunction("Loudness Sensor", "Read Analog", analogRead),
  StateFunction("Ultrasonic Ranger", "Read Data", () => print("todo")),
];

List<StateFunction> userInputFunctions = [
  StateFunction("Button", "Await Input", digitalRead),
  StateFunction("Switch", "Await Input", digitalRead),
  StateFunction("Keypad", "Await Input", () => print("todo")),
  StateFunction("Tilt", "Await Input", digitalRead),
  StateFunction("RFID", "Await Input", () => print("todo")),
];

List<StateFunction> outputFunctions = [
  StateFunction("LED", "On", outputOn),
  StateFunction("LED", "Off", outputOff),
  StateFunction("Buzzer", "On", outputOn),
  StateFunction("Buzzer", "Off", outputOff),
  StateFunction("Vibration Motor", "On", outputOn),
  StateFunction("Vibration Motor", "Off", outputOff),
  StateFunction("Relay", "On", outputOn),
  StateFunction("Relay", "Off", outputOff),
];

/// Sensors
String analogRead(String varName, String pin) {
  return varName + " = analogRead(" + pin + ");";
}

/// User Input
String digitalRead(String varName, String pin) {
  return varName + " = digitalRead(" + pin + ");";
}

/// Output

String outputOn(String pin) {
  return "digitalWrite(" + pin + ", HIGH);";
}

String outputOff(String pin) {
  return "digitalWrite(" + pin + ", LOW);";
}

/// Transition Functions describe functions as defined for conditionTypes

// "then", "if", "ifelse", "cond", "time",
String transitionThen(String functionName) {
  return functionName + "();";
}

String transitionIf(String variable, String functionName, String value) {
  return "if(" + variable + " == " + value + "){\n" + functionName + "();\n}";
}

String transitionIfElse(String variable, String functionName,
    String elseFunctionName, String value) {
  return "if(" +
      variable +
      " == " +
      value +
      "){\n" +
      functionName +
      "();\n}\nelse{\n" +
      elseFunctionName +
      "();\n}";
}

String transitionCond(String functionName) {
  return functionName + "();";
}

String transitionTime(String functionName, String time) {
  return "delay(" + time + ");\n" + functionName + "();";
}

StateFunction returnFunctionByNameAndOption(String name, String option) {
  StateFunction result;
  List<StateFunction> searchList =
      sensorFunctions + userInputFunctions + outputFunctions;
  result =
      searchList.firstWhere((el) => el.name == name && el.option == option);

  return result;
}
