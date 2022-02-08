import 'package:flutter/material.dart';
import '../../resources/transition.dart';

class ConditionInput extends StatefulWidget {
  final String type;
  final Condition condition;
  final Function(Condition condition, {String? type, List<String>? values})
      updateConnectionDetails;

  ConditionInput(this.type, this.condition, this.updateConnectionDetails);

  @override
  State<StatefulWidget> createState() {
    return _ConditionField();
  }
}

class _ConditionField extends State<ConditionInput> {
  Widget child = Container();

  Widget addTextField(String hint) {
    return TextField(
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
        widget.updateConnectionDetails(widget.condition, values: [text]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case "if":
        {
          child = addTextField("test");
        }
        break;

      case "time":
        {
          child = addTextField("test 2");
        }
        break;

      case "ifelse":
        {
          child = Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [addTextField("test 2"), Text("else")],
          );
        }
        break;

      case "cond":
        {
          child = Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            print("i should be doin something??");
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                    width: 85.0,
                    child: addTextField("test 2"),
                  ),
                ],
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
                      onPressed: () {
                        print("i should be doin something??");
                      }),
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
