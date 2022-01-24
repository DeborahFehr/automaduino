import 'package:flutter/material.dart';

class StateBlock extends StatefulWidget {
  String name;
  final Color color;
  final String imagePath;
  final List<String> options;
  String selectedOption;
  final Function(String name, Widget block) updateName;
  final Function(String option, Widget block) updateOption;

  StateBlock(this.name, this.color, this.imagePath, this.options,
      this.selectedOption, this.updateName, this.updateOption);

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
        image: DecorationImage(
          image: AssetImage("graphics/state_icons/demo.png"),
          scale: 8,
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: widget.color,
            width: 2,
          ),
        ),
        color: Color.fromRGBO(255, 255, 255, .8),
        shadowColor: widget.color,
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 10, 5, 3),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                    isDense: true,
                  ),
                  onChanged: (text) {
                    widget.updateName(
                        text,
                        StateBlock(
                            text,
                            widget.color,
                            widget.imagePath,
                            widget.options,
                            widget.selectedOption,
                            widget.updateName,
                            widget.updateOption));
                  },
                ),
              ),
              Expanded(
                child: DropdownButton<String>(
                  value: widget.selectedOption,
                  isExpanded: true,
                  underline: Container(
                    height: 2,
                    color: Colors.black54,
                  ),
                  onChanged: (String? newValue) {
                    widget.updateName(
                        newValue.toString(),
                        StateBlock(
                            widget.name,
                            widget.color,
                            widget.imagePath,
                            widget.options,
                            newValue.toString(),
                            widget.updateName,
                            widget.updateOption));

                    //setState(() {
                    //  dropdownValue = newValue!;
                    //               });
                  },
                  items: widget.options
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
