import 'package:flutter/material.dart';

class DraggableBlock extends StatelessWidget {
  final Offset position;
  final Widget block;
  final Function(Offset position) updatePosition;
  // ToDo: pass Data? Save data in block?

  const DraggableBlock(this.position, this.block, this.updatePosition);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
          data: [false, 'test'],
          child: block,
          feedback: block,
          childWhenDragging: Container(),
          onDragEnd: (details) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            // this needs to be passed above
            //position = renderBox.globalToLocal(details.offset);
            updatePosition(renderBox.globalToLocal(details.offset));
          }),
    );
  }
}