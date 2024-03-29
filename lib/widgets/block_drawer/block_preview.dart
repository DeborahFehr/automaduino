import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../resources/settings.dart';

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
          image: AssetImage(imagePath),
          scale: 2,
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
        color: Color.fromRGBO(255, 255, 255, .7),
        shadowColor: color,
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 10, 0, 3),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.json(name),
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
                        AppLocalizations.of(context)!.json(option),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    button
                        ? Tooltip(
                      message: AppLocalizations.of(context)!.openDocs,
                            child: IconButton(
                              splashRadius: 15,
                              splashColor: color,
                              onPressed: () => {
                                launch(Localizations.localeOf(context)
                                            .languageCode ==
                                        'de'
                                    ? baseURL + '/de' + link
                                    : baseURL + link)
                              },
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
