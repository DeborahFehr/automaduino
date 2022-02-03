import 'package:arduino_statemachines/resources/state.dart';
import 'package:flutter/material.dart';
import '../../resources/state.dart';

class AddConnectionButton extends StatelessWidget {
  final Key blockKey;
  final bool point;
  final Offset blockPosition;
  final Function(bool active, bool point, Offset start, Offset end) updateDrag;

  const AddConnectionButton(
      this.blockKey, this.point, this.blockPosition, this.updateDrag);

  @override
  Widget build(BuildContext context) {
    return Draggable(
        data: StateSettings("", "", null, false, true, point, blockKey, ""),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
          ),
          child: Icon(Icons.arrow_drop_down_circle),
          onPressed: () {},
        ),
        feedback: Icon(Icons.keyboard_arrow_down),
        childWhenDragging: Container(),
        onDragStarted: () {
          updateDrag(true, point, blockPosition, blockPosition);
        },
        onDragUpdate: (details) {
          updateDrag(true, point, blockPosition, details.delta);
        },
        onDragEnd: (details) {
          updateDrag(false, point, blockPosition, details.offset);
        });
  }
}
