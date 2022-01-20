import 'package:flutter/material.dart';
import '../../resources/building_blocks.dart';
import '../../resources/support_classes.dart';
import 'block_preview.dart';

class BlockListView extends StatelessWidget {
  final List<BlockData> list;

  const BlockListView(this.list);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        Widget buildingBlock =
            BlockPreview(list[index].name, list[index].color as Color, true);
        return Column(
          children: [
            Container(height: 5),
            Draggable(
              data: list[index],
              child: buildingBlock,
              feedback: BlockPreview(
                  list[index].name, list[index].color as Color, false),
              childWhenDragging: buildingBlock,
            ),
          ],
        );
      },
    );
  }
}
