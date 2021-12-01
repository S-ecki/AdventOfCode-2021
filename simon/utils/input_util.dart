import 'dart:io';

/// Automatically reads reads the contents of the input file for given [day]. \
/// Note that file name and location must align.
class InputUtil {
  final String _inputAsString;

  InputUtil(int day) : _inputAsString = _readInput('./input/aoc$day.txt');

  static String _readInput(String input) {
    return File(input).readAsStringSync();
  }

  /// Splits the input String by `newline`.
  List<String> getPerLine() {
    return _inputAsString.split('\n');
  }

  /// Splits the input String by `whitespace` and `newline`.
  List<String> getPerWhitespace() {
    return _inputAsString.split(RegExp(r'\s\n'));
  }

  /// Splits the input String by given pattern.
  List<String> getBy(String pattern) {
    return _inputAsString.split(pattern);
  }
}
