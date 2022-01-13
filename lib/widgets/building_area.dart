import 'package:arduino_statemachines/resources/building_blocks.dart';
import 'package:flutter/material.dart';
import '../resources/SupportClasses.dart';
import 'building_area/draggable_block.dart';
import 'building_area/line_painter.dart';

class BuildingArea extends StatefulWidget {
  final List elements;

  BuildingArea({Key? key, required this.elements}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BuildingAreaState();
  }
}

class _BuildingAreaState extends State<BuildingArea> {
  List<PositionedBlock> blocks = [
    PositionedBlock(UniqueKey(), BuildingBlock1('test'), Offset(0.0, 80)),
    PositionedBlock(UniqueKey(), BuildingBlock1('end'), Offset(200, 200))
  ];
  List<Connection> connections = [];

  // Connection(UniqueKey(), UniqueKey(), "test")
  bool drag = false;
  late Key dragKey;

  bool showButtons = true;

  @override
  void initState() {
    super.initState();
  }

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
      connections.add(Connection(start, end, "test"));
      print(connections.toString());
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
    return DragTarget(
      builder: (BuildContext context, List<dynamic> candidateData,
          List<dynamic> rejectedData) {
        return Stack(
          children: <Widget>[
            CustomPaint(
              painter: LinePainter(blocks, connections),
            ),
            drag
                ? Draggable(
                    data: [false, dragKey],
                    child: Icon(Icons.keyboard_arrow_down),
                    feedback: Icon(Icons.keyboard_arrow_down),
                    childWhenDragging: Container(),
                  )
                : Container(),
            for (var block in blocks)
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
        blocks.add(PositionedBlock(
            UniqueKey(),
            BuildingBlock1((drag.data! as List)[1]),
            renderBox.globalToLocal(drag.offset)));
        setState(() {});
      },
    );
  }
}
