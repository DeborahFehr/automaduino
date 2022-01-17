import 'package:flutter/material.dart';
import 'widgets/building_elements_drawer.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'widgets/building_area.dart';
import 'widgets/code_area.dart';
import '../resources/support_classes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StateModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Automaduino Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  List<PositionedBlock> blocks = [];
  List<Connection>? connections = null;

  void setConnections(List<Connection> update) {
    // todo smooth according to animation of drawer
    connections = update;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  void updateDrawerWidth(bool closedDrawer) {
    // todo smooth according to animation of drawer
    _closedDrawer = closedDrawer;
    setState(() {});
  }

  void updateSplitWidth(bool closedDrawer) {
    closedDrawer ? _weightCodeArea = 0.5 : _weightCodeArea = 0.05;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      endDrawerEnableOpenDragGesture: false,
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: BuildingElementsDrawer(updateWidth: updateDrawerWidth),
            ),
          ),
          Expanded(
            flex: _closedDrawer ? 24 : 5,
            child: Container(
              child: MultiSplitView(
                children: [
                  BuildingArea(
                    update: setConnections,
                  ),
                  CodeArea(
                    closedWidth: _width * 0.05,
                    updateWidth: updateSplitWidth,
                    connections: connections,
                  )
                ],
                minimalWeight: 0.2,
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
