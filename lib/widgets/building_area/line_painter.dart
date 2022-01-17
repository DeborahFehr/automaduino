import 'package:flutter/material.dart';
import '../../resources/support_classes.dart';

class LinePainter extends CustomPainter {
  final List<PositionedBlock> blocks;
  final List<Connection> connections;

  const LinePainter(this.blocks, this.connections);

  @override
  void paint(Canvas canvas, Size size) {
    // ToDo: this should be dynamic
    Offset center = Offset(50, 50);

    for (var con in connections) {
      Offset startPoint =
          blocks.firstWhere((el) => el.key == con.start).position + center;
      Offset endPoint =
          blocks.firstWhere((el) => el.key == con.end).position + center;
      Paint paint = Paint()
        ..color = Colors.black26
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 3;
      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(LinePainter delegate) {
    return true;
  }
}
