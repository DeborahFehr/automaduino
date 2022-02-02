import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../resources/syntax_Highlighter.dart';
import '../../resources/automaduino_state.dart';
import '../../resources/code_transpiler.dart';
import 'init_dialogue.dart';

class CodeEditor extends StatefulWidget {
  final bool pinWarning;

  CodeEditor({Key? key, required this.pinWarning}) : super(key: key);

  @override
  _CodeEditorState createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  var codeController = TextEditingController();
  var numberLines = 35;
  CodeTranspiler codeGenerator = new CodeTranspiler(null, null, null);

  void _countCodeLines() {
    numberLines = '\n'.allMatches(codeController.text).length + 1;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    codeController.text = codeGenerator.getCode();
    // ToDo: This throws an setstate during build error
    //codeController.addListener(_countCodeLines);
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          border: new Border.all(color: Colors.grey), color: Colors.white),
      child: Column(children: [
        /*
        widget.pinWarning
            ? Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Text("Warning! Not all pins are set"),
              )
            : Container(),
         */
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.secondary,
          child: Wrap(
            children: [
              ElevatedButton(
                  onPressed: () => {
                        showDialog(
                            context: context, builder: (_) => InitDialogue()),
                      },
                  child: Text("Init Ports")),
              ElevatedButton(onPressed: () => {}, child: Text("Copy"))
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
              child: Consumer<AutomaduinoState>(
                builder: (context, state, child) {
                  codeGenerator = CodeTranspiler(
                      state.blocks, state.connections, state.pinAssignments);
                  codeController.text = codeGenerator.getCode();
                  return TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 10,
                      controller: codeController);
                },
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
