import 'package:flutter/material.dart';
import '../../resources/support_classes.dart';
import 'add_connection_button.dart';

class DraggableBlock extends StatelessWidget {
  final PositionedBlock block;
  final Function(PositionedBlock block, Offset position) updatePosition;
  final Function(bool active, Offset start, Offset end) updateDrag;
  final Function(Key target) addConnection;

  const DraggableBlock(
      this.block, this.updatePosition, this.updateDrag, this.addConnection);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: block.position.dx,
      top: block.position.dy,
      child: Column(
        children: [
          Draggable(
              data: block.data,
              child: DragTarget(
                builder: (context, List<dynamic> candidateData,
                    List<dynamic> rejectedData) {
                  return block.block;
                },
                onWillAccept: (candidate) {
                  BlockData data = (candidate as BlockData);
                  return !data.newBlock && data.newConnection;
                },
                onAccept: (data) {
                  addConnection((data as BlockData).key as Key);
                },
              ),
              feedback: block.block,
              childWhenDragging: Container(),
              onDragUpdate: (details) {
                updatePosition(block, details.delta);
              },
              onDragEnd: (details) {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                updatePosition(block, renderBox.globalToLocal(details.offset));
                //Provider.of<StateModel>(context, listen: false)
                //.updateBlockPosition(block.key, details.offset);
              }),
          AddConnectionButton(block.key, block.position, updateDrag),
        ],
      ),
    );
  }
}
