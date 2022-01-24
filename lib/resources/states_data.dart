import 'package:flutter/material.dart';
import 'state.dart';

List<StateData> sensorBlocks = [
  StateData(
      "sensor",
      "Motion Sensor",
      "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/",
      ["Option 1", "Option 2", "Option 3"]),
  StateData("sensor", "Temperature Sensor", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", ["Option 1"]),
  StateData("sensor", "Humidity Sensor", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", ["Option 1"]),
  StateData("sensor", "Vibration Sensor", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", ["Option 1"]),
  StateData("sensor", "Loudness Sensor", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", ["Option 1"]),
  StateData("sensor", "Ultrasonic Ranger", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", ["Option 1"])
];

List<StateData> userInputBlocks = [
  StateData("userInput", "Button", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", ["Option 1"]),
  StateData("userInput", "Switch", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", ["Option 1"]),
  StateData("userInput", "Keypad", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", ["Option 1"]),
  StateData("userInput", "Tilt", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", ["Option 1"]),
  StateData("userInput", "RFID", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", ["Option 1"])
];

List<StateData> outputBlocks = [
  StateData("output", "LED", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", ["On", "Off"]),
  StateData("output", "Buzzer", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", ["On", "Off"]),
  StateData("output", "Vibration Motor", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", ["On", "Off"]),
  StateData("output", "Relay", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", ["On", "Off"]),
  StateData("output", "Infrared Emitter", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", ["On", "Off"]),
  StateData("output", "Servo", "graphics/state_icons/logo.png",
      "https://automaduino-docs.vercel.app/", ["Option 1"])
];

StateData returnData(String name) {
  StateData result;
  List<StateData> searchList = sensorBlocks + userInputBlocks + outputBlocks;
  result = searchList.firstWhere((el) => el.component == name);

  return result;
}
