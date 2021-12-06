import '../utils/generic_day.dart';
import '../utils/parse_util.dart';

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final lines = parseInput();
    final lineLength = lines[0].length;

    String gamma = "";

    for (var i = 0; i < lineLength - 1; ++i) {
      final counter = lines.where((line) => line[i] == "1").length;
      counter > lines.length / 2 ? gamma += "1" : gamma += "0";
    }

    String epsilon = invertBinary(gamma);

    return ParseUtil.binaryToDecimal(gamma) *
        ParseUtil.binaryToDecimal(epsilon);
  }

  @override
  int solvePart2() {
    var lsLines = parseInput();
    final lineLength = lsLines[0].length;

    for (var i = 0; i < lineLength - 1; ++i) {
      if (lsLines.length <= 1) break;

      final counter = lsLines.where((line) => line[i] == "1").length;
      counter >= lsLines.length / 2
          ? lsLines = keep(lsLines, "1", i)
          : lsLines = keep(lsLines, "0", i);
    }

    var oxLines = parseInput();

    for (var i = 0; i < lineLength - 1; ++i) {
      if (oxLines.length <= 1) break;

      final counter = oxLines.where((line) => line[i] == "1").length;
      counter < oxLines.length / 2
          ? oxLines = keep(oxLines, "1", i)
          : oxLines = keep(oxLines, "0", i);
    }

    final ls = ParseUtil.binaryToDecimal(lsLines[0]);
    final ox = ParseUtil.binaryToDecimal(oxLines[0]);

    return ls * ox;
  }

  String invertBinary(String toInvert) {
    String inverted = "";

    for (var i = 0; i < toInvert.length; ++i) {
      toInvert[i] == "0" ? inverted += "1" : inverted += "0";
    }

    return inverted;
  }

  List<String> keep(List<String> list, String criteria, int index) {
    return list.where((line) => line[index] == criteria).toList();
  }
}
