import 'package:flutter/material.dart';

class TooltipButton extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color background;
  final Function action;

  TooltipButton({
    required this.message,
    required this.icon,
    required this.background,
    required this.action,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: Container(
        color: background,
        child: IconButton(
          splashRadius: 15,
          splashColor: background,
          color: Colors.white,
          onPressed: () {
            action();
          },
          icon: Icon(icon),
        ),
      ),
    );
  }
}
