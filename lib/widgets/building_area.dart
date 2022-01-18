import 'package:arduino_statemachines/resources/building_blocks.dart';
import 'package:flutter/material.dart';
import '../resources/support_classes.dart';
import 'building_area/draggable_block.dart';
import 'building_area/line_painter.dart';
import 'package:provider/provider.dart';

class BuildingArea extends StatefulWidget {
  BuildingArea({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BuildingAreaState();
  }
}

class _BuildingAreaState extends State<BuildingArea> {
  DraggableConnection? drag;

  void updatePosition(PositionedBlock block, Offset position) {
    block.position = block.position + position;
    setState(() {});
  }

  void updateDrag(bool active, Offset start, Offset end) {
    if (drag == null) {
      drag = DraggableConnection(start, end);
    } else {
      drag = active ? DraggableConnection(start, drag!.end + end) : null;
    }
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
                  painter: LinePainter(state.blocks, state.connections, drag),
                ),
                for (var block in state.blocks)
                  DraggableBlock(block, updatePosition, updateDrag,
                      addConnection(block.key)),
              ],
            );
          },
          onWillAccept: (data) {
            return (data! as BlockData).newBlock;
          },
          onAcceptWithDetails: (drag) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            BlockData data = drag.data as BlockData;
            state.addBlock(PositionedBlock(
                UniqueKey(),
                BuildingBlock(data.name, data.color as Color),
                data.added(),
                renderBox.globalToLocal(drag.offset)));
            setState(() {});
          },
        );
      },
    );
  }
}
