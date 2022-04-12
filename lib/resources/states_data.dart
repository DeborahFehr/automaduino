import 'state.dart';

List<StateData> sensorBlocks = [
  StateData("sensor", "motionSensor", "graphics/state_icons/motion-sensor.png",
      "/docs/components/sensors/motion-sensor/", "readDigital"),
  StateData(
      "sensor",
      "temperatureSensor",
      "graphics/state_icons/temperature-sensor.png",
      "/docs/components/sensors/temperature-sensor/",
      "readCelsius"),
  StateData(
      "sensor",
      "humiditySensor",
      "graphics/state_icons/humidity-sensor.png",
      "/docs/components/sensors/humidity-sensor/",
      "readAnalog"),
  StateData(
      "sensor",
      "vibrationSensor",
      "graphics/state_icons/vibration-sensor.png",
      "/docs/components/sensors/vibration-sensor/",
      "readDigital"),
  StateData(
      "sensor",
      "loudnessSensor",
      "graphics/state_icons/loudness-sensor.png",
      "/docs/components/sensors/loudness-sensor/",
      "readAnalog"),
  StateData(
      "sensor",
      "ultrasonicRanger",
      "graphics/state_icons/ultrasonic-ranger_send.png",
      "/docs/components/sensors/ultrasonic-ranger/",
      "sendWave"),
  StateData(
      "sensor",
      "ultrasonicRanger",
      "graphics/state_icons/ultrasonic-ranger_receive.png",
      "/docs/components/sensors/ultrasonic-ranger/",
      "receiveWave")
];

List<StateData> userInputBlocks = [
  StateData("userInput", "button", "graphics/state_icons/button.png",
      "/docs/components/user-input/button/", "awaitInput"),
  StateData("userInput", "switch", "graphics/state_icons/switch.png",
      "/docs/components/user-input/switch/", "awaitInput"),
  StateData("userInput", "slider", "graphics/state_icons/tilt.png",
      "/docs/components/user-input/slider/", "awaitInput"),
  StateData(
      "userInput",
      "potentiometer",
      "graphics/state_icons/potentiometer.png",
      "/docs/components/user-input/potentiometer/",
      "awaitInput"),
];

List<StateData> outputBlocks = [
  StateData("output", "led", "graphics/state_icons/led_on.png",
      "/docs/components/output/led/", "on"),
  StateData("output", "led", "graphics/state_icons/led_off.png",
      "/docs/components/output/led/", "off"),
  StateData("output", "buzzer", "graphics/state_icons/buzzer_on.png",
      "/docs/components/output/buzzer/", "on"),
  StateData("output", "buzzer", "graphics/state_icons/buzzer_off.png",
      "/docs/components/output/buzzer/", "off"),
  StateData("output", "vibrationMotor", "graphics/state_icons/vibration_on.png",
      "/docs/components/output/vibration-motor/", "on"),
  StateData(
      "output",
      "vibrationMotor",
      "graphics/state_icons/vibration_off.png",
      "/docs/components/output/vibration-motor/",
      "off"),
  StateData("output", "relay", "graphics/state_icons/relay_on.png",
      "/docs/components/output/relay/", "on"),
  StateData("output", "relay", "graphics/state_icons/relay_off.png",
      "/docs/components/output/relay/", "off"),
  StateData("output", "servo", "graphics/state_icons/servo_0.png",
      "/docs/components/output/servo/", "0degree"),
  StateData("output", "servo", "graphics/state_icons/servo_45.png",
      "/docs/components/output/servo/", "45degree"),
  StateData("output", "servo", "graphics/state_icons/servo_90.png",
      "/docs/components/output/servo/", "90degree"),
  StateData("output", "servo", "graphics/state_icons/servo_135.png",
      "/docs/components/output/servo/", "135degree"),
  StateData("output", "servo", "graphics/state_icons/servo_180.png",
      "/docs/components/output/servo/", "180degree"),
];

List<StateData> returnAllData() {
  return outputBlocks + sensorBlocks + userInputBlocks;
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
