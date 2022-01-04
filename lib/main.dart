import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'widgets/building_elements_drawer.dart';
import 'widgets/building_area.dart';
import 'widgets/code_area.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Automaduino Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Automaduino Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _flexDrawer = 1;
  int _flexSplitscreen = 4;
  double _weightCodeArea = 0.5;

  // TODO replace split view
  // https://pub.dev/packages/multi_split_view
  // https://medium.com/@leonar.d/how-to-create-a-flutter-split-view-7e2ac700ea12

  void updateDrawerWidth(bool closedDrawer) {
    // todo smooth according to animation of drawer
    closedDrawer ? _flexSplitscreen = 4 : _flexSplitscreen = 19;
    setState(() {});
  }

  void updateSplitWidth(bool closedDrawer) {
    // todo smooth according to animation of drawer
    // maybe add another animated contrainer?
    closedDrawer ? _weightCodeArea = 0.5 : _weightCodeArea = 0.05;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          // todo: fix Flex values
          Flexible(
            flex: _flexDrawer,
            child: BuildingElementsDrawer(
                expandedWidth: width * 0.2, updateWidth: updateDrawerWidth),
          ),
          Expanded(
            flex: _flexSplitscreen,
            child: MultiSplitView(
                children: [
              BuildingArea(),
              CodeArea(closedWidth: width * 0.05, updateWidth: updateSplitWidth,)
            ],
                minimalWeight: 0.2,
                controller: MultiSplitViewController(weights: [1 - _weightCodeArea, _weightCodeArea]),
            ),
          ),
        ],
      ),
    );
  }
}
