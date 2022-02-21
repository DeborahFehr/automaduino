import 'package:arduino_statemachines/widgets/code_area/line_numbers.dart';
import 'package:flutter/material.dart';
import 'init_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../resources/automaduino_state.dart';
import '../../resources/settings.dart';
import 'editor_highlighter.dart';
import '../../resources/code_map.dart';

class CodeEditor extends StatefulWidget {
  final CodeMap? map;
  final String code;
  final bool closed;
  final String? highlight;

  CodeEditor(
      {Key? key,
      required this.map,
      required this.code,
      required this.closed,
      required this.highlight})
      : super(key: key);

  @override
  _CodeEditorState createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  GlobalKey textFieldKey = GlobalKey();
  Map<String, TextStyle> highlighter = {...syntaxHighlighter};
  late EditorHighlighter codeController;
  List<int> lineHeights = List<int>.filled(9, 1, growable: true);
  int highlightLine = 0;

  int highlightedLine() {
    return codeController.selection.end < 0
        ? -1
        : RegExp(r"(\n)")
            .allMatches(
                codeController.text.substring(0, codeController.selection.end))
            .length;
  }

  // https://stackoverflow.com/questions/52659759/how-can-i-get-the-size-of-the-text-widget-in-flutter
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  void lineHeightsUpdater() {
    double textFieldWidth = (textFieldKey.currentContext!
            .findRenderObject()!
            .constraints as BoxConstraints)
        .constrainWidth();
    lineHeights.clear();
    List<String> parts = codeController.text.split(RegExp(r"(\n)"));
    for (int i = 0; i < parts.length; i++) {
      lineHeights.add(
          (_textSize(parts[i], codeEditorStyle).width / (textFieldWidth - 10))
                  .floor() +
              1);
    }
  }

  void lineUpdater() {
    lineHeightsUpdater();
    clearHighlight();
    setState(() {
      highlightLine = highlightedLine() + 1;
    });
  }

  void clearHighlight() {
    highlighter.clear();
    highlighter.addAll({...syntaxHighlighter});
  }

  void updateHighlight(String part) {
    highlighter.clear();
    if (part != "") {
      highlighter[part] = TextStyle(backgroundColor: arduinoSelection);
    }
    highlighter.addAll({...syntaxHighlighter});
    codeController.updateMap(highlighter);
  }

  @override
  void initState() {
    super.initState();
    codeController = EditorHighlighter(highlighter);
    codeController.text = widget.code;
    codeController.addListener(lineUpdater);
  }

  @override
  void didUpdateWidget(CodeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.code != oldWidget.code) {
      codeController.text = widget.code;
      clearHighlight();
    }
    if (widget.highlight != oldWidget.highlight) {
      updateHighlight(widget.highlight!);
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.closed) {
      WidgetsBinding.instance!
          .addPostFrameCallback((_) => lineHeightsUpdater());
    }
    return Container(
      margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          border: new Border.all(color: Colors.grey), color: Colors.white),
      child: Column(children: [
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.secondary,
          child: Align(
            alignment: Alignment.centerRight,
            child: PopupMenuButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 1:
                      showDialog(
                          context: context, builder: (_) => InitDialog());
                      break;
                    case 2:
                      Clipboard.setData(
                          ClipboardData(text: codeController.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text(AppLocalizations.of(context)!.codeCopied),
                        ),
                      );
                      break;
                    case 3:
                      Provider.of<AutomaduinoState>(context, listen: false)
                          .showEndPoint();
                      break;
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text(AppLocalizations.of(context)!.initPins),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: Text(AppLocalizations.of(context)!.copyCode),
                        value: 2,
                      ),
                      PopupMenuItem(
                        child: Text(AppLocalizations.of(context)!.showEnd),
                        value: 3,
                      )
                    ]),
          ),
        ),
        IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).colorScheme.secondary)),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              LineNumbers(
                  _textSize(codeController.text, codeEditorStyle).height,
                  lineHeights,
                  highlightLine),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 0),
                  child: TextField(
                    key: textFieldKey,
                    style: codeEditorStyle,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 10,
                    controller: codeController,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
