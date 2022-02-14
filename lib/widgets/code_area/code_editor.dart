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
  final bool pinWarning;
  final bool closed;
  final String? highlight;

  CodeEditor(
      {Key? key,
      required this.map,
      required this.code,
      required this.pinWarning,
      required this.closed,
      required this.highlight})
      : super(key: key);

  @override
  _CodeEditorState createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  GlobalKey textFieldKey = GlobalKey();
  Map<String, TextStyle> highlighter = syntaxHighlighter;
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
    setState(() {
      highlightLine = highlightedLine() + 1;
    });
  }

  void updateHighlight(String part) {
    highlighter = syntaxHighlighter;
    if (widget.highlight != null) {
      highlighter[widget.highlight!] =
          TextStyle(backgroundColor: arduinoSelection);
      codeController.updateMap(highlighter);
    }
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
                  onPressed: () {
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

                    //FruitColorizer({
                    //  'loop': TextStyle(color: Colors.green, decoration: TextDecoration.underline),
                    //  'setup': TextStyle(color: Colors.orange, shadows: kElevationToShadow[2]),
                    //               }),//
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
