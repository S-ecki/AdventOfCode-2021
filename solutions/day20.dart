import '../utils/index.dart';

class Day20 extends GenericDay {
  Day20() : super(20);

  @override
  Tuple2<String, Field<String>> parseInput() {
    final lines = input.getPerLine();
    final enhancement = lines.first.trim();
    final parts = lines.skip(2).map((line) => line.trim().split('')).toList();
    final image = Field(parts);
    return Tuple2(enhancement, image);
  }

  @override
  int solvePart1() {
    return solve(2);
  }

  @override
  int solvePart2() {
    return solve(50);
  }

  int solve(int iterations) {
    final input = parseInput(), enhancement = input.item1;
    var image = input.item2;

    for (var i = 0; i < iterations; ++i) {
      // The default value for the infinite size around the picture
      // It changes in case the first value for a decimal 0 is #, as the infinite
      // space gets filled by # then.
      // If this is the case, it gets filled with the last value on the lookup
      // in the next step as everything around the picture has max decimal value.
      final defaultValue = enhancement[0] == '#' && i % 2 == 0
          ? enhancement[enhancement.length - 1]
          : enhancement[0];

      image.padWith(defaultValue);
      // copy is needed to avoid changing the original image
      final imageCopy = image.copy();

      // Run the enhancement on each field, altering the copied image
      image.forEach((x, y) {
        final fields = image.neighboursAndSelf(x, y);
        final binary = fields
            .map((f) => image.getValueOrPadding(f.x, f.y, defaultValue))
            .join();
        final decimal = _binaryToDecimal(binary);
        final newValue = enhancement[decimal];
        imageCopy.setValueAt(x, y, newValue);
      });

      image = imageCopy.copy();
    }

    return image.count('#');
  }
}

/// Converts a binary string with special characters to a decimal number
int _binaryToDecimal(String binary) {
  binary = binary.replaceAllMapped('.', (match) => '0');
  binary = binary.replaceAllMapped('#', (match) => '1');
  return int.parse(binary, radix: 2);
}

extension on Field<String> {
  /// Adds [padding] characters at all borders of this fields
  void padWith(String padding) {
    this.field.forEach((row) {
      row.insert(0, padding);
      row.add(padding);
    });
    this.field.insert(0, List.filled(this.field.first.length, padding));
    this.field.add(List.filled(this.field.first.length, padding));
    height += 2;
    width += 2;
  }

  /// Returns all positional neighbours of a point and the point itself. \
  /// Positions are added row by row, starting at the top.
  ///
  /// **Also returns Positions that might be outside of this field due to
  /// puzzle requirements!**
  List<Position> neighboursAndSelf(int x, int y) {
    final positions = <Position>[];
    for (var yy = y - 1; yy <= y + 1; yy++) {
      for (var xx = x - 1; xx <= x + 1; xx++) {
        positions.add(Position(xx, yy));
      }
    }
    return positions;
  }

  /// Returns the String on given Position, or [padding] of the field is out of bounds.
  String getValueOrPadding(int x, int y, padding) {
    if (x < 0 ||
        x >= this.field.length ||
        y < 0 ||
        y >= this.field.first.length) {
      return padding;
    }
    return this.field[y][x];
  }
}
