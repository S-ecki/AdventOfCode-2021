abstract class Day {
  abstract int day;
  int puzzleOne();
  int puzzleTwo();

  void printSolutions() {
    print("-------------------------");
    print("         Day $day        ");
    print("Solution for puzzle one: ${puzzleOne()}");
    print("Solution for puzzle two: ${puzzleTwo()}");
    print("\n");
  }
}
