import 'package:arduino_statemachines/resources/building_blocks.dart';
import 'package:flutter/material.dart';

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
  double width = 100.0, height = 100.0;
  Offset position = Offset(0.0, 80);

  @override
  void initState() {
    super.initState();
    position = Offset(0.0, height - 20);
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (BuildContext context, List<dynamic> candidateData,
          List<dynamic> rejectedData) {
        return Stack(
          children: <Widget>[
            Positioned(
              left: position.dx,
              top: position.dy,
              child: Draggable(
                  data: [false, 'test'],
                  child: BuildingBlock1('test'),
                  feedback: BuildingBlock1('test'),
                  childWhenDragging: Container(),
                  onDragEnd: (details) {
                    RenderBox renderBox = context.findRenderObject() as RenderBox;
                    setState(
                            () => position = renderBox.globalToLocal(details.offset));
                  }),
            ),
          ],
        );
      },
      onWillAccept: (data) {
        return (data! as List)[0];
      },
      onAccept: (data) {
        // ToDo: Create new item
      },
    );


  }
}
