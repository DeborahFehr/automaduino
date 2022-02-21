import 'package:arduino_statemachines/resources/image_sources.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SourcesDialog extends StatefulWidget {
  SourcesDialog({Key? key}) : super(key: key);

  @override
  _SourcesDialogState createState() => _SourcesDialogState();
}

class _SourcesDialogState extends State<SourcesDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.fromLTRB(150, 50, 150, 50),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(5),
                  },
                  border: TableBorder(
                    horizontalInside: BorderSide(
                        width: 1,
                        color: Theme.of(context).colorScheme.secondary,
                        style: BorderStyle.solid),
                    verticalInside: BorderSide(
                        width: 1,
                        color: Theme.of(context).colorScheme.secondary,
                        style: BorderStyle.solid),
                  ),
                  children: [
                    TableRow(children: [
                      TableCell(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.icon,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.use,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.source,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                    ]),
                    for (ImageSource image in images)
                      TableRow(children: [
                        TableCell(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Image(
                                width: 30,
                                height: 30,
                                image: AssetImage(image.imagePath),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text(AppLocalizations.of(context)!
                                  .json(image.title)),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: InkWell(
                              child: Text(image.url),
                              onTap: () {
                                launch(image.url);
                              },
                            ),
                          ),
                        ),
                      ]),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.close),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
