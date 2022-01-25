import 'package:flutter/material.dart';
import 'code_area/code_editor.dart';
import '../resources/transition.dart';
import '../resources/code_generator.dart';

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
  String code = "";
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    CodeGenerator codeGenerator = new CodeGenerator(null, widget.connections);
    code = codeGenerator.getCode();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    CodeGenerator codeGenerator = new CodeGenerator(null, widget.connections);
    code = codeGenerator.getCode();
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
          child: Stack(
            children: [
              Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: CodeEditor(code: code),
                ),
              ),
              SizedBox(
// ToDo: Alternate: Use Button Theme?

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
                              'C\no\nd\ne\n \nE\nd\ni\nt\no\nr',
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
                                  message: 'Copy Code',
                                  child: Container(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    child: IconButton(
                                      splashRadius: 15,
                                      splashColor:
                                          Theme.of(context).colorScheme.primary,
                                      color: Colors.white,
                                      onPressed: () => {print("Need to copy")},
                                      icon: Icon(Icons.open_in_new),
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
                            child: Text('>'),
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
              ),
            ],
          ),
        ));
  }
}
