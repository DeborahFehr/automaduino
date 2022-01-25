import 'package:arduino_statemachines/resources/state.dart';
import 'package:flutter/material.dart';
import '../../resources/canvas_layout.dart';
import 'add_connection_button.dart';

class DraggableBlock extends StatelessWidget {
  final PositionedState block;
  final Function(PositionedState block, Offset position) updatePosition;
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
              data: block.settings,
              child: DragTarget(
                builder: (context, List<dynamic> candidateData,
                    List<dynamic> rejectedData) {
                  return block.block;
                },
                onWillAccept: (candidate) {
                  StateSettings data = (candidate as StateSettings);
                  return !data.newBlock && data.newConnection;
                },
                onAccept: (data) {
                  addConnection((data as StateSettings).key as Key);
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