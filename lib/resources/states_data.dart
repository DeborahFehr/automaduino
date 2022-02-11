import 'state.dart';

List<StateData> sensorBlocks = [
  StateData("sensor", "motionSensor", "graphics/state_icons/motion-sensor.png",
      "/docs/overview/", "readDigital"),
  //StateData("sensor", "Temperature Sensor", "graphics/state_icons/temperature-sensor.png",
  //    "/docs/overview/", "Read Data"),
  StateData(
      "sensor",
      "humiditySensor",
      "graphics/state_icons/humidity-sensor.png",
      "/docs/overview/",
      "readAnalog"),
  StateData(
      "sensor",
      "vibrationSensor",
      "graphics/state_icons/vibration-sensor.png",
      "/docs/overview/",
      "readDigital"),
  StateData(
      "sensor",
      "loudnessSensor",
      "graphics/state_icons/loudness-sensor.png",
      "/docs/overview/",
      "readAnalog"),
  //StateData("sensor", "Ultrasonic Ranger", "graphics/state_icons/ultrasonic-ranger.png",
  //    "/docs/overview/", "Read Data")
];

List<StateData> userInputBlocks = [
  StateData("userInput", "button", "graphics/state_icons/button.png",
      "/docs/overview/", "awaitInput"),
  StateData("userInput", "switch", "graphics/state_icons/switch.png",
      "/docs/overview/", "awaitInput"),
  StateData("userInput", "keypad", "graphics/state_icons/keypad.png",
      "/docs/overview/", "awaitInput"),
  StateData("userInput", "tilt", "graphics/state_icons/tilt.png",
      "/docs/overview/", "awaitInput"),
  //StateData("userInput", "RFID", "graphics/state_icons/demo.png",
  //    "/docs/overview/", "Await Input")
];

List<StateData> outputBlocks = [
  StateData("output", "led", "graphics/state_icons/led_on.png",
      "/docs/overview/", "on"),
  StateData("output", "led", "graphics/state_icons/led_off.png",
      "/docs/overview/", "off"),
  StateData("output", "buzzer", "graphics/state_icons/buzzer_on.png",
      "/docs/overview/", "on"),
  StateData("output", "buzzer", "graphics/state_icons/buzzer_off.png",
      "/docs/overview/", "off"),
  StateData("output", "vibrationMotor", "graphics/state_icons/vibration_on.png",
      "/docs/overview/", "on"),
  StateData("output", "vibrationMotor",
      "graphics/state_icons/vibration_off.png", "/docs/overview/", "off"),
  StateData("output", "relay", "graphics/state_icons/relay_on.png",
      "/docs/overview/", "on"),
  StateData("output", "relay", "graphics/state_icons/relay_off.png",
      "/docs/overview/", "off"),
  //StateData("output", "Servo", "graphics/state_icons/demo.png",
  //    "/docs/overview/", "90 degree")
];

List<StateData> returnAllData() {
  return sensorBlocks + userInputBlocks + outputBlocks;
}

StateData returnDataByName(String name) {
  StateData result;
  List<StateData> searchList = sensorBlocks + userInputBlocks + outputBlocks;
  result = searchList.firstWhere((el) => el.component == name);

  return result;
}

StateData returnDataByNameAndOption(String name, String option) {
  StateData result;
  List<StateData> searchList = sensorBlocks + userInputBlocks + outputBlocks;
  result = searchList
      .firstWhere((el) => el.component == name && el.option == option);

  return result;
}
