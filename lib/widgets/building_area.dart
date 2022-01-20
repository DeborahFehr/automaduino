import 'package:flutter/material.dart';
import '../resources/support_classes.dart';
import 'building_area/draggable_block.dart';
import 'building_area/line_painter.dart';
import 'package:provider/provider.dart';
import 'building_area/draggable_condition.dart';
import 'building_area/state_block.dart';

class BuildingArea extends StatefulWidget {
  BuildingArea({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BuildingAreaState();
  }
}

class _BuildingAreaState extends State<BuildingArea> {
  DraggableConnection? drag;

  void updateBlockPosition(PositionedBlock block, Offset position) {
    block.position = block.position + position;
    setState(() {});
  }

  void updateDragPosition(bool active, Offset start, Offset end) {
    if (drag == null) {
      drag = DraggableConnection(start, end);
    } else {
      drag = active ? DraggableConnection(start, drag!.end + end) : null;
    }
    setState(() {});
  }

  void updateConnectionPosition(Connection connection, Offset position) {
    connection.position = connection.position + position;
    setState(() {});
  }

  void updateConnectionDetails(Condition condition,
      {String? type, List<String>? values}) {
    if (type != null) {
      Provider.of<StateModel>(context, listen: false).updateConnectionType(
          condition,
          conditionType.values
              .firstWhere((e) => e.toString() == 'conditionType.' + type));
    }
    if (values != null) {
      Provider.of<StateModel>(context, listen: false)
          .updateConnectionValues(condition, values);
    }
  }

  Offset calculateMidpoint(Key start, Key end) {
    Offset startPoint = Provider.of<StateModel>(context, listen: false)
        .blocks
        .firstWhere((el) => el.key == start)
        .position;

    Offset endPoint = Provider.of<StateModel>(context, listen: false)
        .blocks
        .firstWhere((el) => el.key == end)
        .position;

    return (startPoint + endPoint) / 2;
  }

  dynamic Function(Key) addConnection(Key start) {
    void addEndKey(Key end) {
      Provider.of<StateModel>(context, listen: false).addConnection(Connection(
          start,
          Condition(UniqueKey(), conditionType.iff, [""]),
          [end],
          calculateMidpoint(start, end)));
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
                for (var connection in state.connections)
                  DraggableCondition(
                      connection.condition.key,
                      connection,
                      connection.position,
                      updateConnectionPosition,
                      updateConnectionDetails),
                for (var block in state.blocks)
                  DraggableBlock(block, updateBlockPosition, updateDragPosition,
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
                StateBlock(data.name, data.color as Color),
                data.added(),
                renderBox.globalToLocal(drag.offset)));
            setState(() {});
          },
        );
      },
    );
  }
}
