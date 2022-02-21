import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../resources/automaduino_state.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../resources/settings.dart';
import 'dialog_sources.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';

class MenuDrawer extends StatefulWidget {
  final Function(String locale) changeLocale;

  MenuDrawer({Key? key, required this.changeLocale}) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Image(image: AssetImage('graphics/logo.png')),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: DropdownButton<String>(
              isExpanded: true,
              underline: Container(
                height: 0,
              ),
              style: TextStyle(fontFamily: 'Open Sans', fontSize: 14),
              value: Localizations.localeOf(context).languageCode,
              items: ["en", "de"].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Image(
                              image: AssetImage(value == "de"
                                  ? 'graphics/german.png'
                                  : 'graphics/english.png')),
                          SizedBox(
                            width: 10,
                          ),
                          Text(value == "en"
                              ? AppLocalizations.of(context)!.english
                              : AppLocalizations.of(context)!.german),
                        ],
                      )),
                );
              }).toList(),
              onChanged: (String? languageCode) {
                widget.changeLocale(languageCode!);
              },
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.openDocs),
            onTap: () {
              launch(Localizations.localeOf(context).languageCode == 'de'
                  ? baseURL + '/de/docs/'
                  : baseURL + '/docs/');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.openWebsite),
            onTap: () {
              launch(Localizations.localeOf(context).languageCode == 'de'
                  ? baseURL + '/de/'
                  : baseURL);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.importData),
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['json'],
              );

              if (result != null) {
                Uint8List fileBytes = result.files.first.bytes!;
                final utf8Decoder = utf8.decoder;
                String json = utf8Decoder.convert(fileBytes);
                JsonDecoder decoder = JsonDecoder();
                Map<String, dynamic> map = decoder.convert(json);
                Provider.of<AutomaduinoState>(context, listen: false)
                    .mapToState(map);
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.exportData),
            onTap: () async {
              JsonUtf8Encoder encoder = JsonUtf8Encoder();
              Map<String, dynamic> test =
                  Provider.of<AutomaduinoState>(context, listen: false)
                      .stateToMap();

              List<int> jsonBytes = encoder.convert(test);
              Uint8List json = Uint8List.fromList(jsonBytes);
              MimeType type = MimeType.JSON;

              await FileSaver.instance
                  .saveFile("automaduino_state", json, "json", mimeType: type);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.resetEditor),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.resetEditor),
                    content:
                        Text(AppLocalizations.of(context)!.resetEditorWarning),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.grey),
                        child: Text(AppLocalizations.of(context)!.cancel),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        child: Text(AppLocalizations.of(context)!.reset),
                        onPressed: () {
                          Provider.of<AutomaduinoState>(context, listen: false)
                              .reset();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.imageSources),
            onTap: () {
              showDialog(context: context, builder: (_) => SourcesDialog());
            },
          ),
        ],
      ),
    );
  }
}
