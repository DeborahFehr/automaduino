import 'package:test/test.dart';
import 'package:arduino_statemachines/resources/code_map.dart';

void main() {
  group('Code Map', () {
    test('Default Code', () {
      expect(CodeMap({}, {}, {}, {}, {}).getCode("functions"), "");
    });
  });
}
