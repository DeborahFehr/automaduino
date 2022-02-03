import 'package:flutter/material.dart';

class StateBlock extends StatefulWidget {
  String name;
  final Color color;
  final String imagePath;
  final String option;
  final int? pin;
  String selectedOption;
  final Function(String name, Widget block) updateName;

  StateBlock(this.name, this.color, this.imagePath, this.option, this.pin,
      this.selectedOption, this.updateName);

  @override
  State<StatefulWidget> createState() {
    return _StateBlock();
  }
}

class _StateBlock extends State<StateBlock> {
  TextEditingController _titleController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).scaffoldBackgroundColor,
        image: DecorationImage(
          image: AssetImage(widget.imagePath),
          scale: 2,
        ),
      ),
      child: Card(
        margin: EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: widget.color,
            width: 2,
          ),
        ),
        color: Color.fromRGBO(255, 255, 255, .7),
        shadowColor: widget.color,
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextField(
                controller: _titleController,
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  isDense: true,
                ),
                onChanged: (text) {
                  widget.updateName(
                      text,
                      StateBlock(
                          text,
                          widget.color,
                          widget.imagePath,
                          widget.option,
                          widget.pin,
                          widget.selectedOption,
                          widget.updateName));
                },
              ),
              Column(
                children: [
                  Container(
                    height: 20,
                    child: Text(
                      widget.option,
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                      height: 20,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Pin: " +
                              (widget.pin == null
                                  ? "unassigned"
                                  : widget.pin.toString()),
                          style: TextStyle(
                            fontSize: 11.0,
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
