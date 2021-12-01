class ParseUtil {
  /// Throws an exception if any given String is not parseable.
  static List<int> stringListToIntList(List<String> stringList) {
    return stringList.map((e) => int.parse(e)).toList();
  }
}
