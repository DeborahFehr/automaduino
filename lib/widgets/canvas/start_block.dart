import 'package:arduino_statemachines/resources/state.dart';
import 'package:flutter/material.dart';
import '../../resources/state.dart';
import 'add_connection_button.dart';

class StartBlock extends StatelessWidget {
  final Key key;
  final bool connected;
  final Offset blockPosition;
  final Function(Offset end) updatePosition;
  final Function(bool active, bool point, Offset start, Offset end) updateDrag;

  const StartBlock(this.key, this.connected, this.blockPosition,
      this.updatePosition, this.updateDrag);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: blockPosition.dx,
      top: blockPosition.dy,
      child: Draggable(
          data: StateSettings("", "", null, false, true, false, key, ""),
          child: Column(
            children: [
              Text(
                "Start",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 25,
                height: 25,
                decoration: const ShapeDecoration(
                  color: Colors.black,
                  shape: CircleBorder(),
                ),
                child: Icon(
                  Icons.play_arrow_outlined,
                  size: 20.0,
                  color: Colors.white,
                ),
              ),
              connected
                  ? Container()
                  : AddConnectionButton(key, true, blockPosition, updateDrag),
            ],
          ),
          feedback: Column(
            children: [
              Text(
                "Start",
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  color: Colors.black,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 25,
                height: 25,
                decoration: const ShapeDecoration(
                  color: Colors.black,
                  shape: CircleBorder(),
                ),
                child: Icon(
                  Icons.play_arrow_outlined,
                  size: 20.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          childWhenDragging: Container(),
          onDragEnd: (details) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            updatePosition(
                blockPosition + renderBox.globalToLocal(details.offset));
          }),
    );
  }
}
