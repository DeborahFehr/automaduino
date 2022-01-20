import 'package:flutter/material.dart';
import '../resources/building_blocks.dart';
import 'building_drawer/block_listview.dart';

// TODO: Vertical Text
// https://stackoverflow.com/questions/58310795/flutter-vertical-text-widget

class BuildingElementsDrawer extends StatefulWidget {
  Function(bool closed) updateWidth;

  BuildingElementsDrawer({Key? key, required this.updateWidth})
      : super(key: key);

  @override
  _BuildingElementsDrawerState createState() => _BuildingElementsDrawerState();
}

class _BuildingElementsDrawerState extends State<BuildingElementsDrawer> {
  bool closed = false;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                flexibleSpace: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TabBar(
                      tabs: [
                        Tab(
                          child: Tooltip(
                            message: 'Input Sensors',
                            child: Icon(Icons.input),
                          ),
                        ),
                        Tab(
                            child: Tooltip(
                          message: 'User Input',
                          child: Icon(Icons.touch_app),
                        )),
                        Tab(
                            child: Tooltip(
                          message: 'Output',
                          child: Icon(Icons.lightbulb_outline),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  BlockListView(sensorBlocks),
                  BlockListView(userInputBlocks),
                  BlockListView(outputBlocks),
                ],
              ),
            ),
          ),
        ),
        Stack(
          children: [
            IgnorePointer(
              ignoring: true,
              child: AnimatedOpacity(
                opacity: closed ? 1.0 : 0.0,
                duration: Duration(milliseconds: 250),
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: Text('>'),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.yellow,
                  elevation: 5,
                ),
                onPressed: () {
                  setState(() {
                    closed = !closed;
                    widget.updateWidth(closed);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
