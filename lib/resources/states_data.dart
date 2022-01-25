import 'package:flutter/material.dart';
import 'state.dart';

List<StateData> sensorBlocks = [
  StateData("sensor", "Motion Sensor", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "Read Data"),
  StateData("sensor", "Temperature Sensor", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "Read Data"),
  StateData("sensor", "Humidity Sensor", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "Read Data"),
  StateData("sensor", "Vibration Sensor", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "Read Data"),
  StateData("sensor", "Loudness Sensor", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "Read Data"),
  StateData("sensor", "Ultrasonic Ranger", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "Read Data")
];

List<StateData> userInputBlocks = [
  StateData("userInput", "Button", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "Await Input"),
  StateData("userInput", "Switch", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "Await Input"),
  StateData("userInput", "Keypad", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "Await Input"),
  StateData("userInput", "Tilt", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "Await Input"),
  StateData("userInput", "RFID", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "Await Input")
];

List<StateData> outputBlocks = [
  StateData("output", "LED", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "On"),
  StateData("output", "Buzzer", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "On"),
  StateData("output", "Vibration Motor", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "On"),
  StateData("output", "Relay", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "On"),
  StateData("output", "Infrared Emitter", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "On"),
  StateData("output", "Servo", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", "On")
];

StateData returnData(String name) {
  StateData result;
  List<StateData> searchList = sensorBlocks + userInputBlocks + outputBlocks;
  result = searchList.firstWhere((el) => el.component == name);

  return result;
}
