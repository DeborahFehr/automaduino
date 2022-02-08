import 'package:arduino_statemachines/resources/state.dart';
import 'package:flutter/material.dart';
import '../../resources/state.dart';

class AddConnectionButton extends StatelessWidget {
  final Key blockKey;
  final bool point;
  final bool condition;
  final Offset blockPosition;
  final Function(
          bool active, bool point, bool adition, Offset start, Offset end)
      updateDrag;

  const AddConnectionButton(this.blockKey, this.point, this.condition,
      this.blockPosition, this.updateDrag);

  @override
  Widget build(BuildContext context) {
    return Draggable(
        data: StateSettings(
            "", "", null, false, true, condition, point, blockKey, ""),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
          ),
          child: condition
              ? Icon(Icons.arrow_circle_right)
              : Icon(Icons.arrow_drop_down_circle),
          onPressed: () {},
        ),
        feedback: condition
            ? Icon(Icons.keyboard_arrow_right)
            : Icon(Icons.keyboard_arrow_down),
        childWhenDragging: Container(),
        onDragStarted: () {
          updateDrag(true, point, condition, blockPosition, blockPosition);
        },
        onDragUpdate: (details) {
          updateDrag(true, point, condition, blockPosition, details.delta);
        },
        onDragEnd: (details) {
          updateDrag(false, point, condition, blockPosition, details.offset);
        });
  }
}
