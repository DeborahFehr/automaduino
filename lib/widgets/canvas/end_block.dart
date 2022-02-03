import 'package:arduino_statemachines/resources/state.dart';
import 'package:flutter/material.dart';
import '../../resources/state.dart';

class EndBlock extends StatelessWidget {
  final Key key;
  final Offset blockPosition;
  final Function(Offset end) updatePosition;
  final Function(Key target, bool startPoint) addConnection;

  const EndBlock(
      this.key, this.blockPosition, this.updatePosition, this.addConnection);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: blockPosition.dx,
      top: blockPosition.dy,
      child: Draggable(
          data: StateSettings("", "", null, false, true, false, null, ""),
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
                addConnection(
                    (data as StateSettings).key as Key, data.startConnection);
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
          onDragEnd: (details) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            updatePosition(
                blockPosition + renderBox.globalToLocal(details.offset));
          }),
    );
  }
}
