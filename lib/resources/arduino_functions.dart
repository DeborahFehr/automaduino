/// State Functions describe functions called in states

class StateFunction {
  String name;
  String option;
  Function function;

  StateFunction(this.name, this.option, this.function);
}

List<StateFunction> sensorFunctions = [
  StateFunction("motionSensor", "readDigital", digitalRead),
  StateFunction("temperatureSensor", "readDigital", () => print("todo")),
  StateFunction("humiditySensor", "readAnalog", analogRead),
  StateFunction("vibrationSensor", "readDigital", digitalRead),
  StateFunction("loudnessSensor", "readAnalog", analogRead),
  StateFunction("ultrasonicRanger", "readAnalog", () => print("todo")),
];

List<StateFunction> userInputFunctions = [
  StateFunction("button", "awaitInput", digitalRead),
  StateFunction("switch", "awaitInput", digitalRead),
  StateFunction("keypad", "awaitInput", () => print("todo")),
  StateFunction("tilt", "awaitInput", digitalRead),
  StateFunction("RFID", "awaitInput", () => print("todo")),
];

List<StateFunction> outputFunctions = [
  StateFunction("led", "on", outputOn),
  StateFunction("led", "off", outputOff),
  StateFunction("buzzer", "on", outputOn),
  StateFunction("buzzer", "off", outputOff),
  StateFunction("vibrationMotor", "on", outputOn),
  StateFunction("vibrationMotor", "off", outputOff),
  StateFunction("relay", "on", outputOn),
  StateFunction("relay", "off", outputOff),
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

StateFunction returnFunctionByNameAndOption(String name, String option) {
  StateFunction result;
  List<StateFunction> searchList =
      sensorFunctions + userInputFunctions + outputFunctions;
  result =
      searchList.firstWhere((el) => el.name == name && el.option == option);

  return result;
}
