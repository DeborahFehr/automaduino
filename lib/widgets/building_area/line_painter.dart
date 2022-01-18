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
      Offset startPoint =
          blocks.firstWhere((el) => el.key == con.start).position + center;
      Offset endPoint =
          blocks.firstWhere((el) => el.key == con.end).position + center;
      canvas.drawLine(startPoint, endPoint, paint);
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
