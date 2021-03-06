import 'package:flutter/material.dart';
import 'package:split_view/split_view.dart';
import 'widgets/building_elements_drawer.dart';
import 'widgets/generated_code.dart';

// https://github.com/toshiaki-h/split_view/blob/master/lib/split_view.dart

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  void updateWidth() {
    // To Do: Think about a way to fix widths??
    // expanded: 1 : 4
    // not expanded: different ratio, e.g. 10%,
    // pass 10% width to widget?
    _flexSplitscreen = 25;
    setState(() {});
  }

  // Somehow update the weight
  //double updateSplitscreenWidth(bool expanded) {
//  return expanded ? 75.0 : 25.0;
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          // to do: fix Flex values
          Flexible(
            flex: _flexDrawer,
            child: BuildingElementsDrawer(flexWidth: 1,),
          ),
          Expanded(
            flex: _flexSplitscreen,
            child: SplitView(
              positionLimit: 50,
              // TO DO:
              // update weight with onWeightChanged?
              onWeightChanged: (double w) {
                print(w);
              },
              viewMode: SplitViewMode.Horizontal,
              view1: Container(
                child: Center(child: Text("View1")),
                color: Colors.red,
              ),
              view2: GeneratedCode(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateWidth();
        },
      ),
    );
  }
}
