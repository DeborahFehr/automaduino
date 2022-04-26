import 'package:arduino_statemachines/resources/canvas_layout.dart';
import 'package:arduino_statemachines/resources/settings.dart';
import 'package:flutter/material.dart';
import 'init_chip.dart';
import '../../resources/pin_assignment.dart';
import '../../resources/automaduino_state.dart';
import '../../resources/states_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'init_delete_button.dart';
import 'init_dropdown.dart';

class InitDialog extends StatefulWidget {
  InitDialog({Key? key}) : super(key: key);

  @override
  _InitDialogState createState() => _InitDialogState();
}

class _InitDialogState extends State<InitDialog> {
  final _formKey = GlobalKey<FormState>();

  final List<int> pinOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];

  final List<String> componentOptions =
      returnAllData().map((e) => e.component).toSet().toList();

  late List<PinAssignment> assignments;

  @override
  void initState() {
    super.initState();
    assignments = [
      ...Provider.of<AutomaduinoState>(context, listen: false).pinAssignments
    ];
  }

  Function deleteAssignment(
      PinAssignment assignment, List<PositionedState> blocks) {
    return () {
      setState(() {
        assignments.removeWhere((item) =>
            item.pin == assignment.pin &&
            item.component == assignment.component);
        blocks.forEach((block) {
          if (block.settings.pin == assignment.pin &&
              block.data.component == assignment.component) {
            block.settings.pin = null;
          }
        });
      });
    };
  }

  Function(dynamic comp) assignComponent(
      PinAssignment assignment, AutomaduinoState state) {
    return (dynamic comp) {
      for (var block in state.blocks.where((element) =>
          element.settings.pin == assignment.pin &&
          assignment.pin != null &&
          element.data.component == assignment.component))
        block.settings.pin = null;
      setState(() {
        assignment.component = comp;
      });
    };
  }

  Function(dynamic comp) assignPin(
      PinAssignment assignment, AutomaduinoState state) {
    return (dynamic pin) {
      for (var block in state.blocks.where((element) =>
          element.settings.pin == assignment.pin &&
          assignment.pin != null &&
          element.data.component == assignment.component))
        block.settings.pin = pin;
      setState(() {
        assignment.pin = pin;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AutomaduinoState>(builder: (context, state, child) {
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
                            1: FlexColumnWidth(3),
                            2: FlexColumnWidth(7),
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
                                Center(
                                    child: Text(
                                        AppLocalizations.of(context)!.pin)),
                                Center(
                                    child: Text(AppLocalizations.of(context)!
                                        .component)),
                                Center(
                                    child: Text(
                                        AppLocalizations.of(context)!.states)),
                              ],
                            ),
                            for (var assignment in assignments)
                              TableRow(
                                children: <Widget>[
                                  InitDeleteButton(
                                      deleteAssigment: deleteAssignment(
                                          assignment, state.blocks)),
                                  InitDropdown(
                                      value: assignment.pin,
                                      valueOnChanged:
                                          assignPin(assignment, state),
                                      options: pinOptions),
                                  InitDropdown(
                                      component: true,
                                      value: assignment.component,
                                      valueOnChanged:
                                          assignComponent(assignment, state),
                                      options: componentOptions),
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
                                                      getBlockColorByType(
                                                          block.data.type),
                                                      block.data.imagePath),
                                                  feedback: InitChip(
                                                      block.settings.name,
                                                      getBlockColorByType(
                                                          block.data.type),
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
                          label:
                              Text(AppLocalizations.of(context)!.addComponent),
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
                                    AppLocalizations.of(context)!.leftToAssign,
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
                                              getBlockColorByType(
                                                  block.data.type),
                                              block.data.imagePath),
                                          feedback: InitChip(
                                              block.settings.name,
                                              getBlockColorByType(
                                                  block.data.type),
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
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              for (int i = 0; i < assignments.length; i++) {
                                assignments[i].variableName =
                                    assignments[i].component == "servo"
                                        ? "servo_" + i.toString()
                                        : "pin_" +
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
                                );
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(AppLocalizations.of(context)!
                                        .pinsSuccessfullyInitiated)),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.submit),
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
