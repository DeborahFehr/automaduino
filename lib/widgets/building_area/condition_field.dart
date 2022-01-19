import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../resources/support_classes.dart';

class ConditionField extends StatefulWidget {
  final Condition condition;
  final Function(Connection connection, Offset position) updateConditionType;
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
  String dropdownValue = 'iff';
  List<String> items =
      conditionType.values.map((e) => describeEnum(e)).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              DropdownButton<String>(
                value: dropdownValue,
                elevation: 16,
                underline: Container(
                  height: 2,
                  color: Colors.grey,
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
                    border: OutlineInputBorder(),
                    labelText: 'Condition',
                  ),
                  onChanged: (text) {
                    widget.updateConnectionDetails(widget.condition,
                        values: [text]);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
