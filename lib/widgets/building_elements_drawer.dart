import 'package:flutter/material.dart';
import '../resources/building_blocks.dart';

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
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                flexibleSpace: new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    new TabBar(
                      tabs: [
                        new Tab(icon: new Icon(Icons.lightbulb_outline)),
                        new Tab(icon: new Icon(Icons.lock_outlined)),
                      ],
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: elementalBlocks.length,
                    itemBuilder: (BuildContext context, int index) {
                      Widget buildingBlock = BuildingBlock(
                          elementalBlocks[index].name,
                          elementalBlocks[index].color as Color);
                      return Column(
                        children: [
                          Container(height: 5),
                          Draggable(
                            data: elementalBlocks[index],
                            child: buildingBlock,
                            feedback: buildingBlock,
                            childWhenDragging: buildingBlock,
                          ),
                        ],
                      );
                    },
                  ),
                  Text("More blocks coming soon!"),
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

/*
    Draggable(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
            ),
            feedback: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
            ),
            childWhenDragging: Container(),
          ),
 */
