import 'package:flutter/material.dart';
import '../../resources/state.dart';
import 'block_preview.dart';

class BlockListView extends StatelessWidget {
  final List<StateData> list;
  final Color color;

  const BlockListView(this.list, this.color);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        Widget buildingBlock = BlockPreview(list[index].component, color, true,
            list[index].imagePath, list[index].link);
        return Column(
          children: [
            Container(height: 5),
            Draggable(
              data: StateSettings(list[index].component, list[index].options[0],
                  true, false, null),
              child: buildingBlock,
              feedback: BlockPreview(list[index].component, color, false,
                  list[index].imagePath, list[index].link),
              childWhenDragging: buildingBlock,
            ),
          ],
        );
      },
    );
  }
}
