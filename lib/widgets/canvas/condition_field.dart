import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../resources/transition.dart';

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
  String dropdownValue = 'then';
  List<String> items =
      conditionType.values.map((e) => describeEnum(e)).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
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
                    const TextStyle(color: Colors.deepPurple, fontSize: 12.0),
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
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    labelText: 'Condition',
                  ),
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                  onChanged: (text) {
                    widget.updateConnectionDetails(widget.condition,
                        values: [text]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
