import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/view/dashboard.dart';

class PlayerDetails extends StatefulWidget {
  const PlayerDetails({super.key});

  @override
  State<PlayerDetails> createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends State<PlayerDetails> {
  final player1Controller = TextEditingController();
  final player2Controller = TextEditingController();

  void setValue(String key, String value) async {
    SharedPreferences shredpref = await SharedPreferences.getInstance();
    shredpref.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "Player Details",
          style: GoogleFonts.coiny(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
        )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              children: [
                Text('Player 1 :'),
                Expanded(
                  child: TextField(
                    controller: player1Controller,
                    decoration:
                        InputDecoration(hintText: 'Enter Player 1 name'),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Text('Player 2 :'),
                Expanded(
                  child: TextField(
                    controller: player2Controller,
                    decoration:
                        InputDecoration(hintText: 'Enter Player 2 name'),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  if (player1Controller.text.isNotEmpty &&
                      player2Controller.text.isNotEmpty) {
                    // log('message: ${player1Controller.text}');

                    setValue('player1', player1Controller.text);
                    setValue('player2', player2Controller.text);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TicTacToeDash()));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                          title: Text('Enter player details'),
                          titleTextStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 16),
                          actions: [
                            TextButton(
                                child: Text(
                                  'Ok',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                          ]),
                    );
                  }
                },
                child: Text('Add')),
          ]),
        ));
  }
}
