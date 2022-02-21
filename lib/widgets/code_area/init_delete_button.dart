import 'package:flutter/material.dart';

class InitDeleteButton extends StatelessWidget {
  final Function deleteAssigment;

  InitDeleteButton({
    required this.deleteAssigment,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Center(
        child: SizedBox(
          height: 20.0,
          width: 20.0,
          child: Ink(
            decoration: const ShapeDecoration(
              color: Colors.red,
              shape: CircleBorder(),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              splashRadius: 15,
              icon: Icon(Icons.highlight_remove, size: 15.0),
              color: Colors.white,
              onPressed: () {
                deleteAssigment();
              },
            ),
          ),
        ),
      ),
    );
  }
}
