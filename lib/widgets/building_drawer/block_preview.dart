import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BlockPreview extends StatelessWidget {
  final String name;
  final Color color;
  final bool button;

  const BlockPreview(this.name, this.color, this.button);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: color,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 14.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Icon(Icons.sentiment_very_satisfied_outlined),
            ),
            Expanded(
              child: button
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Tooltip(
                        message: 'Open Documentation',
                        child: IconButton(
                          onPressed: () =>
                              {launch('https://automaduino-docs.vercel.app/')},
                          icon: Icon(Icons.open_in_new),
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
