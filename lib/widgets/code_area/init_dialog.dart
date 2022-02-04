import 'package:arduino_statemachines/resources/canvas_layout.dart';
import 'package:flutter/material.dart';
import 'init_chip.dart';
import '../../resources/pin_assignment.dart';
import '../../resources/automaduino_state.dart';
import '../../resources/states_data.dart';
import 'package:provider/provider.dart';
import '../canvas/state_block.dart';

class InitDialog extends StatefulWidget {
  InitDialog({Key? key}) : super(key: key);

  @override
  _InitDialogState createState() => _InitDialogState();
}

/// This should srsly be refactored
class _InitDialogState extends State<InitDialog> {
  final _formKey = GlobalKey<FormState>();

  final List<int> pinOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];

  final List<String> componentOptions =
      returnAllData().map((e) => e.component).toSet().toList();

  List<PinAssignment> assignments = [];

  dynamic Function(String, Widget) updateStateName(Key key) {
    void update(String name, Widget block) {
      Provider.of<AutomaduinoState>(context, listen: false)
          .updateStateName(key, name, block);
    }

    return update;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AutomaduinoState>(builder: (context, state, child) {
      assignments = state.pinAssignments;
      return Dialog(
        insetPadding: EdgeInsets.fromLTRB(150, 50, 150, 50),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Table(
                          columnWidths: {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(7),
                            2: FlexColumnWidth(3),
                            3: FlexColumnWidth(9)
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
                                Container(),
                                Center(child: Text("Component")),
                                Center(child: Text("Pin")),
                                Center(child: Text("States")),
                              ],
                            ),
                            for (var assignment in assignments)
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Center(
                                      child: SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: Ink(
                                          decoration: const ShapeDecoration(
                                            color: Colors.red,
                                            shape: CircleBorder(),
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            splashRadius: 15,
                                            icon: Icon(Icons.highlight_remove,
                                                size: 15.0),
                                            color: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                assignments.removeWhere(
                                                    (item) =>
                                                        item.pin ==
                                                            assignment.pin &&
                                                        item.component ==
                                                            assignment
                                                                .component);
                                                state.blocks.forEach((block) {
                                                  if (block.settings.pin ==
                                                          assignment.pin &&
                                                      block.data.component ==
                                                          assignment
                                                              .component) {
                                                    block.settings.pin = null;
                                                  }
                                                });
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: DropdownButtonFormField(
                                      isExpanded: true,
                                      value: assignment.component,
                                      style: const TextStyle(fontSize: 12),
                                      onChanged: (dynamic comp) {
                                        setState(() {
                                          assignment.component = comp;
                                        });
                                      },
                                      validator: (dynamic value) {
                                        if (value == null) {
                                          return 'Field required';
                                        }
                                        return null;
                                      },
                                      items: componentOptions
                                          .map<DropdownMenuItem>(
                                              (String value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Center(
                                              child: Row(
                                            children: [
                                              Container(
                                                width: 25.0,
                                                height: 25.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: returnDataByName(value)
                                                              .type ==
                                                          "sensor"
                                                      ? Colors.redAccent
                                                      : returnDataByName(value)
                                                                  .type ==
                                                              "userInput"
                                                          ? Colors.blueAccent
                                                          : Colors.greenAccent,
                                                  image: DecorationImage(
                                                    fit: BoxFit.contain,
                                                    image: AssetImage(
                                                        returnDataByName(value)
                                                            .imagePath),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(value),
                                            ],
                                          )),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: DropdownButtonFormField(
                                      isExpanded: true,
                                      value: assignment.pin,
                                      style: const TextStyle(fontSize: 12),
                                      onChanged: (dynamic pin) {
                                        setState(() {
                                          assignment.pin = pin;
                                        });
                                      },
                                      validator: (dynamic value) {
                                        if (value == null) {
                                          return 'Field required';
                                        }
                                        return null;
                                      },
                                      items: pinOptions
                                          .map<DropdownMenuItem>((int value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Center(
                                            child: Text(
                                              value.toString(),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: DragTarget(
                                      builder: (context,
                                          List<dynamic> candidateData,
                                          List<dynamic> rejectedData) {
                                        return Container(
                                          color: Colors.grey[200],
                                          width: 100,
                                          height: 50,
                                          child: Wrap(
                                            children: [
                                              for (var block in state.blocks
                                                  .where((element) =>
                                                      element.settings.pin ==
                                                          assignment.pin &&
                                                      assignment.pin != null &&
                                                      element.data.component ==
                                                          assignment.component))
                                                Draggable(
                                                  data: block,
                                                  child: InitChip(
                                                      block.settings.name,
                                                      block.data.type ==
                                                              "sensor"
                                                          ? Colors.redAccent
                                                          : block.data.type ==
                                                                  "userInput"
                                                              ? Colors
                                                                  .blueAccent
                                                              : Colors
                                                                  .greenAccent,
                                                      block.data.imagePath),
                                                  feedback: InitChip(
                                                      block.settings.name,
                                                      block.data.type ==
                                                              "sensor"
                                                          ? Colors.redAccent
                                                          : block.data.type ==
                                                                  "userInput"
                                                              ? Colors
                                                                  .blueAccent
                                                              : Colors
                                                                  .greenAccent,
                                                      block.data.imagePath),
                                                  childWhenDragging:
                                                      Container(),
                                                ),
                                            ],
                                          ),
                                        );
                                      },
                                      onWillAccept: (data) {
                                        PositionedState block =
                                            (data as PositionedState);
                                        return assignment.component ==
                                            block.data.component;
                                      },
                                      onAccept: (data) {
                                        PositionedState block =
                                            (data as PositionedState);
                                        setState(() {
                                          block.settings.pin = assignment.pin;
                                        });
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
                          onPressed: () {
                            setState(() {
                              assignments.add(PinAssignment(null, null, null));
                            });
                          },
                        ),
                        DragTarget(
                          builder: (context, List<dynamic> candidateData,
                              List<dynamic> rejectedData) {
                            return Container(
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
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  SizedBox(height: 10),
                                  Wrap(
                                    children: [
                                      for (var block in state.blocks.where(
                                          (element) =>
                                              element.settings.pin == null))
                                        Draggable(
                                          data: block,
                                          child: InitChip(
                                              block.settings.name,
                                              block.data.type == "sensor"
                                                  ? Colors.redAccent
                                                  : block.data.type ==
                                                          "userInput"
                                                      ? Colors.blueAccent
                                                      : Colors.greenAccent,
                                              block.data.imagePath),
                                          feedback: InitChip(
                                              block.settings.name,
                                              block.data.type == "sensor"
                                                  ? Colors.redAccent
                                                  : block.data.type ==
                                                          "userInput"
                                                      ? Colors.blueAccent
                                                      : Colors.greenAccent,
                                              block.data.imagePath),
                                          childWhenDragging: Container(),
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                          onWillAccept: (data) {
                            return true;
                          },
                          onAccept: (data) {
                            PositionedState block = (data as PositionedState);
                            setState(() {
                              assignments.removeWhere((item) =>
                                  item.pin == block.settings.pin &&
                                  item.component == block.data.component);
                              block.settings.pin = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.grey),
                          onPressed: () {
                            Navigator.pop(context, null);
                          },
                          child: Text('Cancel'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              for (int i = 0; i < assignments.length; i++) {
                                assignments[i].variableName = "pin_" +
                                    i.toString() +
                                    "_" +
                                    assignments[i]
                                        .component!
                                        .replaceAll(" ", "_");
                              }

                              Provider.of<AutomaduinoState>(context,
                                      listen: false)
                                  .addPinList(assignments);
                              state.blocks.forEach((block) {
                                Provider.of<AutomaduinoState>(context,
                                        listen: false)
                                    .updatePin(
                                        block.key,
                                        block.settings.pin,
                                        StateBlock(
                                            block.settings.name,
                                            block.data.type == "sensor"
                                                ? Colors.redAccent
                                                : block.data.type == "userInput"
                                                    ? Colors.blueAccent
                                                    : Colors.greenAccent,
                                            block.data.imagePath,
                                            block.data.option,
                                            block.settings.pin,
                                            block.settings.selectedOption,
                                            updateStateName(block.key)));
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Pins successfully initiated!')),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ],
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
