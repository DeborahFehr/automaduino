import 'package:flutter/material.dart';
import '../resources/states_data.dart';
import 'block_drawer/block_listview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildingElementsDrawer extends StatefulWidget {
  final Function(bool closed) updateWidth;

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
        closed
            ? Container()
            : Padding(
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
                            message:
                                      AppLocalizations.of(context)!.sensors,
                                  child: Icon(Icons.input),
                                ),
                        ),
                        Tab(
                            child: Tooltip(
                              message:
                                    AppLocalizations.of(context)!.userInput,
                                child: Icon(Icons.touch_app),
                              )),
                        Tab(
                            child: Tooltip(
                              message: AppLocalizations.of(context)!.output,
                                child: Icon(Icons.lightbulb_outline),
                              )),
                      ],
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  BlockListView(
                      sensorBlocks, Colors.redAccent, ScrollController()),
                  BlockListView(
                      userInputBlocks, Colors.blueAccent, ScrollController()),
                  BlockListView(
                      outputBlocks, Colors.greenAccent, ScrollController()),
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
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      AppLocalizations.of(context)!.stateBlocks,
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: Text(closed ? '>' : '<'),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.primary,
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
