import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToe());
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<List<String>> gameBoard = List<List<String>>.generate(
    3,
        (int index) => List<String>.filled(3, ''),
    growable: false,
  );

  bool isPlayer1Turn = true;
  int moves = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text(
          'Tic Tac Toe',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isPlayer1Turn ? 'Player X' : 'Player O',
              style: TextStyle(fontSize: 28, color: Colors.pinkAccent[700], fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                final int row = index ~/ 3;
                final int col = index % 3;
                return GestureDetector(
                  onTap: () {
                    if (gameBoard[row][col] == '' && moves < 9) {
                      setState(() {
                        gameBoard[row][col] = isPlayer1Turn ? 'X' : 'O';
                        isPlayer1Turn = !isPlayer1Turn;
                        moves++;

                        if (_checkWinner(row, col)) {
                          _showWinnerDialog();
                        } else if (moves == 9) {
                          _showDrawDialog();
                        }
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isPlayer1Turn ? Colors.pink : Colors.purpleAccent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        gameBoard[row][col],
                        style: const TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
              itemCount: 9,
            ),
          ],
        ),
      ),
    );
  }

  bool _checkWinner(int row, int col) {
    if (gameBoard[row][0] == gameBoard[row][1] && gameBoard[row][1] == gameBoard[row][2]) {
      return true;
    }

    if (gameBoard[0][col] == gameBoard[1][col] && gameBoard[1][col] == gameBoard[2][col]) {
      return true;
    }

    if ((row == col || row + col == 2) &&
        ((row == col && gameBoard[0][0] == gameBoard[1][1] && gameBoard[1][1] == gameBoard[2][2]) ||
            (row + col == 2 && gameBoard[0][2] == gameBoard[1][1] && gameBoard[1][1] == gameBoard[2][0]))) {
      return true;
    }

    return false;
  }

  void _showWinnerDialog() {
    final String winner = isPlayer1Turn ? 'Player O' : 'Player X';
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('$winner wins!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _resetGame();
                Navigator.of(context).pop();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void _showDrawDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text("It's a draw!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _resetGame();
                Navigator.of(context).pop();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      gameBoard = List<List<String>>.generate(
        3,
            (int index) => List<String>.filled(3, ''),
        growable: false,
      );
      isPlayer1Turn = true;
      moves = 0;
    });
  }
}
