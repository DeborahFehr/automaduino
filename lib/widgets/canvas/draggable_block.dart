import 'package:flutter/material.dart';
import 'state_block.dart';
import '../../resources/canvas_layout.dart';
import 'add_connection_button.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../resources/automaduino_state.dart';
import '../../resources/settings.dart';

class DraggableBlock extends StatelessWidget {
  final PositionedState block;
  final Function(Key key) updateStateName;
  final Function(PositionedState? state, {bool end}) deleteBlock;
  final Function(PositionedState block, Offset position, bool dragEnd)
      updatePosition;
  final Function(
          bool active, bool point, bool adition, Offset start, Offset end)
      updateDrag;
  final Function(Key target, bool startPoint, bool addition) addConnection;
  final double scale;

  const DraggableBlock(this.block, this.updateStateName, this.deleteBlock,
      this.updatePosition, this.updateDrag, this.addConnection, this.scale);

  @override
  Widget build(BuildContext context) {
    Color color = getBlockColorByType(block.data.type);

    Widget blockWidget = StateBlock(
        block.settings.name,
        color,
        block.data.imagePath,
        block.data.option,
        block.settings.pin,
        block.settings.selectedOption,
        updateStateName(block.key),
        TextEditingController());

    return Positioned(
      left: block.position.dx,
      top: block.position.dy,
      child: Column(
        children: [
          ContextMenuArea(
            width: 200,
            items: [
              ListTile(
                leading: Icon(Icons.highlight_remove),
                title: Text(AppLocalizations.of(context)!.deleteState),
                onTap: () {
                  deleteBlock(block);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.lightbulb),
                title: Text(AppLocalizations.of(context)!.highlightState),
                onTap: () {
                  Provider.of<AutomaduinoState>(context, listen: false)
                      .setHighlightMap("states", block.settings.variableName,
                          type: "state");
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.lightbulb),
                title: Text(AppLocalizations.of(context)!.highlightAction),
                onTap: () {
                  Provider.of<AutomaduinoState>(context, listen: false)
                      .setHighlightMap("states", block.settings.variableName,
                          type: "action");
                  Navigator.of(context).pop();
                },
              ),
              block.settings.pin == null
                  ? SizedBox.shrink()
                  : ListTile(
                      leading: Icon(Icons.lightbulb),
                      title: Text(AppLocalizations.of(context)!.highlightPin),
                      onTap: () {
                        Provider.of<AutomaduinoState>(context, listen: false)
                            .setHighlightMap(
                                "pins",
                                Provider.of<AutomaduinoState>(context,
                                        listen: false)
                                    .getVariableNameByPinAndComponent(
                                        block.settings.pin!,
                                        block.data.component));
                        Navigator.of(context).pop();
                      },
                    ),
            ],
            child: Draggable(
                data: DragData(null, block.settings.name,
                    block.settings.selectedOption, false, false, false, false),
                child: DragTarget(
                  builder: (context, List<dynamic> candidateData,
                      List<dynamic> rejectedData) {
                    return blockWidget;
                  },
                  onWillAccept: (candidate) {
                    DragData data = (candidate as DragData);
                    if (data.selectedOption == "sendWave") {
                      return !data.newBlock &&
                          data.newConnection &&
                          block.settings.selectedOption == "receiveWave";
                    }
                    return !data.newBlock &&
                        data.newConnection &&
                        data.key != block.key;
                  },
                  onAccept: (candidate) {
                    DragData data = (candidate as DragData);
                    addConnection(data.key as Key, data.startConnection,
                        data.additionalConnection);
                  },
                ),
                feedback: Transform.scale(scale: scale, child: blockWidget),
                childWhenDragging: Container(),
                onDragUpdate: (details) {
                  updatePosition(block, details.delta * (1 / scale), false);
                },
                onDragEnd: (details) {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  updatePosition(
                      block, renderBox.globalToLocal(details.offset), true);
                }),
          ),
          block.outgoingConnection
              ? SizedBox.shrink()
              : AddConnectionButton(block.key, block.settings.selectedOption,
                  false, false, block.position, updateDrag),
        ],
      ),
    );
  }
}
