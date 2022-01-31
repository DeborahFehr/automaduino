import 'package:flutter/material.dart';
import 'init_chip.dart';
import '../../resources/pin_assignment.dart';
import '../../resources/automaduino_state.dart';
import 'package:provider/provider.dart';

class InitDialogue extends StatefulWidget {
  InitDialogue({Key? key}) : super(key: key);

  @override
  _InitDialogueState createState() => _InitDialogueState();
}

class _InitDialogueState extends State<InitDialogue> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AutomaduinoState>(builder: (context, state, child) {
      return Dialog(
        insetPadding: EdgeInsets.fromLTRB(150, 50, 150, 50),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Table(
                  columnWidths: {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(8),
                    2: FlexColumnWidth(10)
                  },
                  border: TableBorder(
                    horizontalInside: BorderSide(
                        width: 1,
                        color: Theme.of(context).colorScheme.secondary,
                        style: BorderStyle.solid),
                  ),
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        Center(child: Text("Port")),
                        Center(child: Text("Component")),
                        Center(child: Text("States")),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        DropdownButtonFormField(
                          value: 'One',
                          style: const TextStyle(fontSize: 12),
                          onChanged: (String? newValue) {
                            setState(() {
                              print("huhh");
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
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Center(
                            child: Text('Hello World'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: DragTarget(
                            builder: (context, List<dynamic> candidateData,
                                List<dynamic> rejectedData) {
                              return Chip(
                                elevation: 6.0,
                                avatar: CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Image(
                                      image: AssetImage(
                                          "graphics/state_icons/loudness-sensor.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                label: Text('Aaron Burr'),
                              );
                            },
                            onWillAccept: (data) {
                              return true;
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  label: Text('Add Component'),
                  icon: Icon(Icons.add),
                  onPressed: () {},
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Left to Assign:",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        children: [
                          InitChip("test", Colors.blue, "testimage"),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.grey),
                            onPressed: () {
                              Navigator.pop(context, null);
                            },
                            child: Text('Cancel'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Ports successfully initiated!')),
                                );
                                Navigator.pop(context, "Add content here");
                              }
                            },
                            child: Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
