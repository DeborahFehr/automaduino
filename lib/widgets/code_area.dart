import 'package:flutter/cupertino.dart';
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
import 'code_area/mode_menu.dart';
import 'code_area/pin_warning.dart';
import 'code_area/tooltip_button.dart';

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
  String mode = "functions";
  String? highlight = "";
  late CodeTranspiler codeTranspiler;

  void setMode(String newMode) {
    setState(() {
      mode = newMode;
    });
  }

  void copyCode() {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.codeCopied),
      ),
    );
  }

  void showPinDialog() {
    showDialog(context: context, builder: (_) => InitDialog());
  }

  void manageDrawer() {
    setState(() {
      _width = closed ? widget.closedWidth * 8 : widget.closedWidth;
      widget.updateWidth(closed);
      closed = !closed;
    });
  }

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
              state.pinAssignments, state.startPoint, state.endPoint, mode);
          map = codeTranspiler.getMap();
          if (map == null) {
            code = getDefaultCode();
          } else {
            code = map!.getCode(mode);
            if (state.highlight != null) {
              highlight = codeTranspiler.map.returnHighlightString(
                  state.highlight!["mapName"],
                  state.highlight!["variableName"],
                  mode,
                  type: state.highlight!["type"]);
            }
          }
          pinWarning = Provider.of<AutomaduinoState>(context, listen: false)
              .unassignedPin();

          return Stack(
            children: [
              Column(
                children: [
                  closed
                      ? SizedBox.shrink()
                      : ModeMenu(mode: mode, setMode: setMode),
                  pinWarning ? PinWarning() : SizedBox.shrink(),
                  Expanded(
                    child: Scrollbar(
                      isAlwaysShown: true,
                      controller: _scrollController,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: CodeEditor(
                          map: map,
                          code: code,
                          closed: closed,
                          highlight: highlight,
                        ),
                      ),
                    ),
                  ),
                ],
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
                              ? TooltipButton(
                                  message:
                                      AppLocalizations.of(context)!.initPins,
                                  icon: Icons.developer_board,
                                  background: pinWarning
                                      ? Colors.redAccent
                                      : Theme.of(context).colorScheme.primary,
                                  action: showPinDialog)
                              : SizedBox.shrink(),
                          SizedBox(
                            height: 25,
                          ),
                          closed
                              ? TooltipButton(
                                  message:
                                      AppLocalizations.of(context)!.copyCode,
                                  icon: Icons.content_copy,
                                  background:
                                      Theme.of(context).colorScheme.primary,
                                  action: copyCode)
                              : SizedBox.shrink(),
                          SizedBox(
                            height: 25,
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
                              manageDrawer();
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
      ),
    );
  }
}
