import 'dart:math';

class ParseUtil {
  /// Throws an exception if any given String is not parseable.
  static List<int> stringListToIntList(List<String> stringList) {
    return stringList.map((e) => int.parse(e)).toList();
  }

  /// Returns decimal number from binary string
  static int binaryToDecimal(String binary) {
    return int.parse(binary, radix: 2);
  }
}
