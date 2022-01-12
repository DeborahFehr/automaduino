import 'package:flutter/material.dart';

class BuildingBlock1 extends StatelessWidget {
  final String name;

  const BuildingBlock1(this.name);

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
