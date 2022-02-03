import 'package:flutter/material.dart';
import '../../resources/state.dart';
import '../../resources/transition.dart';
import 'condition_field.dart';

class DraggableCondition extends StatefulWidget {
  final Key key;
  final Transition connection;
  final Offset position;
  final Function(Transition connection, Offset position) updatePosition;
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
  void test(Transition connection, Offset position) {}

  @override
  Widget build(BuildContext context) {
    Widget conditionField = ConditionField(
        widget.connection.condition, test, widget.updateConnectionDetails);
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: Draggable(
          data: StateSettings("", "then", null, false, false, false, null, ""),
          child: conditionField,
          feedback: conditionField,
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
