import 'package:flutter/material.dart';
import 'support_classes.dart';

List<BlockData> sensorBlocks = [
  BlockData("Motion Sensor", Colors.redAccent, true, false, null),
  BlockData("Temperature Sensor", Colors.blueAccent, true, false, null),
  BlockData("Humidity Sensor", Colors.greenAccent, true, false, null),
  BlockData("Vibration Sensor", Colors.amberAccent, true, false, null),
  BlockData("Loudness Sensor", Colors.pinkAccent, true, false, null),
  BlockData("Ultrasonic Ranger", Colors.yellowAccent, true, false, null)
];

List<BlockData> userInputBlocks = [
  BlockData("Button", Colors.redAccent, true, false, null),
  BlockData("Switch", Colors.blueAccent, true, false, null),
  BlockData("Keypad", Colors.greenAccent, true, false, null),
  BlockData("Tilt", Colors.amberAccent, true, false, null),
  BlockData("RFID", Colors.pinkAccent, true, false, null)
];

List<BlockData> outputBlocks = [
  BlockData("LED", Colors.redAccent, true, false, null),
  BlockData("Buzzer", Colors.blueAccent, true, false, null),
  BlockData("Vibration Motor", Colors.greenAccent, true, false, null),
  BlockData("Relay", Colors.amberAccent, true, false, null),
  BlockData("Infrared Emitter", Colors.pinkAccent, true, false, null),
  BlockData("Servo", Colors.yellowAccent, true, false, null)
];

class BuildingBlock extends StatelessWidget {
  final String name;
  final Color color;

  const BuildingBlock(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: color,
      child: Center(
          child: Tooltip(
        message: 'Input Sensors',
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 14.0,
                color: Colors.black54,
              ),
            ),
            Icon(Icons.input)
          ],
        ),
      )),
    );
  }
}
