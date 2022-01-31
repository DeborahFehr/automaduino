import 'package:flutter/material.dart';

class InitDialogue extends StatefulWidget {
  InitDialogue({Key? key}) : super(key: key);

  @override
  _InitDialogueState createState() => _InitDialogueState();
}

class _InitDialogueState extends State<InitDialogue> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Init Ports'),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(
              columnWidths: {
                0: FlexColumnWidth(10),
                1: FlexColumnWidth(10),
                2: FlexColumnWidth(5)
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
                    Text("Name"),
                    Text("Type"),
                    Text("Port"),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    Text("test"),
                    Text("Sensor"),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Ports successfully initiated!')),
                    );
                    Navigator.pop(context, "Add content here");
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
