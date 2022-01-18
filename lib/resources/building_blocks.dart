import 'package:flutter/material.dart';
import 'support_classes.dart';

List<BlockData> elementalBlocks = [
  BlockData("Block 1", Colors.redAccent, true, false, null),
  BlockData("Block 2", Colors.blueAccent, true, false, null),
  BlockData("Block 3", Colors.greenAccent, true, false, null)
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
