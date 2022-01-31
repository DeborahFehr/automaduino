import 'package:flutter/material.dart';
import '../../resources/state.dart';
import 'block_preview.dart';

class BlockListView extends StatelessWidget {
  final List<StateData> list;
  final Color color;
  final ScrollController scrollController;

  const BlockListView(this.list, this.color, this.scrollController);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        isAlwaysShown: true,
        controller: scrollController,
        child: ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(8),
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            Widget buildingBlock = BlockPreview(
                list[index].component,
                color,
                true,
                list[index].imagePath,
                list[index].option,
                list[index].link);
            return Column(
              children: [
                Container(height: 5),
                Draggable(
                  data: StateSettings(list[index].component, list[index].option,
                      null, true, false, null),
                  child: buildingBlock,
                  feedback: BlockPreview(
                      list[index].component,
                      color,
                      false,
                      list[index].imagePath,
                      list[index].option,
                      list[index].link),
                  childWhenDragging: buildingBlock,
                ),
              ],
            );
          },
        ));
  }
}
