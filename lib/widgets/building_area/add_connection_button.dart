import 'package:flutter/material.dart';
import '../../resources/support_classes.dart';

class AddConnectionButton extends StatelessWidget {
  final Key blockKey;
  final Offset blockPosition;
  final Function(bool active, Offset start, Offset end) updateDrag;

  const AddConnectionButton(this.blockKey, this.blockPosition, this.updateDrag);

  @override
  Widget build(BuildContext context) {
    return Draggable(
        data: BlockData("", null, false, true, blockKey),
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
          updateDrag(true, blockPosition, blockPosition);
        },
        onDragUpdate: (details) {
          updateDrag(true, blockPosition, details.delta);
        },
        onDragEnd: (details) {
          updateDrag(false, blockPosition, details.offset);
        });
  }
}
