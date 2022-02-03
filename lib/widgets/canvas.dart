import 'package:arduino_statemachines/resources/state.dart';
import 'package:flutter/material.dart';
import 'canvas/draggable_block.dart';
import 'canvas/line_painter.dart';
import 'package:provider/provider.dart';
import 'canvas/draggable_condition.dart';
import 'canvas/state_block.dart';
import '../resources/automaduino_state.dart';
import '../resources/canvas_layout.dart';
import '../resources/transition.dart';
import '../resources/states_data.dart';
import 'canvas/end_block.dart';
import 'canvas/start_block.dart';

class BuildingArea extends StatefulWidget {
  BuildingArea({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BuildingAreaState();
  }
}

class _BuildingAreaState extends State<BuildingArea> {
  DraggableConnection? drag;
  Offset startPosition = Offset(40, 40);
  Offset endPosition = Offset(240, 40);

  void updateStartPosition(Offset position) {
    Provider.of<AutomaduinoState>(context, listen: false)
        .updateStartPosition(position);
  }

  void updateEndPosition(Offset position) {
    Provider.of<AutomaduinoState>(context, listen: false)
        .updateEndPosition(position);
  }

  void updateBlockPosition(PositionedState block, Offset position) {
    // ToDo: We actually dont update the position in the datastructure
    block.position = block.position + position;
    setState(() {});
  }

  void updateDragPosition(bool active, bool point, Offset start, Offset end) {
    if (drag == null) {
      drag = DraggableConnection(start, end, point);
    } else {
      drag = active ? DraggableConnection(start, drag!.end + end, point) : null;
    }
    setState(() {});
  }

  void updateConnectionPosition(Transition connection, Offset position) {
    connection.position = connection.position + position;
    setState(() {});
  }

  void updateConnectionDetails(Condition condition,
      {String? type, List<String>? values}) {
    if (type != null) {
      Provider.of<AutomaduinoState>(context, listen: false)
          .updateConnectionType(condition, type);
    }
    if (values != null) {
      Provider.of<AutomaduinoState>(context, listen: false)
          .updateConnectionValues(condition, values);
    }
  }

  Offset calculateMidpoint(Key start, Key end) {
    Offset startPoint = Provider.of<AutomaduinoState>(context, listen: false)
        .blocks
        .firstWhere((el) => el.key == start)
        .position;

    Offset endPoint;
    endPoint = end ==
            Provider.of<AutomaduinoState>(context, listen: false).endPoint.key
        ? Provider.of<AutomaduinoState>(context, listen: false)
            .endPoint
            .position
        : Provider.of<AutomaduinoState>(context, listen: false)
            .blocks
            .firstWhere((el) => el.key == end)
            .position;

    return (startPoint + endPoint) / 2;
  }

  dynamic Function(Key, bool) addConnection(Key end, bool endPoint) {
    void addStartKey(Key start, bool startPoint) {
      Offset transitionPosition =
          startPoint ? Offset(0, 0) : calculateMidpoint(start, end);
      if (startPoint) {
        Provider.of<AutomaduinoState>(context, listen: false)
            .startPointConnected();
      }
      Provider.of<AutomaduinoState>(context, listen: false).addConnection(
          Transition(start, Condition(UniqueKey(), "then", [""]), [end],
              transitionPosition, startPoint, endPoint));
      setState(() {});
    }

    return addStartKey;
  }

  dynamic Function(String, Widget) updateStateName(Key key) {
    void update(String name, Widget block) {
      Provider.of<AutomaduinoState>(context, listen: false)
          .updateStateName(key, name, block);
    }

    return update;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AutomaduinoState>(
      builder: (context, state, child) {
        return DragTarget(
          builder: (BuildContext context, List<dynamic> candidateData,
              List<dynamic> rejectedData) {
            return Stack(
              children: <Widget>[
                CustomPaint(
                  painter: LinePainter(state.blocks, state.connections,
                      state.startPoint, state.endPoint, drag),
                ),
                StartBlock(
                    state.startPoint.key,
                    state.startPoint.connected,
                    state.startPoint.position,
                    updateStartPosition,
                    updateDragPosition),
                EndBlock(state.endPoint.key, state.endPoint.position,
                    updateEndPosition, addConnection(state.endPoint.key, true)),
                for (var connection in state.connections
                    .where((element) => !element.startPoint))
                  DraggableCondition(
                      connection.condition.key,
                      connection,
                      connection.position,
                      updateConnectionPosition,
                      updateConnectionDetails),
                for (var block in state.blocks)
                  DraggableBlock(block, updateBlockPosition, updateDragPosition,
                      addConnection(block.key, false)),
              ],
            );
          },
          onWillAccept: (data) {
            return (data! as StateSettings).newBlock;
          },
          onAcceptWithDetails: (drag) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            StateSettings data = drag.data as StateSettings;
            data.variableName =
                (state.blocks.length.toString() + "_" + data.variableName)
                    .replaceAll(" ", "_");
            StateData blockData =
                returnDataByNameAndOption(data.name, data.selectedOption);
            Key key = UniqueKey();
            Color color = blockData.type == "sensor"
                ? Colors.redAccent
                : blockData.type == "userInput"
                    ? Colors.blueAccent
                    : Colors.greenAccent;
            state.addBlock(PositionedState(
                key,
                StateBlock(
                    data.name,
                    color,
                    blockData.imagePath,
                    blockData.option,
                    data.pin,
                    data.selectedOption,
                    updateStateName(key)),
                data.added(),
                blockData,
                renderBox.globalToLocal(drag.offset)));
            setState(() {});
          },
        );
      },
    );
  }
}
