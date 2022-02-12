import 'package:flutter/material.dart';
import 'init_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../resources/automaduino_state.dart';

class CodeEditor extends StatefulWidget {
  final String code;
  final bool pinWarning;

  CodeEditor({Key? key, required this.code, required this.pinWarning})
      : super(key: key);

  @override
  _CodeEditorState createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  var codeController = TextEditingController();
  var numberLines = 35;

  @override
  void initState() {
    super.initState();
    codeController.text = widget.code;
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    codeController.text = widget.code;
    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          border: new Border.all(color: Colors.grey), color: Colors.white),
      child: Column(children: [
        widget.pinWarning
            ? Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Text(AppLocalizations.of(context)!.pinWarning),
              )
            : SizedBox.shrink(),
        widget.pinWarning ? SizedBox(height: 10) : SizedBox.shrink(),
        Container(
          color: Colors.grey[200],
          child: Row(
            children: [
              Expanded(
                child: Card(
                  color: Theme.of(context).colorScheme.primary,
                  child: InkWell(
                    onTap: () => {},
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.abridgedMode,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  color: Theme.of(context).colorScheme.secondary,
                  child: InkWell(
                    onTap: () => {},
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.functionsMode,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  color: Theme.of(context).colorScheme.secondary,
                  child: InkWell(
                    onTap: () => {},
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.switchMode,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: AppLocalizations.of(context)!.openDocs,
                child: IconButton(
                  splashRadius: 15,
                  onPressed: () => {
                    /*
                    launch(Localizations.localeOf(context)
                        .languageCode ==
                        'de'
                        ? baseURL + '/de' + link
                        : baseURL + link)
                        */
                  },
                  icon: Icon(Icons.open_in_new),
                ),
              )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.secondary,
          child: Wrap(
            children: [
              ElevatedButton(
                  onPressed: () => {
                        showDialog(
                            context: context, builder: (_) => InitDialog()),
                      },
                  child: Text(AppLocalizations.of(context)!.initPins)),
              ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: codeController.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.codeCopied),
                      ),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.copyCode)),
              ElevatedButton(
                  onPressed: Provider.of<AutomaduinoState>(context,
                              listen: false)
                          .endPoint
                          .available
                      ? null
                      : () =>
                          Provider.of<AutomaduinoState>(context, listen: false)
                              .showEndPoint(),
                  child: Text(AppLocalizations.of(context)!.showEnd,
                      style: TextStyle(
                        color: Colors.white,
                      ))),
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
