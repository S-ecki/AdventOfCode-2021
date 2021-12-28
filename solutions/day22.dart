import '../utils/index.dart';
import 'day02.dart';

typedef Cube = Tuple3<int, int, int>;
typedef State = Map<Cube, bool>;
typedef Range = Tuple6<int, int, int, int, int, int>;
typedef StateAlteration = Tuple2<Range, bool>;

class Day22 extends GenericDay {
  Day22() : super(22);

  @override
  List<StateAlteration> parseInput() {
    final lines = input.getPerLine().take(20).toList();

    return lines.map((line) {
      final parts = line.split(' ');

      final boolean = parts[0] == 'on';

      String rawRange = parts[1];
      rawRange = rawRange.replaceAllMapped(RegExp(r'((x|y|z)=)'), (_) => '');
      rawRange = rawRange.replaceAllMapped(('..'), (_) => ',');
      final range = Range.fromList(rawRange.split(',').map(int.parse).toList());

      return StateAlteration(range, boolean);
    }).toList();
  }

  @override
  int solvePart1() {
    final instructions = parseInput();
    final cubeState = _initalCubeState();

    instructions.forEach((instruction) {
      final newState = _stateFromInstruction(instruction);
      cubeState.addAll(newState);
    });

    // count all cubes that are "on"
    return cubeState.values.where((boolean) => boolean).length;
  }

  State _initalCubeState() {
    final initialState = State();
    for (var x = -50; x <= 50; x++) {
      for (var y = -50; y <= 50; y++) {
        for (var z = -50; z <= 50; z++) {
          final cube = Tuple3(x, y, z);
          initialState[cube] = false;
        }
      }
    }
    return initialState;
  }

  State _stateFromInstruction(StateAlteration instruction) {
    final range = instruction.item1;
    final boolean = instruction.item2;

    final state = State();

    for (var x = range.x1; x <= range.x2; ++x) {
      for (var y = range.y1; y <= range.y2; ++y) {
        for (var z = range.z1; z <= range.z2; ++z) {
          final cube = Tuple3(x, y, z);
          state[cube] = boolean;
        }
      }
    }
    return state;
  }

  @override
  int? solvePart2() {
    return null;
  }
}

extension on Range {
  int get x1 => item1;
  int get x2 => item2;
  int get y1 => item3;
  int get y2 => item4;
  int get z1 => item5;
  int get z2 => item6;
}
