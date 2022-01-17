import 'package:arduino_statemachines/resources/building_blocks.dart';
import 'package:flutter/material.dart';
import '../resources/support_classes.dart';
import 'building_area/draggable_block.dart';
import 'building_area/line_painter.dart';
import 'package:provider/provider.dart';

class BuildingArea extends StatefulWidget {
  final Function(List<Connection> target) update;

  BuildingArea({Key? key, required this.update}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BuildingAreaState();
  }
}

class _BuildingAreaState extends State<BuildingArea> {
  bool drag = false;
  late Key dragKey;
  bool showButtons = true;

  void updatePosition(PositionedBlock block, Offset position) {
    block.position = block.position + position;
    setState(() {});
  }

  void updateButtons() {
    showButtons = !showButtons;
    setState(() {});
  }

  dynamic Function(Key) addConnection(Key start) {
    void addEndKey(Key end) {
      Provider.of<StateModel>(context, listen: false)
          .addConnection(Connection(start, end, "test"));
      setState(() {});
    }

    return addEndKey;
  }

  void addArrow(Key key) {
    dragKey = key;
    drag = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(
      builder: (context, state, child) {
        return DragTarget(
          builder: (BuildContext context, List<dynamic> candidateData,
              List<dynamic> rejectedData) {
            return Stack(
              children: <Widget>[
                CustomPaint(
                  painter: LinePainter(state.blocks, state.connections),
                ),
                drag
                    ? Draggable(
                        data: [false, dragKey],
                        child: Icon(Icons.keyboard_arrow_down),
                        feedback: Icon(Icons.keyboard_arrow_down),
                        childWhenDragging: Container(),
                      )
                    : Container(),
                for (var block in state.blocks)
                  DraggableBlock(block, updatePosition, addArrow,
                      addConnection(block.key), updateButtons, showButtons),
              ],
            );
          },
          onWillAccept: (data) {
            return (data! as List)[0];
          },
          onAcceptWithDetails: (drag) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            state.addBlock(PositionedBlock(
                UniqueKey(),
                BuildingBlock((drag.data! as List)[1], Colors.blue),
                renderBox.globalToLocal(drag.offset)));
            setState(() {});
          },
        );
      },
    );
  }
}
