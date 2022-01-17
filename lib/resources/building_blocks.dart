import 'package:flutter/material.dart';
import 'support_classes.dart';

class BuildingBlock extends StatelessWidget {
  final String name;
  final Color color;

  const BuildingBlock(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.blue,
      child: Center(
        child: Text(name,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 14.0,
              color: Colors.black54,
            )),
      ),
    );
  }
}
