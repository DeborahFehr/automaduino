import 'package:arduino_statemachines/resources/canvas_layout.dart';
import 'package:flutter/material.dart';
import '../../resources/state.dart';
import '../../resources/transition.dart';
import 'condition_field.dart';
import 'add_connection_button.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../resources/automaduino_state.dart';

class DraggableCondition extends StatefulWidget {
  final Key key;
  final Transition connection;
  final PositionedState? block;
  final Offset position;
  final Function(Transition connection, Offset position) updatePosition;
  final Function(Condition condition, {String? type, List<String>? values})
      updateConnectionDetails;
  final Function(Transition connection) deleteConnection;
  final Function(Transition connection, int position) deleteSingleCond;
  final Function(
          bool active, bool point, bool adition, Offset start, Offset end)
      updateDrag;
  final double scale;

  DraggableCondition(
      this.key,
      this.connection,
      this.block,
      this.position,
      this.updatePosition,
      this.updateConnectionDetails,
      this.deleteConnection,
      this.deleteSingleCond,
      this.updateDrag,
      this.scale);

  @override
  State<StatefulWidget> createState() {
    return _ConditionField();
  }
}

class _ConditionField extends State<DraggableCondition> {
  void test(Transition connection, Offset position) {}

  List<String> values = [];
  Widget conditionField = Container();

  void addCondValue() {
    setState(() {
      values.add("");
    });
  }

  void deleteCondValue(int position) {
    //widget.deleteSingleCond(widget.connection, position);
    setState(() {
      values.removeAt(position);
      if (widget.connection.end.length >= values.length) {
        widget.connection.end.removeAt(position);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    values = widget.connection.condition.values;
    conditionField = ConditionField(
        widget.connection.condition,
        widget.block!.settings.selectedOption == "sendWave"
            ? "sendWave"
            : widget.block!.data.type,
        test,
        widget.updateConnectionDetails,
        addCondValue,
        deleteCondValue,
        widget.connection.end.length >= values.length);

    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: ContextMenuArea(
        width: 250,
        items: [
          ListTile(
            leading: Icon(Icons.highlight_remove),
            title: Text(AppLocalizations.of(context)!.deleteTransition),
            onTap: () {
              widget.deleteConnection(widget.connection);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.lightbulb),
            title: Text(AppLocalizations.of(context)!.highlightTransition),
            onTap: () {
              Provider.of<AutomaduinoState>(context, listen: false)
                  .setHighlight(
                      "states",
                      Provider.of<AutomaduinoState>(context, listen: false)
                          .getVariableName(widget.connection.start),
                      type: "transition");
              Navigator.of(context).pop();
            },
          ),
        ],
        child: Draggable(
            data: DragData(null, "", "then", false, false, false, false),
            child: widget.connection.condition.type == "ifelse"
                ? Row(
                    children: [
                      conditionField,
                      widget.connection.end.length > 1
                          ? SizedBox.shrink()
                          : Column(
                              children: [
                                SizedBox(height: 30),
                                AddConnectionButton(
                                    widget.connection.start,
                                    widget.block?.settings.selectedOption ?? "",
                                    false,
                                    true,
                                    widget.connection.position,
                                    widget.updateDrag),
                              ],
                            ),
                    ],
                  )
                : widget.connection.condition.type == "cond"
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          conditionField,
                          Column(
                            children: [
                              SizedBox(height: 10),
                              for (int i = 0; i < values.length; i++)
                                (widget.connection.end.length !=
                                            values.length) &&
                                        i == values.length - 1
                                    ? AddConnectionButton(
                                    widget.connection.start,
                                        widget.block?.settings.selectedOption ??
                                            "",
                                        false,
                                        true,
                                        widget.connection.position,
                                        widget.updateDrag)
                                    : SizedBox(
                                        height: 20,
                                      ),
                            ],
                          ),
                        ],
                      )
                    : conditionField,
            feedback:
                Transform.scale(scale: widget.scale, child: conditionField),
            childWhenDragging: Container(),
            onDragUpdate: (details) {
              widget.updatePosition(
                  widget.connection, details.delta * (1 / widget.scale));
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
