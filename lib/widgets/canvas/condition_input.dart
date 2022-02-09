import 'package:flutter/material.dart';
import '../../resources/transition.dart';

class ConditionInput extends StatefulWidget {
  final Condition condition;
  final Function(Condition condition, {String? type, List<String>? values})
      updateConnectionDetails;
  final Function() addCondValue;
  final Function(int position) deleteCondValue;
  final bool condButtonActive;

  ConditionInput(this.condition, this.updateConnectionDetails,
      this.addCondValue, this.deleteCondValue, this.condButtonActive);

  @override
  State<StatefulWidget> createState() {
    return _ConditionField();
  }
}

class _ConditionField extends State<ConditionInput> {
  Widget child = Container();

  Widget addTextField(String hint, String initialValue, int position) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: 1,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: Colors.deepPurple),
        labelText: hint,
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 8.0),
      ),
      style: TextStyle(
        fontSize: 12.0,
      ),
      onChanged: (text) {
        widget.condition.values[position] = text;
        widget.updateConnectionDetails(widget.condition, values: widget.condition.values);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.condition.type) {
      case "if":
        {
          child = addTextField("Enter Value", widget.condition.values.first, 0);
        }
        break;

      case "time":
        {
          child = addTextField("Delay in ms", widget.condition.values.first, 0);
        }
        break;

      case "ifelse":
        {
          child = Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [addTextField("Enter Value", widget.condition.values.first, 0), Text("else")],
          );
        }
        break;

      case "cond":
        {
          child = Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < widget.condition.values.length; i++)
                SizedBox(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 15.0,
                        width: 15.0,
                        child: Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.red,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              splashRadius: 10,
                              icon: Icon(Icons.highlight_remove, size: 15.0),
                              color: Colors.white,
                              onPressed: () {
                                widget.deleteCondValue(i);
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                        width: 85.0,
                        child: addTextField("Enter Value", widget.condition.values[i], i),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: 20.0,
                width: 20.0,
                child: Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.deepPurple,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      splashRadius: 15,
                      icon: Icon(Icons.add, size: 15.0),
                      color: Colors.white,
                      onPressed: widget.condButtonActive
                          ? () {
                              widget.addCondValue();
                            }
                          : null),
                ),
              ),
            ],
          );
        }
        break;

      default:
        {
          child = Text(
            "Go to next state",
            style: TextStyle(
              fontSize: 12.0,
            ),
          );
        }
        break;
    }

    return Flexible(child: child);
  }
}
