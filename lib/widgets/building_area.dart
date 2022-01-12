import 'package:arduino_statemachines/resources/building_blocks.dart';
import 'package:flutter/material.dart';
import '../resources/positioned_block.dart';
import 'building_area/draggable_block.dart';

class BuildingArea extends StatefulWidget {
  final List elements;

  BuildingArea({Key? key, required this.elements}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BuildingAreaState();
  }
}

// ToDo: Zoom!
// https://stackoverflow.com/questions/65977699/how-to-create-a-movable-widget-in-flutter-such-that-is-stays-at-the-position-it

// ToDo: Drag stay in Area
// https://stackoverflow.com/questions/61969660/flutter-how-to-set-boundaries-for-a-draggable-widget

class _BuildingAreaState extends State<BuildingArea> {
  final _key = GlobalKey();
  Offset _position = Offset(0.0, 80);
  List<PositionedBlock> blocks = [PositionedBlock(BuildingBlock1('test'), Offset(0.0, 80))];

  @override
  void initState() {
    super.initState();
  }

  void updatePosition(PositionedBlock block, Offset position) {
    block.position = block.position + position;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (BuildContext context, List<dynamic> candidateData,
          List<dynamic> rejectedData) {
        return Stack(
          children: <Widget>[
            for (var block in blocks)
              DraggableBlock(block, updatePosition)
          ],
        );
      },
      onWillAccept: (data) {
        return (data! as List)[0];
      },
      onAcceptWithDetails: (drag) {
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        blocks.add(PositionedBlock(BuildingBlock1((drag.data! as List)[1]), renderBox.globalToLocal(drag.offset)));
        setState(() {

        });
      },
    );


  }
}
