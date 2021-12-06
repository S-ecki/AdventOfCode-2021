import '../utils/generic_day.dart';
import '../utils/parse_util.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  late List<int> nums;
  late List<Board> boards;

  @override
  parseInput() {
    // get called numbers
    final inputNums = input.getPerLine().first;
    nums = _parseNums(inputNums);
    // get boards
    final inputLines = input.getPerLine().skip(2).toList();
    boards = _parseBoards(inputLines);
  }

  List<int> _parseNums(String input) {
    final numberList = input.split(',');
    return ParseUtil.stringListToIntList(numberList);
  }

  List<Board> _parseBoards(List<String> inputLines) {
    List<Board> boards = [];
    List<List<BoardField>> tempBoard = [];

    for (var i = 0; i < inputLines.length; ++i) {
      // boards are 5 lines long, sixth line is empty
      if ((i + 1) % 6 == 0) {
        boards.add(Board(tempBoard));
        tempBoard = [];
      } else {
        final rowStrings = inputLines[i].split(" ")
          ..removeWhere((element) => element.isEmpty);

        final rowInts = ParseUtil.stringListToIntList(rowStrings);
        tempBoard.add(ParseUtil.intListToBoardFieldList(rowInts));
      }
    }

    return boards;
  }

  @override
  int solvePart1() {
    parseInput();
    for (var n in nums) {
      for (var board in boards) {
        board.checkoff(n);
        if (board.isSolved()) return board.unsolvedSum * n;
      }
    }
    return 0;
  }

  @override
  int solvePart2() {
    parseInput();
    Set<Board> unsolvedBoards = boards.toSet();
    Set<Board> boardsToRemove = Set();

    for (var n in nums) {
      for (var board in unsolvedBoards) {
        board.checkoff(n);
        // accumulate all boards to be removed and remove later to avoid
        // removing boards while iterating
        if (board.isSolved()) boardsToRemove.add(board);
      }
      // if this holds true, we remove the last board and have a solution
      if (unsolvedBoards.length == boardsToRemove.length) {
        return n * unsolvedBoards.first.unsolvedSum;
      }
      // only operate on unsolved boards in next iteration
      unsolvedBoards.removeAll(boardsToRemove);
      boardsToRemove.clear();
    }
    return 0;
  }
}

class Board {
  final List<List<BoardField>> board;
  bool solved = false;

  Board(this.board);

  void checkoff(int n) {
    board.forEach((row) => row.forEach((f) => f.checkIfNum(n)));
    if (isSolved()) solved = true;
  }

  /// Returns a sum of the fields that are `not` checked!
  int get unsolvedSum {
    final sum = board.fold<int>(
        0,
        (value, fields) =>
            value +
            fields.fold<int>(
                0, (value, f) => f.isChecked ? value : value + f.n));
    return sum;
  }

  bool isSolved() {
    return rowSolved() || colSolved();
  }

  bool rowSolved() {
    return board.any((row) => row.every((f) => f.isChecked));
  }

  bool colSolved() {
    var isSolved = false;
    for (var i = 0; i < board[0].length; ++i) {
      if (board.every((row) => row[i].isChecked)) isSolved = true;
    }
    return isSolved;
  }
}

class BoardField {
  BoardField(this.n);
  final int n;
  bool _checked = false;

  bool get isChecked => _checked;

  void checkIfNum(int i) {
    if (n == i) {
      _checked = true;
    }
  }
}
