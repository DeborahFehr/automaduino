import 'package:flutter/material.dart';
import '../../resources/positioned_block.dart';

class DraggableBlock extends StatelessWidget {
  final PositionedBlock block;
  final Function(PositionedBlock block, Offset position) updatePosition;
  // ToDo: pass Data? Save data in block?

  const DraggableBlock(this.block, this.updatePosition);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: block.position.dx,
      top: block.position.dy,
      child: Draggable(
          data: [false, 'test'],
          child: block.block,
          feedback: block.block,
          childWhenDragging: Container(),
          onDragEnd: (details) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            updatePosition(block, renderBox.globalToLocal(details.offset));
          }),
    );
  }
}