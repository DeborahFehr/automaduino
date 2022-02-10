import 'package:arduino_statemachines/resources/state.dart';
import 'package:flutter/material.dart';
import 'canvas/draggable_block.dart';
import 'canvas/line_painter.dart';
import 'package:provider/provider.dart';
import 'canvas/draggable_condition.dart';
import '../resources/automaduino_state.dart';
import '../resources/canvas_layout.dart';
import '../resources/transition.dart';
import '../resources/states_data.dart';
import 'canvas/end_block.dart';
import 'canvas/start_block.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildingArea extends StatefulWidget {
  BuildingArea({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BuildingAreaState();
  }
}

class _BuildingAreaState extends State<BuildingArea> {
  DraggableConnection? drag;

  void updateStartPosition(StartData startPoint, Offset end) {
    //Provider.of<AutomaduinoState>(context, listen: false)
    //    .updateStartPosition(startPoint.position + end);
    startPoint.position = startPoint.position + end;
    setState(() {});
  }

  void updateEndPosition(EndData endPoint, Offset end) {
    //Provider.of<AutomaduinoState>(context, listen: false)
    //    .updateEndPosition(endPoint.position + end);
    endPoint.position = endPoint.position + end;
    setState(() {});
  }

  void updateBlockPosition(PositionedState block, Offset position) {
    // ToDo: We actually dont update the position in the datastructure
    // needed to correctly determine position during drag
    block.position = block.position + position;
    setState(() {});
  }

  void deleteState(PositionedState? block, {end: false}) {
    end
        ? Provider.of<AutomaduinoState>(context, listen: false).hideEndPoint()
        : Provider.of<AutomaduinoState>(context, listen: false)
            .deleteBlock(block!);
  }

  void updateDragPosition(
      bool active, bool point, bool addition, Offset start, Offset end) {
    if (drag == null) {
      drag = DraggableConnection(start, end, point, addition);
    } else {
      drag = active
          ? DraggableConnection(start, drag!.end + end, point, addition)
          : null;
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

  dynamic Function(Key, bool, bool) addConnection(Key end, bool endPoint) {
    void addStartKey(Key start, bool startPoint, bool addition) {
      if (addition) {
        Provider.of<AutomaduinoState>(context, listen: false)
            .addAdditionalConnection(start, end);
      } else {
        Offset transitionPosition =
            startPoint ? Offset(0, 0) : calculateMidpoint(start, end);
        if (startPoint) {
          Provider.of<AutomaduinoState>(context, listen: false)
              .startPointConnected();
        }
        Provider.of<AutomaduinoState>(context, listen: false).addConnection(
            Transition(start, Condition(UniqueKey(), "then", [""]), [end],
                transitionPosition, startPoint, endPoint));
      }
    }

    return addStartKey;
  }

  void deleteTransition(Transition? connection, {start: false}) {
    start
        ? Provider.of<AutomaduinoState>(context, listen: false)
            .deleteConnection(
                Provider.of<AutomaduinoState>(context, listen: false)
                    .connections
                    .firstWhere((element) => element.startPoint))
        : Provider.of<AutomaduinoState>(context, listen: false)
            .deleteConnection(connection!);
  }

  void deleteSingleCond(Transition connection, int position) {
    Provider.of<AutomaduinoState>(context, listen: false)
        .deleteCondValue(connection, position);
  }

  dynamic Function(String) updateStateName(Key key) {
    void update(String name) {
      Provider.of<AutomaduinoState>(context, listen: false)
          .updateStateName(key, name);
    }

    return update;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AutomaduinoState>(
      builder: (context, state, child) {
        return InteractiveViewer(
          maxScale: 2.0,
          minScale: 0.5,
          constrained: false,
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 1000, height: 1000),
            child: DragTarget(
              builder: (BuildContext context, List<dynamic> candidateData,
                  List<dynamic> rejectedData) {
                return Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    CustomPaint(
                      painter: LinePainter(state.blocks, state.connections,
                          state.startPoint, state.endPoint, drag),
                    ),
                    StartBlock(state.startPoint, updateStartPosition,
                        updateDragPosition, deleteTransition),
                    state.endPoint.available
                        ? EndBlock(
                            state.endPoint.key,
                            state.endPoint,
                            updateEndPosition,
                            deleteState,
                            addConnection(state.endPoint.key, true))
                        : SizedBox.shrink(),
                    for (var connection in state.connections
                        .where((element) => !element.startPoint))
                      DraggableCondition(
                          connection.condition.key,
                          connection,
                          state.blocks.firstWhereOrNull(
                              (element) => element.key == connection.start),
                          connection.position,
                          updateConnectionPosition,
                          updateConnectionDetails,
                          deleteTransition,
                          deleteSingleCond,
                          updateDragPosition),
                    for (var block in state.blocks)
                      DraggableBlock(
                          block,
                          updateStateName,
                          deleteState,
                          updateBlockPosition,
                          updateDragPosition,
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
                    (state.blocks.length.toString() + "_" + data.name)
                        .replaceAll(" ", "_");
                StateData blockData =
                    returnDataByNameAndOption(data.name, data.selectedOption);
                Key key = UniqueKey();
                state.addBlock(
                  PositionedState(
                      key,
                      data.added(AppLocalizations.of(context)!.json(data.name)),
                      blockData,
                      renderBox.globalToLocal(drag.offset),
                      false),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
