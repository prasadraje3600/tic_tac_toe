// import 'dart:developer';
// import 'dart:ffi';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicTacToeDash extends StatefulWidget {
  const TicTacToeDash({Key? key}) : super(key: key);

  @override
  State<TicTacToeDash> createState() => _TicTacToeDashState();
}

class _TicTacToeDashState extends State<TicTacToeDash> {
  List<String> xoDisplay = List.filled(9, "");
  bool Xturn = true;
  int xWins = 0;
  int oWins = 0;

  List<List<int>> winningCombinations = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  onContainerClicked({required int i}) {
    if (xoDisplay[i] == "") {
      if (Xturn) {
        xoDisplay[i] = "X";
      } else {
        xoDisplay[i] = "O";
      }
      Xturn = !Xturn;

      winningCondition(i);
    }
    setState(() {});
  }

  void winningCondition(int i) {
    if (checkWinner(xoDisplay, "X")) {
      xWins++;

      saveData('player1', xWins.toString());
      getData();

      showWinnerDialog("X");
    } else if (checkWinner(xoDisplay, "O")) {
      oWins++;
      saveData('player2', oWins.toString());
      getData();
      showWinnerDialog("O");
    } else if (xoDisplay.every((element) => element.isNotEmpty)) {
      // Draw
      showDrawDialog();
    }
  }

  void showDrawDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.rightSlide,
      title: 'Draw',
      desc: 'It\'s a draw!',
      btnOkOnPress: () {
        restartGame();
      },
    ).show();
  }

  bool checkWinner(List<String> board, String player) {
    for (var combination in winningCombinations) {
      if (board[combination[0]] == player &&
          board[combination[1]] == player &&
          board[combination[2]] == player) {
        return true;
      }
    }
    return false;
  }

  void showWinnerDialog(String winner) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      btnCancel: Text(
        "cancel",
      ),
      animType: AnimType.rightSlide,
      title: 'Winner',
      desc: 'Player $winner wins!',
      btnCancelOnPress: restartGame(),
      btnOkOnPress: restartGame(),
    ).show();
  }

  restartGame() {
    xoDisplay = List.filled(9, "");
  }

  // late SharedPreferences _prefs;
  // int player1 = 0;
  // int player2 = 0;

  @override
  void initState() {
    super.initState();

    getData();
  }

  void saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      xWins = int.parse(prefs.getString('player1') ?? '0');
      oWins = int.parse(prefs.getString('player2') ?? '0');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.blue,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  title: Text('Do you want to close?'),
                  titleTextStyle:
                      TextStyle(color: Colors.redAccent, fontSize: 16),
                  actions: [
                    TextButton(
                        child: Text(
                          'Yes',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => exit(0)),
                    TextButton(
                        child: Text(
                          'No',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ]),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.replay,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const TicTacToeDash(),
                ),
              );
            },
          )
        ],
        title: Text(
          'Tic Tac Toe',
          style: GoogleFonts.coiny(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      border: Xturn
                          ? Border.all(color: Colors.black, width: 5)
                          : Border.all(),
                      color: Colors.white,
                      shape: BoxShape.circle),
                  child: Text(
                    "X",
                    style: GoogleFonts.coiny(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: !Xturn
                        ? Border.all(color: Colors.black, width: 5)
                        : Border.all(),
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "0",
                    style: GoogleFonts.coiny(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: GridView.builder(
                  itemCount: xoDisplay.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () {
                        print(i);
                        onContainerClicked(i: i);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: i % 2 == 0 ? Colors.white : Colors.white,
                          borderRadius:
                              BorderRadius.circular(i % 2 == 0 ? 10 : 10),
                        ),
                        child: Text(
                          xoDisplay[i],
                          style: GoogleFonts.coiny(
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text(
                        'Player 1:',
                        style: GoogleFonts.coiny(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        '$xWins',
                        style: GoogleFonts.coiny(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Player 2:',
                        style: GoogleFonts.coiny(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        '$oWins',
                        style: GoogleFonts.coiny(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
