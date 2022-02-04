import 'package:arduino_statemachines/resources/state.dart';
import 'package:flutter/material.dart';
import '../../resources/state.dart';
import 'add_connection_button.dart';
import 'package:contextmenu/contextmenu.dart';

class StartBlock extends StatelessWidget {
  final StartData startPoint;
  final Function(StartData position, Offset delta) updatePosition;
  final Function(bool active, bool point, Offset start, Offset end) updateDrag;

  const StartBlock(this.startPoint, this.updatePosition, this.updateDrag);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: startPoint.position.dx,
      top: startPoint.position.dy,
      child: ContextMenuArea(
        width: 250,
        items: [
          ListTile(
            leading: Icon(Icons.highlight_remove),
            title: Text('Delete Transition'),
            onTap: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Foo!'),
                ),
              );
            },
          ),
        ],
        child: Draggable(
            data: StateSettings("", "", null, false, true, false, key, ""),
            child: Column(
              children: [
                Text(
                  "Start",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: 25,
                  height: 25,
                  decoration: const ShapeDecoration(
                    color: Colors.black,
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    Icons.play_arrow_outlined,
                    size: 20.0,
                    color: Colors.white,
                  ),
                ),
                startPoint.connected
                    ? Container()
                    : AddConnectionButton(
                        startPoint.key, true, startPoint.position, updateDrag),
              ],
            ),
            feedback: Column(
              children: [
                Text(
                  "Start",
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    color: Colors.black,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: 25,
                  height: 25,
                  decoration: const ShapeDecoration(
                    color: Colors.black,
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    Icons.play_arrow_outlined,
                    size: 20.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            childWhenDragging: Container(),
            onDragUpdate: (details) {
              updatePosition(startPoint, details.delta);
            },
            onDragEnd: (details) {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              updatePosition(
                  startPoint, renderBox.globalToLocal(details.offset));
            }),
      ),
    );
  }
}
