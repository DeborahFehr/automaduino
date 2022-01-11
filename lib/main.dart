import 'package:flutter/material.dart';
import 'widgets/building_elements_drawer.dart';
import 'widgets/splitscreen.dart';

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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  bool _closedDrawer = false;

  late AnimationController controller;
  late Animation drawerAnimation;

  @override
  void initState() {
    super.initState();
    controller =  AnimationController(vsync: this, duration: Duration(seconds: 1));
    drawerAnimation = Tween<double>(begin: 20.0, end: 5.0).animate(controller);
    // Rebuilding the screen when animation goes ahead
    controller.addListener(() {
      setState(() {});
    });
    controller.repeat(reverse: true);
  }

  void updateDrawerWidth(bool closedDrawer) {
    // todo smooth according to animation of drawer
    _closedDrawer = closedDrawer;
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
              child:SplitScreen(
                width: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
