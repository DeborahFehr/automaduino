import 'state.dart';

List<StateData> sensorBlocks = [
  StateData("sensor", "Motion Sensor", "graphics/state_icons/motion-sensor.png",
      "https://automaduino-docs.vercel.app/", "Read Digital"),
  //StateData("sensor", "Temperature Sensor", "graphics/state_icons/temperature-sensor.png",
  //    "https://automaduino-docs.vercel.app/", "Read Data"),
  StateData(
      "sensor",
      "Humidity Sensor",
      "graphics/state_icons/humidity-sensor.png",
      "https://automaduino-docs.vercel.app/",
      "Read Analog"),
  StateData(
      "sensor",
      "Vibration Sensor",
      "graphics/state_icons/vibration-sensor.png",
      "https://automaduino-docs.vercel.app/",
      "Read Digital"),
  StateData(
      "sensor",
      "Loudness Sensor",
      "graphics/state_icons/loudness-sensor.png",
      "https://automaduino-docs.vercel.app/",
      "Read Analog"),
  //StateData("sensor", "Ultrasonic Ranger", "graphics/state_icons/ultrasonic-ranger.png",
  //    "https://automaduino-docs.vercel.app/", "Read Data")
];

List<StateData> userInputBlocks = [
  StateData("userInput", "Button", "graphics/state_icons/button.png",
      "https://automaduino-docs.vercel.app/", "Await Input"),
  StateData("userInput", "Switch", "graphics/state_icons/switch.png",
      "https://automaduino-docs.vercel.app/", "Await Input"),
  StateData("userInput", "Keypad", "graphics/state_icons/keypad.png",
      "https://automaduino-docs.vercel.app/", "Await Input"),
  StateData("userInput", "Tilt", "graphics/state_icons/tilt.png",
      "https://automaduino-docs.vercel.app/", "Await Input"),
  //StateData("userInput", "RFID", "graphics/state_icons/demo.png",
  //    "https://automaduino-docs.vercel.app/", "Await Input")
];

List<StateData> outputBlocks = [
  StateData("output", "LED", "graphics/state_icons/led_on.png",
      "https://automaduino-docs.vercel.app/", "On"),
  StateData("output", "LED", "graphics/state_icons/led_off.png",
      "https://automaduino-docs.vercel.app/", "Off"),
  StateData("output", "Buzzer", "graphics/state_icons/buzzer_on.png",
      "https://automaduino-docs.vercel.app/", "On"),
  StateData("output", "Buzzer", "graphics/state_icons/buzzer_off.png",
      "https://automaduino-docs.vercel.app/", "Off"),
  StateData(
      "output",
      "Vibration Motor",
      "graphics/state_icons/vibration_on.png",
      "https://automaduino-docs.vercel.app/",
      "On"),
  StateData(
      "output",
      "Vibration Motor",
      "graphics/state_icons/vibration_off.png",
      "https://automaduino-docs.vercel.app/",
      "Off"),
  StateData("output", "Relay", "graphics/state_icons/relay_on.png",
      "https://automaduino-docs.vercel.app/", "On"),
  StateData("output", "Relay", "graphics/state_icons/relay_off.png",
      "https://automaduino-docs.vercel.app/", "Off"),
  //StateData("output", "Servo", "graphics/state_icons/demo.png",
  //    "https://automaduino-docs.vercel.app/", "90 degree")
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
