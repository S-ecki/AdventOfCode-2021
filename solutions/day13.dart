import '../utils/index.dart';

typedef Artwork = List<List<String>>;

class Day13 extends GenericDay {
  Day13() : super(13);

  late Tuple2<int, Artwork> solution;

  @override
  Sheet parseInput() {
    final instructions = input.getPerLine();

    Set<Position> dots = {};
    final List<Tuple2<String, int>> folds = [];

    for (final instruction in instructions) {
      if (instruction.contains(',')) {
        // lines with positions
        dots.add(Position.fromList(
          ParseUtil.stringListToIntList(instruction.split(',')),
        ));
      } else if (instruction.contains('=')) {
        // fold instruction
        // only x=1 part
        final i = instruction.trim().split(' ').last;
        folds.add(Tuple2(i.split('=').first, int.parse(i.split('=').last)));
      }
    }
    return Sheet(dots, folds);
  }

  @override
  int solvePart1() {
    solution = solve();
    return solution.item1;
  }

  @override
  int? solvePart2() {
    solution.item2.printSheet();
    return null;
  }

  Tuple2<int, Artwork> solve() {
    final sheet = parseInput();
    int solution1 = 0;
    Artwork solution2;

    final folds = sheet.folds!;

    for (var i = 0; i < folds.length; i++) {
      if (i == 1) {
        solution1 = sheet.dots.length;
      }
      final direction = folds[i].item1;
      final foldValue = folds[i].item2;

      // find all dots that will be folded
      final dotsToChange = sheet.dots
          .where((dot) =>
              direction == 'x' && dot.item1 >= foldValue ||
              direction == 'y' && dot.item2 >= foldValue)
          .toSet();

      // fold them
      final foldedDots = dotsToChange
          .map<Position>((dot) => direction == 'x'
              ? Position(foldValue * 2 - dot.x, dot.y)
              : Position(dot.x, foldValue * 2 - dot.y))
          .toSet();

      sheet.removeDots(dotsToChange);
      sheet.addDots(foldedDots);
    }

    List<List<String>> art = List.generate(sheet.maxY + 1,
        (index) => List.generate(sheet.maxX + 1, (index) => ' '));

    sheet.dots.forEach((dot) {
      art[dot.item2][dot.item1] = '#';
    });

    solution2 = art;

    return Tuple2(solution1, solution2);
  }
}

extension on Artwork {
  void printSheet() {
    for (final row in this) {
      print(row.join());
    }
  }
}

class Sheet {
  Sheet(this._dots, [this.folds]);

  final Set<Position> _dots;
  // start at first element
  final List<Tuple2<String, int>>? folds;

  Set<Position> get dots => _dots;
  int get length => _dots.length;

  void addDots(Set<Position> dotsToAdd) {
    _dots.addAll(dotsToAdd);
  }

  void removeDots(Set<Position> dotsToRemove) {
    _dots.removeAll(dotsToRemove);
  }

  int get maxX => max(dots.map((dot) => dot.item1))!;

  int get maxY => max(dots.map((dot) => dot.item2))!;
}
