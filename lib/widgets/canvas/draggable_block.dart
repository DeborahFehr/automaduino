import 'package:arduino_statemachines/resources/state.dart';
import 'package:flutter/material.dart';
import 'state_block.dart';
import '../../resources/canvas_layout.dart';
import 'add_connection_button.dart';
import 'package:contextmenu/contextmenu.dart';

class DraggableBlock extends StatelessWidget {
  final PositionedState block;
  final Function(Key key) updateStateName;
  final Function(PositionedState? state, {bool end}) deleteBlock;
  final Function(PositionedState block, Offset position) updatePosition;
  final Function(
          bool active, bool point, bool adition, Offset start, Offset end)
      updateDrag;
  final Function(Key target, bool startPoint, bool addition) addConnection;

  const DraggableBlock(this.block, this.updateStateName, this.deleteBlock,
      this.updatePosition, this.updateDrag, this.addConnection);

  @override
  Widget build(BuildContext context) {
    Color color = block.data.type == "sensor"
        ? Colors.redAccent
        : block.data.type == "userInput"
            ? Colors.blueAccent
            : Colors.greenAccent;

    Widget blockWidget = StateBlock(
        block.settings.name,
        color,
        block.data.imagePath,
        block.data.option,
        block.settings.pin,
        block.settings.selectedOption,
        updateStateName(block.key),
        TextEditingController());

    return Positioned(
      left: block.position.dx,
      top: block.position.dy,
      child: Column(
        children: [
          ContextMenuArea(
            width: 200,
            items: [
              ListTile(
                leading: Icon(Icons.highlight_remove),
                title: Text('Delete State'),
                onTap: () {
                  deleteBlock(block);
                  Navigator.of(context).pop();
                },
              ),
            ],
            child: Draggable(
                data: block.settings,
                child: DragTarget(
                  builder: (context, List<dynamic> candidateData,
                      List<dynamic> rejectedData) {
                    return blockWidget;
                  },
                  onWillAccept: (candidate) {
                    StateSettings data = (candidate as StateSettings);
                    return !data.newBlock &&
                        data.newConnection &&
                        data.key != block.key;
                  },
                  onAccept: (data) {
                    addConnection((data as StateSettings).key as Key,
                        data.startConnection, data.additionalConnection);
                  },
                ),
                feedback: blockWidget,
                childWhenDragging: Container(),
                onDragUpdate: (details) {
                  updatePosition(block, details.delta);
                },
                onDragEnd: (details) {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  updatePosition(
                      block, renderBox.globalToLocal(details.offset));
                }),
          ),
          block.outgoingConnection
              ? SizedBox.shrink()
              : AddConnectionButton(
                  block.key, false, false, block.position, updateDrag),
        ],
      ),
    );
  }
}
