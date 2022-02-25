import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../resources/settings.dart';
import 'package:url_launcher/url_launcher.dart';

class ModeMenu extends StatelessWidget {
  final String mode;
  final Function(String mode) setMode;

  ModeMenu({
    Key? key,
    required this.mode,
    required this.setMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Container(
        color: Colors.grey[200],
        child: Row(
          children: [
            Expanded(
              child: Card(
                color: mode == "functions"
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
                child: InkWell(
                  onTap: () {
                    setMode("functions");
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.functionsMode,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                color: mode == "abridged"
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
                child: InkWell(
                  onTap: () {
                    setMode("abridged");
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.abridgedMode,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                color: mode == "switch"
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
                child: InkWell(
                  onTap: () {
                    setMode("switch");
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.switchMode,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Tooltip(
              message: AppLocalizations.of(context)!.openDocs,
              child: IconButton(
                splashRadius: 15,
                onPressed: () {
                  launch(Localizations.localeOf(context).languageCode == 'de'
                      ? baseURL + '/de' + "/docs/concepts/code-style/"
                      : baseURL + "/docs/concepts/code-style/");
                },
                icon: Icon(Icons.open_in_new),
              ),
            )
          ],
        ),
      ),
    );
  }
}
