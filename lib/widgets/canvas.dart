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

class BuildingArea extends StatefulWidget {
  BuildingArea({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BuildingAreaState();
  }
}

class _BuildingAreaState extends State<BuildingArea> {
  DraggableConnection? drag;

  void updateBlockPosition(PositionedState block, Offset position) {
    // ToDo: We actually dont update the position in the datastructure
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

  void updateConnectionPosition(Transition connection, Offset position) {
    connection.position = connection.position + position;
    setState(() {});
  }

  void updateConnectionDetails(Condition condition,
      {String? type, List<String>? values}) {
    if (type != null) {
      Provider.of<AutomaduinoState>(context, listen: false)
          .updateConnectionType(
              condition,
              conditionType.values
                  .firstWhere((e) => e.toString() == 'conditionType.' + type));
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

    Offset endPoint = Provider.of<AutomaduinoState>(context, listen: false)
        .blocks
        .firstWhere((el) => el.key == end)
        .position;

    return (startPoint + endPoint) / 2;
  }

  dynamic Function(Key) addConnection(Key start) {
    void addEndKey(Key end) {
      Provider.of<AutomaduinoState>(context, listen: false).addConnection(
          Transition(start, Condition(UniqueKey(), conditionType.then, [""]),
              [end], calculateMidpoint(start, end)));
      setState(() {});
    }

    return addEndKey;
  }

  dynamic Function(String, Widget) updateStateName(Key key) {
    void update(String name, Widget block) {
      Provider.of<AutomaduinoState>(context, listen: false)
          .updateStateName(key, name, block);
    }

    return update;
  }

  dynamic Function(String, Widget) updateStateSelectedOption(Key key) {
    void update(String option, Widget block) {
      Provider.of<AutomaduinoState>(context, listen: false)
          .updateStateSelectedOption(key, option, block);
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
            return (data! as StateSettings).newBlock;
          },
          onAcceptWithDetails: (drag) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            StateSettings data = drag.data as StateSettings;
            StateData blockData = returnData(data.name);
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
                    data.selectedOption,
                    updateStateName(key),
                    updateStateSelectedOption(key)),
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
