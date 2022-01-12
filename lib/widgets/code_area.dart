import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'code_area/code_editor.dart';

class CodeArea extends StatefulWidget {
  final double closedWidth;
  Function(bool closed) updateWidth;

  CodeArea({Key? key, required this.closedWidth, required this.updateWidth})
      : super(key: key);

  @override
  _CodeAreaState createState() => _CodeAreaState();
}

class _CodeAreaState extends State<CodeArea> {
  double _width = 0;
  Color _color = Colors.green;
  bool closed = false;

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
              CodeEditor(),
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
