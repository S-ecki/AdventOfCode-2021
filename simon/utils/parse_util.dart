import 'dart:math';

import '../solutions/day04.dart';

class ParseUtil {
  /// Throws an exception if any given String is not parseable.
  static List<int> stringListToIntList(List<String> stringList) {
    return stringList.map((e) => int.parse(e)).toList();
  }

  static List<BoardField> intListToBoardFieldList(List<int> stringList) {
    return stringList.map((e) => BoardField(e)).toList();
  }

  /// Returns decimal number from binary string
  static int binaryToDecimal(String binary) {
    return int.parse(binary, radix: 2);
  }
}
