import '../utils/generic_day.dart';

class Day2 extends GenericDay {
  Day2() : super(2);

  @override
  List<Instruction> parseInput() {
    List<String> inputPerLine = input.getPerLine();

    return inputPerLine.map((line) {
      var parts = line.split(' ');
      return Instruction(parts[0].parseDirection(), int.parse(parts[1]));
    }).toList();
  }

  @override
  int solvePart1() {
    int horiz = 0, vert = 0;

    for (var instruction in parseInput()) {
      switch (instruction.direction) {
        case Direction.up:
          vert -= instruction.steps;
          break;
        case Direction.down:
          vert += instruction.steps;
          break;
        case Direction.forward:
          horiz += instruction.steps;
          break;
      }
    }

    return horiz * vert;
  }

  @override
  int solvePart2() {
    int horiz = 0, vert = 0, aim = 0;

    for (var instruction in parseInput()) {
      switch (instruction.direction) {
        case Direction.up:
          aim -= instruction.steps;
          break;
        case Direction.down:
          aim += instruction.steps;
          break;
        case Direction.forward:
          horiz += instruction.steps;
          vert += aim * instruction.steps;
          break;
      }
    }

    return horiz * vert;
  }
}

enum Direction {
  up,
  down,
  forward,
}

extension _ParseDirection on String {
  Direction parseDirection() {
    switch (this) {
      case 'up':
        return Direction.up;
      case 'down':
        return Direction.down;
      case 'forward':
        return Direction.forward;
      default:
        throw Exception('Invalid direction');
    }
  }
}

class Instruction {
  Instruction(this.direction, this.steps);
  Direction direction;
  int steps;
}
