import 'package:arduino_statemachines/resources/canvas_layout.dart';
import 'package:arduino_statemachines/resources/state.dart';
import 'package:flutter/material.dart';
import '../../resources/state.dart';
import 'package:contextmenu/contextmenu.dart';

class EndBlock extends StatelessWidget {
  final Key key;
  final EndData endPoint;
  final Function(EndData position, Offset delta) updatePosition;
  final Function(PositionedState? state, {bool end}) hideEnd;
  final Function(Key target, bool startPoint, bool addition) addConnection;

  const EndBlock(this.key, this.endPoint, this.updatePosition, this.hideEnd,
      this.addConnection);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: endPoint.position.dx,
      top: endPoint.position.dy,
      child: ContextMenuArea(
        width: 250,
        items: [
          ListTile(
            leading: Icon(Icons.highlight_remove),
            title: Text('Delete State'),
            onTap: () {
              hideEnd(null, end: true);
              Navigator.of(context).pop();
            },
          ),
        ],
        child: Draggable(
            data: StateSettings(
                "", "", null, false, true, false, false, null, ""),
            child: DragTarget(builder: (BuildContext context,
                List<dynamic> candidateData, List<dynamic> rejectedData) {
              return DragTarget(
                builder: (context, List<dynamic> candidateData,
                    List<dynamic> rejectedData) {
                  return Column(
                    children: [
                      Text(
                        "End",
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
                          Icons.flag_outlined,
                          size: 18.0,
                          color: Colors.white,
                        ),
                      )
                    ],
                  );
                },
                onWillAccept: (candidate) {
                  StateSettings data = (candidate as StateSettings);
                  return !data.newBlock &&
                      data.newConnection &&
                      data.key != key &&
                      !data.startConnection;
                },
                onAccept: (data) {
                  addConnection((data as StateSettings).key as Key,
                      data.startConnection, data.additionalConnection);
                },
              );
            }),
            feedback: Column(
              children: [
                Text(
                  "End",
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
                    Icons.flag_outlined,
                    size: 18.0,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            childWhenDragging: Container(),
            onDragUpdate: (details) {
              updatePosition(endPoint, details.delta);
            },
            onDragEnd: (details) {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              updatePosition(endPoint, renderBox.globalToLocal(details.offset));
            }),
      ),
    );
  }
}
