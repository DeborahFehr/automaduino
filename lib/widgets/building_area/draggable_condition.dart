import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../resources/support_classes.dart';
import 'condition_field.dart';

class DraggableCondition extends StatefulWidget {
  final Key key;
  final Connection connection;
  final Offset position;
  final Function(Connection connection, Offset position) updatePosition;
  final Function(Condition condition, {String? type, List<String>? values})
      updateConnectionDetails;

  DraggableCondition(this.key, this.connection, this.position,
      this.updatePosition, this.updateConnectionDetails);

  @override
  State<StatefulWidget> createState() {
    return _ConditionField();
  }
}

class _ConditionField extends State<DraggableCondition> {
  void test(Connection connection, Offset position) {}

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: Draggable(
          data: BlockData("", null, false, false, null),
          child: ConditionField(widget.connection.condition, test,
              widget.updateConnectionDetails),
          feedback: Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
            ),
          ),
          childWhenDragging: Container(),
          onDragUpdate: (details) {
            widget.updatePosition(widget.connection, details.delta);
          },
          onDragEnd: (details) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            widget.updatePosition(
                widget.connection, renderBox.globalToLocal(details.offset));
          }),
    );
  }
}
