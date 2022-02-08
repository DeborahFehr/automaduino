import 'package:flutter/material.dart';
import '../../resources/transition.dart';
import 'condition_input.dart';

class ConditionField extends StatefulWidget {
  final Condition condition;
  final Function(Transition connection, Offset position) updateConditionType;
  final Function(Condition condition, {String? type, List<String>? values})
      updateConnectionDetails;

  ConditionField(
      this.condition, this.updateConditionType, this.updateConnectionDetails);

  @override
  State<StatefulWidget> createState() {
    return _ConditionField();
  }
}

class _ConditionField extends State<ConditionField> {
  List<String> items = conditionTypes;

  @override
  Widget build(BuildContext context) {
    String dropdownValue = widget.condition.type;
    return Container(
      width: 200,
      height: dropdownValue == "cond"
          ? (widget.condition.values.length * 20) + 50
          : dropdownValue == "ifelse"
              ? 70
              : 50,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.deepPurple,
            width: 2,
          ),
        ),
        color: Colors.deepPurple.shade50,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              DropdownButton<String>(
                value: dropdownValue,
                elevation: 16,
                style:
                    const TextStyle(color: Colors.deepPurple, fontSize: 14.0),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  widget.updateConnectionDetails(widget.condition,
                      type: newValue);
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              VerticalDivider(
                width: 20,
                thickness: 2,
                indent: 0,
                endIndent: 0,
                color: Colors.grey,
              ),
              ConditionInput(dropdownValue, widget.condition,
                  widget.updateConnectionDetails)
            ],
          ),
        ),
      ),
    );
  }
}
