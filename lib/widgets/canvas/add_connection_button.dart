import 'package:flutter/material.dart';
import '../../resources/canvas_layout.dart';

class AddConnectionButton extends StatelessWidget {
  final Key blockKey;
  final String blockOption;
  final bool point;
  final bool condition;
  final Offset blockPosition;
  final Function(
          bool active, bool point, bool adition, Offset start, Offset end)
      updateDrag;

  const AddConnectionButton(this.blockKey, this.blockOption, this.point,
      this.condition, this.blockPosition, this.updateDrag);

  @override
  Widget build(BuildContext context) {
    return Draggable(
        data:
            DragData(blockKey, "", blockOption, false, true, condition, point),
        child: SizedBox(
          height: 20,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
            ),
            child: condition
                ? Icon(Icons.arrow_forward) //Icon(Icons.arrow_circle_right)
                : Icon(Icons.arrow_drop_down_circle),
            onPressed: () {},
          ),
        ),
        feedback: Icon(Icons.keyboard_arrow_down),
        childWhenDragging: SizedBox(height: 20),
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
