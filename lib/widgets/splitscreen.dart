import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'building_area.dart';
import 'code_area.dart';

class SplitScreen extends StatefulWidget {
  final double width;

  SplitScreen({Key? key, required this.width}) : super(key: key);

  @override
  _SplitScreenState createState() => _SplitScreenState();
}

class _SplitScreenState extends State<SplitScreen> {
  double _width = 0;
  double _weightCodeArea = 0.5;

  void initState() {
    super.initState();
    _width = widget.width;
  }

  void updateSplitWidth(bool closedDrawer) {
    closedDrawer ? _weightCodeArea = 0.5 : _weightCodeArea = 0.05;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiSplitView(
          children: [
            BuildingArea(elements: [],),
            CodeArea(closedWidth: _width * 0.05, updateWidth: updateSplitWidth,)
          ],
          minimalWeight: 0.2,
          controller: MultiSplitViewController(weights: [1 - _weightCodeArea, _weightCodeArea]),
    );
  }
}