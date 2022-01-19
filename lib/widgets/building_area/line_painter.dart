import 'package:flutter/material.dart';
import '../../resources/support_classes.dart';

class LinePainter extends CustomPainter {
  final List<PositionedBlock> blocks;
  final List<Connection> connections;
  final DraggableConnection? dragLine;

  const LinePainter(this.blocks, this.connections, this.dragLine);

  @override
  void paint(Canvas canvas, Size size) {
    // ToDo: this should be dynamic
    Offset center = Offset(50, 50);

    Paint paint = Paint()
      ..color = Colors.black87
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    for (var con in connections) {
      // draw line to condition block
      Offset startPoint =
          blocks.firstWhere((el) => el.key == con.start).position + center;
      Offset endPoint = con.position + Offset(100, 50);
      canvas.drawLine(startPoint, endPoint, paint);

      // draw lines from condition block to end block[s]
      startPoint = con.position + Offset(100, 0);

      for (var end in con.end) {
        Offset endPoint =
            blocks.firstWhere((el) => el.key == end).position + center;
        canvas.drawLine(startPoint, endPoint, paint);
      }
    }

    paint = Paint()
      ..color = Colors.black26
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    if (dragLine != null) {
      canvas.drawLine(dragLine!.start + Offset(50, 100),
          dragLine!.end + Offset(50, 100), paint);
    }
  }

  @override
  bool shouldRepaint(LinePainter delegate) {
    return true;
  }
}
