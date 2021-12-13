import 'dart:collection';

import '../utils/index.dart';

// ! This code still needs refactoring

class Day13 extends GenericDay {
  Day13() : super(13);

  late Set<Position> dotsForPart2;

  @override
  Sheet parseInput() {
    final instructions = input.getPerLine();
    Set<Position> dots = {};
    final Queue<Tuple2<String, int>> folds = Queue();

    for (final instruction in instructions) {
      if (instruction.contains(',')) {
        // lines with positions
        dots.add(Position.fromList(
            ParseUtil.stringListToIntList(instruction.trim().split(','))));
      } else if (instruction.contains('=')) {
        // fold instruction
        // only x=1 part
        final i = instruction.trim().split(' ').last;
        final coordChar = i.split('=').first;
        final coordInt = int.parse(i.split('=').last);
        folds.addLast(Tuple2(coordChar, coordInt));
      }
    }
    return Sheet(dots, folds);
  }

  @override
  int solvePart1() {
    final sheet = parseInput();

    for (final fold in sheet.folds!) {
      final foldCoord = fold.item1;
      final foldValue = fold.item2;

      // find all dots that will be folded
      final dotsToChange = sheet.dots.where((dot) {
        if (foldCoord == 'x') {
          if (dot.item1 >= foldValue) {
            return true;
          }
          return false;
        } else if (foldCoord == 'y') {
          if (dot.item2 >= foldValue) {
            return true;
          }
          return false;
        }

        throw Exception('Unknown fold coordinate $foldCoord');
      }).toSet();

      // fold them
      final foldedDots = dotsToChange.map<Position>((dot) {
        if (foldCoord == 'x') {
          final newPos = Position(foldValue * 2 - dot.item1, dot.item2);
          return newPos;
        } else if (foldCoord == 'y') {
          return Position(dot.item1, foldValue * 2 - dot.item2);
        }
        throw Exception('Unknown fold coordinate $foldCoord');
      }).toSet();

      // remove them for now
      sheet.removeDots(dotsToChange);
      sheet.addDots(foldedDots);
    }

    dotsForPart2 = sheet.dots;
    return sheet.length;
  }

  @override
  int solvePart2() {
    final resultSheet = Sheet(dotsForPart2);
    List<List<String>> art = List.generate(resultSheet.maxY + 1,
        (index) => List.generate(resultSheet.maxX + 1, (index) => '.'));

    resultSheet.dots.forEach((dot) {
      art[dot.item2][dot.item1] = '#';
    });

    art.printSheet();
    return 0;
  }
}

extension on List<List<String>> {
  void printSheet() {
    for (final row in this) {
      print(row.join());
    }
  }
}

class Sheet {
  Sheet(this._dots, [this.folds])
      : _maxX = getMaxX(_dots),
        _maxY = getMaxY(_dots);

  final Set<Position> _dots;
  // start at first element
  final Queue<Tuple2<String, int>>? folds;
  int _maxX;
  int _maxY;

  Set<Position> get dots => _dots;
  int get length => _dots.length;
  int get maxX => _maxX;
  int get maxY => _maxY;

  void addDots(Set<Position> dotsToAdd) {
    _dots.addAll(dotsToAdd);
    _maxX = getMaxX(dots);
    _maxY = getMaxY(dots);
  }

  void removeDots(Set<Position> dotsToRemove) {
    _dots.removeAll(dotsToRemove);
  }

  static int getMaxX(Set<Position> dots) {
    return max(dots.map((dot) => dot.item1))!;
  }

  static int getMaxY(Set<Position> dots) {
    return max(dots.map((dot) => dot.item2))!;
  }
}
