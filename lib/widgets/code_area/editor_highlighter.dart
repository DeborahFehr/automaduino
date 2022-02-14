import 'package:flutter/material.dart';

//https://stackoverflow.com/questions/59770757/not-possible-to-extend-textfield-in-flutter/59773962#59773962

class EditorHighlighter extends TextEditingController {
  Map<String, TextStyle> mapping;
  Pattern pattern;

  void updateMap(Map<String, TextStyle> map) {
    this.mapping = map;
    this.pattern =
        RegExp(mapping.keys.map((key) => RegExp.escape(key)).join('|'));
  }

  EditorHighlighter(this.mapping)
      : pattern =
            RegExp(mapping.keys.map((key) => RegExp.escape(key)).join('|'));

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    List<InlineSpan> children = [];
    text.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        children.add(
            TextSpan(text: match[0], style: style!.merge(mapping[match[0]])));
        return "";
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text, style: style));
        return "";
      },
    );
    return TextSpan(style: style, children: children);
  }
}
