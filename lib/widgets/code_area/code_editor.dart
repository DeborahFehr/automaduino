import 'package:flutter/material.dart';

import '../../resources/syntax_Highlighter.dart';

// TODO: add line numbers

class CodeEditor extends StatefulWidget {
  CodeEditor({Key? key}) : super(key: key);

  @override
  _CodeEditorState createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  var codeController = TextEditingController();
  var numberLines = 9;

  void _countCodeLines() {
    numberLines = '\n'.allMatches(codeController.text).length + 1;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    codeController.text = '''void setup() {
      // put your setup code here, to run once:

    }

    void loop() {
      // put your main code here, to run repeatedly:

    }''';

    // Start listening to changes.
    codeController.addListener(_countCodeLines);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          border: new Border.all(color: Colors.grey), color: Colors.white),
      child: Column(children: [
        Container(
          width: double.infinity,
          color: Colors.amber,
          child: Wrap(
            children: [
                  ElevatedButton(onPressed: () => {}, child: Text("test")),
                  ElevatedButton(onPressed: () => {}, child: Text("test")),
                  ElevatedButton(onPressed: () => {}, child: Text("test"))
                ],
          ),
        ),
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var i in List.generate(numberLines, (i) => i + 1))
                    Text(i.toString()),
                ],
              ),
            ),
            Expanded(
              child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 10,
                  controller: codeController),
            ),
          ]),
        ),
      ]),
    );
  }
}
