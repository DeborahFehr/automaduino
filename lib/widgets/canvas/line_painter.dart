import 'package:flutter/material.dart';
import '../../resources/canvas_layout.dart';
import '../../resources/transition.dart';
import "dart:math" as math;

class LinePainter extends CustomPainter {
  final List<PositionedState> blocks;
  final List<Transition> connections;
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
      Offset endPoint = con.position + Offset(100, 25);
      canvas.drawLine(startPoint, endPoint, paint);

      // draw Arrow
      Offset midPoint = (startPoint + endPoint) / 2;
      double angle = (endPoint - startPoint).direction;
      canvas.drawLine(
          midPoint,
          midPoint -
              Offset(10 * math.cos(angle - (math.pi / 6)),
                  10 * math.sin(angle - (math.pi / 6))),
          paint);
      canvas.drawLine(
          midPoint,
          midPoint -
              Offset(10 * math.cos(angle + (math.pi / 6)),
                  10 * math.sin(angle + (math.pi / 6))),
          paint);

      // draw lines from condition block to end block[s]
      startPoint = con.position + Offset(100, 25);

      for (var end in con.end) {
        Offset endPoint =
            blocks.firstWhere((el) => el.key == end).position + center;
        canvas.drawLine(startPoint, endPoint, paint);

        Offset midPoint = (startPoint + endPoint) / 2;
        double angle = (endPoint - startPoint).direction;
        canvas.drawLine(
            midPoint,
            midPoint -
                Offset(10 * math.cos(angle - (math.pi / 6)),
                    10 * math.sin(angle - (math.pi / 6))),
            paint);
        canvas.drawLine(
            midPoint,
            midPoint -
                Offset(10 * math.cos(angle + (math.pi / 6)),
                    10 * math.sin(angle + (math.pi / 6))),
            paint);
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
