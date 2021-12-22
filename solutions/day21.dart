import '../utils/index.dart';

class Day21 extends GenericDay {
  Day21() : super(21);

  @override
  Tuple2<int, int> parseInput() {
    final startPositions = input
        .getPerLine()
        .map((line) => line.trim())
        .map((line) => line[line.length - 1])
        .map(int.parse)
        .toList();
    return Tuple2.fromList(startPositions);
  }

  @override
  int solvePart1() {
    // variables to keep track of state
    final positions = parseInput().toList();
    final scores = List.generate(2, (index) => 0);
    var diceEyes = 0, diceRolls = 0;

    // functions to alter state
    final rollDice = () {
      ++diceRolls;
      // dice eyes start at 1 and increase until 100, getting set back to 1 again
      return ((++diceEyes - 1) % 100 + 1);
    };
    final rollDice3Times = () => rollDice() + rollDice() + rollDice();
    // player positions start at 1, increase until 10 and wrap back to 1 again
    final startAtOne = (int position) => (position - 1) % 10 + 1;
    final move = (int player, int steps) {
      positions[player] += steps;
      positions[player] = startAtOne(positions[player]);
    };

    // play until one player reaches 1000 points
    while (scores.every((score) => score < 1000)) {
      // dice rolls increase by 3 each turn
      // thus, this will be 0 at the first turn, 1 at the second, 0 at the third and so on
      final player = diceRolls % 2;

      final steps = rollDice3Times();
      move(player, steps);
      scores[player] += positions[player] as int;
    }

    return min(scores)! * diceRolls;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
