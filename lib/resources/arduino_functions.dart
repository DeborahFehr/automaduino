/// State Functions describe functions called in states

class StateFunction {
  String name;
  String option;
  Function action;
  Function pinSetup;
  String? imports;

  StateFunction(
      this.name, this.option, this.action, this.pinSetup, this.imports);
}

List<StateFunction> sensorFunctions = [
  StateFunction(
      "motionSensor", "readDigital", digitalRead, pinAssignment("INPUT"), null),
  StateFunction("temperatureSensor", "readCelsius", temperatureRead,
      pinAssignment("INPUT"), null),
  StateFunction(
      "humiditySensor", "readAnalog", analogRead, pinAssignment("INPUT"), null),
  StateFunction("vibrationSensor", "readDigital", digitalRead,
      pinAssignment("INPUT"), null),
  StateFunction(
      "loudnessSensor", "readAnalog", analogRead, pinAssignment("INPUT"), null),
  StateFunction(
      "ultrasonicRanger", "sendWave", sendWave, pinAssignment("INPUT"), null),
  StateFunction("ultrasonicRanger", "receiveWave", receiveWave,
      pinAssignment("INPUT"), null),
];

List<StateFunction> userInputFunctions = [
  StateFunction(
      "button", "awaitInput", digitalRead, pinAssignment("INPUT"), null),
  StateFunction(
      "switch", "awaitInput", digitalRead, pinAssignment("INPUT"), null),
  StateFunction(
      "tilt", "awaitInput", digitalRead, pinAssignment("INPUT"), null),
  StateFunction(
      "potentiometer", "awaitInput", analogRead, pinAssignment("INPUT"), null),
];

List<StateFunction> outputFunctions = [
  StateFunction("led", "on", outputOn, pinAssignment("OUTPUT"), null),
  StateFunction("led", "off", outputOff, pinAssignment("OUTPUT"), null),
  StateFunction("buzzer", "on", outputOn, pinAssignment("OUTPUT"), null),
  StateFunction("buzzer", "off", outputOff, pinAssignment("OUTPUT"), null),
  StateFunction(
      "vibrationMotor", "on", outputOn, pinAssignment("OUTPUT"), null),
  StateFunction(
      "vibrationMotor", "off", outputOff, pinAssignment("OUTPUT"), null),
  StateFunction("relay", "on", outputOn, pinAssignment("OUTPUT"), null),
  StateFunction("relay", "off", outputOff, pinAssignment("OUTPUT"), null),
  StateFunction(
      "servo", "0degree", servoDegree("0"), servoAttach, "#include <Servo.h>"),
  StateFunction("servo", "45degree", servoDegree("45"), servoAttach,
      "#include <Servo.h>"),
  StateFunction("servo", "90degree", servoDegree("90"), servoAttach,
      "#include <Servo.h>"),
  StateFunction("servo", "135degree", servoDegree("135"), servoAttach,
      "#include <Servo.h>"),
  StateFunction("servo", "180degree", servoDegree("180"), servoAttach,
      "#include <Servo.h>"),
];

/// Sensors
String analogRead(String varName, String pin) {
  return varName + " = analogRead(" + pin + ");";
}

String temperatureRead(String varName, String pin) {
  return varName + " = map(analogRead(" + pin + "), 0, 410, -50, 150);";
}

String sendWave(String varName, String pin) {
  return "digitalWrite(" +
      pin +
      ", LOW);\ndelay(5);\ndigitalWrite(" +
      pin +
      ", HIGH);\ndelay(10);\ndigitalWrite(" +
      pin +
      ", LOW);";
}

String receiveWave(String varName, String pin) {
  return varName + " = (pulseIn(" + pin + ", HIGH)/2) * 0.03432;";
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

Function servoDegree(String degree) {
  return (String servoName) {
    return servoName + ".write(" + degree + ");";
  };
}

/// Setup

Function pinAssignment(String type) {
  return (String pinVariable) {
    return "pinMode(" + pinVariable + ", " + type + ");";
  };
}

String servoAttach(String servoName, String pin) {
  return servoName + ".attach(" + pin + ");";
}

StateFunction returnFunctionByNameAndOption(String name, String option) {
  StateFunction result;
  List<StateFunction> searchList =
      sensorFunctions + userInputFunctions + outputFunctions;
  result =
      searchList.firstWhere((el) => el.name == name && el.option == option);

  return result;
}

StateFunction returnFunctionByName(String name) {
  StateFunction result;
  List<StateFunction> searchList =
      sensorFunctions + userInputFunctions + outputFunctions;
  result = searchList.firstWhere((el) => el.name == name);

  return result;
}
