import '../solutions/day04.dart';
import 'index.dart';

class ParseUtil {
  /// Throws an exception if any given String is not parseable.
  static List<int> stringListToIntList(List<String> strings) {
    return strings.map((e) => int.parse(e)).toList();
  }

  static List<BoardField> intListToBoardFieldList(List<int> strings) {
    return strings.map((e) => BoardField(e)).toList();
  }

  /// Returns decimal number from binary string
  static int binaryToDecimal(String binary) {
    return int.parse(binary, radix: 2);
  }

  static Board stringListToBoard(List<String> strings) {
    return strings
        .map((e) => ParseUtil.stringListToIntList(e.trim().split('')))
        .toList();
  }
}
