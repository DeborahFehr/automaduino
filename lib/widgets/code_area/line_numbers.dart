import 'package:flutter/material.dart';

class LineNumbers extends StatelessWidget {
  final double lineHeight;
  final List<int> heights;
  final int highlightLine;

  LineNumbers(this.lineHeight, this.heights, this.highlightLine);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(BorderSide(color: Colors.grey)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (var i in List.generate(heights.length, (i) => i + 1))
            Container(
              width: double.infinity,
              height: lineHeight * heights[i - 1],
              color: i == highlightLine
                  ? Theme.of(context).colorScheme.primary
                  : null,
              child: Text(
                i.toString(),
                textAlign: TextAlign.right,
                style: TextStyle(
                    height: 1.2,
                    fontSize: 14,
                    fontFamily: "Monaco",
                    color: i == highlightLine ? Colors.white : Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
