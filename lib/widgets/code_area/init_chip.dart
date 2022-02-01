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
    return Material(
        color: Colors.transparent,
        child: Padding(
            padding: EdgeInsets.all(3),
            child: Chip(
              backgroundColor: Colors.white70,
              elevation: 6.0,
              padding: EdgeInsets.all(5),
              avatar: CircleAvatar(
                backgroundColor: color,
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Image(
                    image: AssetImage(imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              label: Text(name),
            )));
  }
}
