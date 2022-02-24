import 'package:arduino_statemachines/resources/settings.dart';
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
import 'canvas/scale_buttons.dart';
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
  final TransformationController _scaleController = TransformationController();
  double _scale = 1.0;
  double maxScale = 2.0;
  double minScale = 0.5;

  void setScale(double scaleChange) {
    double scale = _scale + scaleChange;
    if (!(scale > maxScale) && !(scale < minScale)) {
      setState(() {
        _scale = scale;
        _scaleController.value.setEntry(0, 0, scale);
        _scaleController.value.setEntry(1, 1, scale);
        _scaleController.value.setEntry(2, 2, scale);
      });
    }
  }

  void updateStartPosition(StartData startPoint, Offset end, bool dragEnd) {
    setState(() {
      startPoint.position = dragEnd
          ? keepInCanvas(startPoint.position + end)
          : startPoint.position + end;
    });
  }

  void updateEndPosition(EndData endPoint, Offset end, bool dragEnd) {
    setState(() {
      endPoint.position = dragEnd
          ? keepInCanvas(endPoint.position + end)
          : endPoint.position + end;
    });
  }

  void updateBlockPosition(
      PositionedState block, Offset position, bool dragEnd) {
    setState(() {
      block.position = dragEnd
          ? keepInCanvas(block.position + position)
          : block.position + position;
    });
  }

  void deleteState(PositionedState? block, {end: false}) {
    end
        ? Provider.of<AutomaduinoState>(context, listen: false).hideEndPoint()
        : Provider.of<AutomaduinoState>(context, listen: false)
            .deleteBlock(block!);
  }

  void updateDragPosition(
      bool active, bool point, bool addition, Offset start, Offset end) {
    setState(() {
      if (drag == null) {
        drag = DraggableConnection(start, end, point, addition);
      } else {
        drag = active
            ? DraggableConnection(
                start, drag!.end + (end * (1 / _scale)), point, addition)
            : null;
      }
    });
  }

  void updateConnectionPosition(Transition connection, Offset position) {
    setState(() {
      connection.position = connection.position + position;
    });
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
              .connectStartPoint();
        }
        Provider.of<AutomaduinoState>(context, listen: false).addConnection(
            Transition(start, Condition(UniqueKey(), "then", [""]), [end],
                transitionPosition, startPoint, endPoint));
      }
    }

    return addStartKey;
  }

  void deleteTransition(Transition? connection, {start: false}) {
    if (start) {
      Provider.of<AutomaduinoState>(context, listen: false)
          .startPoint
          .connected = false;
      Provider.of<AutomaduinoState>(context, listen: false).deleteConnection(
          Provider.of<AutomaduinoState>(context, listen: false)
              .connections
              .firstWhere((element) => element.startPoint));
    } else {
      Provider.of<AutomaduinoState>(context, listen: false)
          .deleteConnection(connection!);
    }
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
        return Stack(
          children: [
            InteractiveViewer(
              maxScale: maxScale,
              minScale: minScale,
              constrained: false,
              transformationController: _scaleController,
              onInteractionEnd: (details) =>
                  _scale = _scaleController.value.entry(0, 0),
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: canvasWidth, height: canvasHeight),
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
                            updateDragPosition, deleteTransition, _scale),
                        state.endPoint.available
                            ? EndBlock(
                                state.endPoint.key,
                                state.endPoint,
                                updateEndPosition,
                                deleteState,
                                addConnection(state.endPoint.key, true),
                                _scale)
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
                              updateDragPosition,
                              _scale),
                        for (var block in state.blocks)
                          DraggableBlock(
                              block,
                              updateStateName,
                              deleteState,
                              updateBlockPosition,
                              updateDragPosition,
                              addConnection(block.key, false),
                              _scale),
                      ],
                    );
                  },
                  onWillAccept: (data) {
                    return (data! as DragData).newBlock;
                  },
                  onAcceptWithDetails: (drag) {
                    RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    DragData data = drag.data as DragData;
                    StateSettings settings = StateSettings(
                        AppLocalizations.of(context)!.json(data.name),
                        data.selectedOption,
                        null,
                        ("function_" +
                                state.blocks.length.toString() +
                                "_" +
                                data.name)
                            .replaceAll(" ", "_"));
                    StateData blockData = returnDataByNameAndOption(
                        data.name, data.selectedOption);
                    Key key = UniqueKey();
                    state.addBlock(
                      PositionedState(
                          key,
                          settings,
                          blockData,
                          (renderBox.globalToLocal(drag.offset +
                                  Offset(
                                      -_scaleController.value
                                          .getTranslation()
                                          .x,
                                      -_scaleController.value
                                          .getTranslation()
                                          .y)) *
                              (1 / _scale)),
                          false),
                    );
                  },
                ),
              ),
            ),
            ScaleButtons(setScale: setScale),
          ],
        );
      },
    );
  }
}
