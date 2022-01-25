import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BlockPreview extends StatelessWidget {
  final String name;
  final Color color;
  final bool button;
  final String imagePath;
  final String option;
  final String link;

  const BlockPreview(this.name, this.color, this.button, this.imagePath,
      this.option, this.link);

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
            color: color,
            width: 2,
          ),
        ),
        color: Color.fromRGBO(255, 255, 255, .8),
        shadowColor: color,
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 10, 0, 3),
          child: Column(
            children: [
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 45,
                      child: Text(
                        option,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    button
                        ? Tooltip(
                            message: 'Open Documentation',
                            child: IconButton(
                              splashRadius: 15,
                              splashColor: color,
                              onPressed: () => {launch(link)},
                              icon: Icon(Icons.open_in_new),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
