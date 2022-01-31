import 'package:flutter/material.dart';

class InitChip extends StatelessWidget {
  final String name;
  final Color color;
  final String imagePath;

  const InitChip(
    this.name,
    this.color,
    this.imagePath,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(3),
        child: Chip(
          backgroundColor: Colors.white70,
          elevation: 6.0,
          padding: EdgeInsets.all(5),
          avatar: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Image(
                image: AssetImage("graphics/state_icons/loudness-sensor.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
          label: Text('Aaron Burr'),
        ));
  }
}
