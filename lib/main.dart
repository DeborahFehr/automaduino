import 'package:flutter/material.dart';
import 'widgets/building_elements_drawer.dart';
import 'package:multi_split_view/multi_split_view.dart';
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
  bool _closedDrawer = false;
  double _width = 0;
  double _weightCodeArea = 0.5;


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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: [

          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: BuildingElementsDrawer(
                  updateWidth: updateDrawerWidth),
            ),
          ),
          Expanded(
            flex: _closedDrawer ? 24 : 5,
            child: Container(
              child:MultiSplitView(
                children: [
                  BuildingArea(elements: [],),
                  CodeArea(closedWidth: _width * 0.05, updateWidth: updateSplitWidth,)
                ],
                minimalWeight: 0.2,
                controller: MultiSplitViewController(weights: [1 - _weightCodeArea, _weightCodeArea]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
