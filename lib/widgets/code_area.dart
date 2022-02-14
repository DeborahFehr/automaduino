import 'package:flutter/material.dart';
import 'code_area/code_editor.dart';
import '../resources/transition.dart';
import 'code_area/init_dialog.dart';
import '../resources/code_transpiler.dart';
import '../../resources/code_map.dart';
import '../../resources/settings.dart';
import 'package:provider/provider.dart';
import '../resources/automaduino_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CodeArea extends StatefulWidget {
  final double closedWidth;
  final Function(bool closed) updateWidth;
  final List<Transition>? connections;

  CodeArea(
      {Key? key,
      required this.closedWidth,
      required this.updateWidth,
      this.connections})
      : super(key: key);

  @override
  _CodeAreaState createState() => _CodeAreaState();
}

class _CodeAreaState extends State<CodeArea> {
  double _width = 0;
  bool closed = false;
  ScrollController _scrollController = ScrollController();
  CodeMap? map;
  String code = getDefaultCode();
  bool pinWarning = false;

  CodeTranspiler codeTranspiler =
      new CodeTranspiler(null, null, null, null, null);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        width: _width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
        ),
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Consumer<AutomaduinoState>(builder: (context, state, child) {
            codeTranspiler = CodeTranspiler(state.blocks, state.connections,
                state.pinAssignments, state.startPoint, state.endPoint);
            map = codeTranspiler.getMap();
            String? highlight = "";
            if (map == null) {
              code = getDefaultCode();
            } else {
              code = map!.getCode();
              print(state.highlight);
              if (state.highlight != null) {
                highlight = codeTranspiler.map.returnHighlightString(
                    state.highlight!["mapName"],
                    state.highlight!["variableName"],
                    type: state.highlight!["type"]);
              }
              print(highlight);
            }
            pinWarning = Provider.of<AutomaduinoState>(context, listen: false)
                .unassignedPin();

            return Stack(
              children: [
                Scrollbar(
                  isAlwaysShown: true,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: CodeEditor(
                      map: map,
                      code: code,
                      pinWarning: pinWarning,
                      closed: closed,
                      highlight: highlight,
                    ),
                  ),
                ),
                SizedBox(
                  child: Stack(
                    children: [
                      IgnorePointer(
                        ignoring: true,
                        child: AnimatedOpacity(
                          opacity: closed ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 250),
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                AppLocalizations.of(context)!.codeEditor,
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            closed
                                ? Tooltip(
                              message:
                                        AppLocalizations.of(context)!.initPins,
                                    child: Container(
                                      color: pinWarning
                                          ? Colors.redAccent
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                      child: IconButton(
                                        splashRadius: 15,
                                        splashColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        color: Colors.white,
                                        onPressed: () => {
                                          showDialog(
                                              context: context,
                                              builder: (_) => InitDialog()),
                                        },
                                        icon: Icon(Icons.developer_board),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 1,
                                  ),
                            SizedBox(
                              height: 25,
                              width: 1,
                            ),
                            closed
                                ? Tooltip(
                              message:
                                        AppLocalizations.of(context)!.copyCode,
                                    child: Container(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      child: IconButton(
                                        splashRadius: 15,
                                        splashColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        color: Colors.white,
                                        onPressed: () {
                                          Clipboard.setData(
                                              ClipboardData(text: code));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  AppLocalizations.of(context)!
                                                      .codeCopied),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.content_copy),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 1,
                                  ),
                            SizedBox(
                              height: 25,
                              width: 1,
                            ),
                            TextButton(
                              child: Text(closed ? '<' : '>'),
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                elevation: 5,
                              ),
                              onPressed: () {
                                setState(() {
                                  _width = closed
                                      ? widget.closedWidth * 8
                                      : widget.closedWidth;
                                  widget.updateWidth(closed);
                                  closed = !closed;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
        ));
  }
}
