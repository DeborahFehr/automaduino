import 'package:flutter/material.dart';
import '../../resources/support_classes.dart';

class StateBlock extends StatefulWidget {
  final String name;
  final Color color;

  StateBlock(this.name, this.color);

  @override
  State<StatefulWidget> createState() {
    return _StateBlock();
  }
}

class _StateBlock extends State<StateBlock> {
  String dropdownValue = 'One';
  TextEditingController _titleController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: widget.color,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              child: Material(
                color: widget.color,
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                    isDense: true,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Icon(Icons.sentiment_very_satisfied_outlined),
            ),
            Expanded(
              child: Material(
                color: widget.color,
                child: DropdownButton<String>(
                  value: dropdownValue,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.black54,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['One', 'Two', 'Free', 'Four']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
