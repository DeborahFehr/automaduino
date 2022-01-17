import 'package:flutter/material.dart';
import 'code_area/code_editor.dart';
import '../resources/support_classes.dart';
import '../resources/code_generator.dart';

class CodeArea extends StatefulWidget {
  final double closedWidth;
  final Function(bool closed) updateWidth;
  final List<Connection>? connections;

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
  Color _color = Colors.green;
  bool closed = false;
  String code = "";

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
          color: _color,
        ),
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Stack(
            children: [
              CodeEditor(code: code),
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
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: TextButton(
                        child: Text('>'),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.yellow,
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
