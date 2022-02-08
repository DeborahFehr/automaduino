import 'package:flutter/material.dart';
import '../../resources/state.dart';
import '../../resources/transition.dart';
import 'condition_field.dart';
import 'add_connection_button.dart';
import 'package:contextmenu/contextmenu.dart';

class DraggableCondition extends StatefulWidget {
  final Key key;
  final Transition connection;
  final Offset position;
  final Function(Transition connection, Offset position) updatePosition;
  final Function(Condition condition, {String? type, List<String>? values})
      updateConnectionDetails;
  final Function(Transition connection) deleteConnection;
  final Function(
          bool active, bool point, bool adition, Offset start, Offset end)
      updateDrag;

  DraggableCondition(
      this.key,
      this.connection,
      this.position,
      this.updatePosition,
      this.updateConnectionDetails,
      this.deleteConnection,
      this.updateDrag);

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
      child: ContextMenuArea(
        width: 250,
        items: [
          ListTile(
            leading: Icon(Icons.highlight_remove),
            title: Text('Delete Transition'),
            onTap: () {
              widget.deleteConnection(widget.connection);
              Navigator.of(context).pop();
            },
          ),
        ],
        child: Draggable(
            data: StateSettings(
                "", "then", null, false, false, false, false, null, ""),
            child: widget.connection.condition.type == "ifelse"
                ? Row(
                    children: [
                      conditionField,
                      widget.connection.end.length > 1
                          ? SizedBox.shrink()
                          : Column(
                              children: [
                                SizedBox(height: 40),
                                AddConnectionButton(
                                    widget.connection.start,
                                    false,
                                    true,
                                    widget.connection.position,
                                    widget.updateDrag),
                              ],
                            ),
                    ],
                  )
                : conditionField,
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
      ),
    );
  }
}
