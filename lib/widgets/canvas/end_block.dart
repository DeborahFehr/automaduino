import 'package:arduino_statemachines/resources/state.dart';
import 'package:flutter/material.dart';
import '../../resources/state.dart';

class EndBlock extends StatelessWidget {
  final Offset blockPosition;
  final Function(Offset end) updatePosition;

  const EndBlock(this.blockPosition, this.updatePosition);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: blockPosition.dx,
      top: blockPosition.dy,
      child: Draggable(
          data: StateSettings("", "", null, false, true, null),
          child: DragTarget(builder: (BuildContext context,
              List<dynamic> candidateData, List<dynamic> rejectedData) {
            return Column(
              children: [
                Text(
                  "End",
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
                    Icons.flag_outlined,
                    size: 18.0,
                    color: Colors.white,
                  ),
                )
              ],
            );
          }),
          feedback: Column(
            children: [
              Text(
                "End",
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
                  Icons.flag_outlined,
                  size: 18.0,
                  color: Colors.white,
                ),
              )
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
