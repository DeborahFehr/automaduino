import 'package:flutter/material.dart';
import '../../resources/SupportClasses.dart';

class DraggableBlock extends StatelessWidget {
  final PositionedBlock block;
  final Function(PositionedBlock block, Offset position) updatePosition;
  final Function(Key candidate) addArrow;
  final Function(Key target) addConnection;
  final Function() showButton;
  final bool visibleButton;

  // ToDo: pass Data? Save data in block?

  const DraggableBlock(this.block, this.updatePosition, this.addArrow,
      this.addConnection, this.showButton, this.visibleButton);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: block.position.dx,
      top: block.position.dy,
      child: Column(
        children: [
          Draggable(
              data: [false, 'test'],
              child: DragTarget(
                builder: (context, List<dynamic> candidateData,
                    List<dynamic> rejectedData) {
                  return block.block;
                },
                onWillAccept: (candidate) {
                  List data = (candidate as List);
                  return data[0] ? false : true;
                },
                onAccept: (data) {
                  addConnection((data as List)[1]);
                },
              ),
              feedback: block.block,
              childWhenDragging: Container(),
              onDragStarted: () => {showButton()},
              onDragEnd: (details) {
                showButton();
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                updatePosition(block, renderBox.globalToLocal(details.offset));
              }),
          Visibility(
            visible: visibleButton,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: Icon(Icons.arrow_drop_down_circle),
              onPressed: () => {addArrow(block.key)},
            ),
          )
        ],
      ),
    );
  }
}
