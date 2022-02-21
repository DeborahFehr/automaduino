import 'package:arduino_statemachines/resources/state.dart';
import 'package:flutter/material.dart';
import '../../resources/state.dart';
import '../../resources/canvas_layout.dart';
import '../../resources/transition.dart';
import 'add_connection_button.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../resources/automaduino_state.dart';

class StartBlock extends StatelessWidget {
  final StartData startPoint;
  final Function(StartData position, Offset delta, bool dragEnd) updatePosition;
  final Function(
          bool active, bool point, bool adition, Offset start, Offset end)
      updateDrag;
  final Function(Transition? connection, {bool start}) deleteConnection;
  final double scale;

  const StartBlock(this.startPoint, this.updatePosition, this.updateDrag,
      this.deleteConnection, this.scale);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: startPoint.position.dx,
      top: startPoint.position.dy,
      child: ContextMenuArea(
        width: 250,
        items: [
          !startPoint.connected
              ? SizedBox.shrink()
              : ListTile(
                  leading: Icon(Icons.highlight_remove),
                  title: Text(AppLocalizations.of(context)!.deleteTransition),
                  onTap: () {
                    deleteConnection(null, start: true);
                    Navigator.of(context).pop();
                  },
                ),
          ListTile(
            leading: Icon(Icons.lightbulb),
            title: Text(AppLocalizations.of(context)!.highlightTransition),
            onTap: () {
              Provider.of<AutomaduinoState>(context, listen: false)
                  .setHighlight("loop", "start");
              Navigator.of(context).pop();
            },
          ),
        ],
        child: Draggable(
            data: DragData(key, "", "", false, true, false, false),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: 25,
                  height: 25,
                  decoration: const ShapeDecoration(
                    color: Colors.black,
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    Icons.play_arrow_outlined,
                    size: 20.0,
                    color: Colors.white,
                  ),
                ),
                startPoint.connected
                    ? Container()
                    : AddConnectionButton(startPoint.key, true, false,
                        startPoint.position, updateDrag),
              ],
            ),
            feedback: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.start,
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    color: Colors.black,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: 25,
                  height: 25,
                  decoration: const ShapeDecoration(
                    color: Colors.black,
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    Icons.play_arrow_outlined,
                    size: 20.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            childWhenDragging: Container(),
            onDragUpdate: (details) {
              updatePosition(startPoint, details.delta * (1 / scale), false);
            },
            onDragEnd: (details) {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              updatePosition(
                  startPoint, renderBox.globalToLocal(details.offset), true);
            }),
      ),
    );
  }
}
