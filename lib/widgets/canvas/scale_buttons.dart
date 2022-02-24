import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScaleButtons extends StatelessWidget {
  final Function(double scale) setScale;

  ScaleButtons({
    Key? key,
    required this.setScale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        height: 70,
        width: 30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Ink(
                width: 30,
                height: 30,
                decoration: ShapeDecoration(
                  color: Colors.grey,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 20,
                  icon: Icon(
                    Icons.add,
                    size: 20,
                  ),
                  color: Colors.white,
                  onPressed: () {
                    setScale(0.1);
                  },
                ),
              ),
            ),
            Center(
              child: Ink(
                width: 30,
                height: 30,
                decoration: ShapeDecoration(
                  color: Colors.grey,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 20,
                  icon: Icon(
                    Icons.remove,
                    size: 20,
                  ),
                  color: Colors.white,
                  onPressed: () {
                    setScale(-0.1);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
