import 'dart:ui';
import 'package:flutter/material.dart';
import 'widgets/block_drawer.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'widgets/canvas.dart';
import 'widgets/code_area.dart';
import '../resources/automaduino_state.dart';
import 'package:provider/provider.dart';
import '../resources/color_map.dart';
import '../resources/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/main/menu_drawer.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AutomaduinoState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = window.locale;

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Automaduino Editor',
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(0xff19969C, primaryColor),
          accentColor: MaterialColor(0xff15787d, secondaryColor),
        ),
        fontFamily: 'Open Sans',
        textTheme: const TextTheme(
            //headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            //headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            ),
      ),
      home: MyHomePage(title: 'Automaduino Editor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title = ""}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _closedDrawer = false;
  double _width = 0;
  double _weightCodeArea = 0.5;

  @override
  void initState() {
    super.initState();
  }

  void updateDrawerWidth(bool closedDrawer) {
    _closedDrawer = closedDrawer;
    setState(() {});
  }

  void updateSplitWidth(bool closedDrawer) {
    closedDrawer ? _weightCodeArea = 0.5 : _weightCodeArea = 0.04;
    setState(() {});
  }

  void changeLocale(String languageCode) {
    MyApp.of(context)
        ?.setLocale(Locale.fromSubtags(languageCode: languageCode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset('graphics/logo_icon.png', fit: BoxFit.contain),
        ),
        title: Text(
          AppLocalizations.of(context)!.automaduinoEditor,
          style: TextStyle(
              fontFamily: 'Glacial Indifference', fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: MenuDrawer(
        changeLocale: changeLocale,
      ),
      endDrawerEnableOpenDragGesture: false,
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: BuildingElementsDrawer(updateWidth: updateDrawerWidth),
            ),
          ),
          Expanded(
            flex: _closedDrawer ? 24 : 5,
            child: Container(
              child: MultiSplitView(
                children: [
                  BuildingArea(),
                  CodeArea(
                    closedWidth: _width * 0.04,
                    updateWidth: updateSplitWidth,
                  )
                ],
                minimalWeight: 0.2,
                onSizeChange: (prev, curr) {},
                controller: MultiSplitViewController(
                    weights: [1 - _weightCodeArea, _weightCodeArea]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
