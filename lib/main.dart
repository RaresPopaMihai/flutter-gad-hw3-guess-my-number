import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const GuessMyNumberApp());
}

class GuessMyNumberApp extends StatelessWidget {
  const GuessMyNumberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GuessMyNumberPage(),
    );
  }
}

class GuessMyNumberPage extends StatefulWidget {
  const GuessMyNumberPage({super.key});

  @override
  State<GuessMyNumberPage> createState() => _GuessMyNumberPageState();
}

class _GuessMyNumberPageState extends State<GuessMyNumberPage> {
  static const String reset = 'Reset';
  static const String guess = 'Guess';
  String _guessedNumberShot = '';
  final TextEditingController _numberController = TextEditingController();
  String guessButtonText = guess;
  final Random _random = Random();
  bool _isNewGame = true;
  bool _isTextFieldEnabled = true;
  int _guessNumber = 0;

  @override
  Widget build(BuildContext context) {
    if (_isNewGame) {
      _guessNumber = _random.nextInt(100);
      if (_guessNumber == 0) {
        _guessNumber++;
      }
      _isNewGame = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guess my number'),
      ),
      body: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              "I'm thinking of a number between 1 and 100.",
              style: TextStyle(
                fontSize: 27,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "It's your turn to guess my number!",
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              _guessedNumberShot,
              style: const TextStyle(
                fontSize: 40,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(15),
              decoration:
                  BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey), boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.shade100,
                  spreadRadius: 6,
                  offset: const Offset(5, 5),
                )
              ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Try a number!',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  TextField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.allow(RegExp(r'^[-+]?\d*$')),
                    ],
                    enabled: _isTextFieldEnabled,
                  ),
                  TextButton(
                      onPressed: () {
                        if (guessButtonText == 'Reset') {
                          restartGame();
                        }
                        final int? numberGuessed = int.tryParse(_numberController.text);
                        tryNumber(numberGuessed);
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.grey),
                      child: Text(guessButtonText)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void tryNumber(int? numberGuessed) {
    if (numberGuessed != null) {
      setState(() {
        if (numberGuessed == _guessNumber) {
          guessButtonText = reset;
          _guessedNumberShot = 'You tried $numberGuessed\n You guessed right.';
          _numberController.clear();
          _isTextFieldEnabled = false;
          popDialog();
        } else {
          if (numberGuessed < _guessNumber) {
            _guessedNumberShot = 'You tried $numberGuessed\n Try Higher';
          } else if (numberGuessed > _guessNumber) {
            _guessedNumberShot = 'You tried $numberGuessed\n Try Lower';
          }
        }
      });
      _numberController.clear();
    }
  }

  void restartGame() {
    setState(() {
      guessButtonText = guess;
      _guessedNumberShot = '';
      _isNewGame = true;
      _isTextFieldEnabled = true;
    });
  }

  Future<dynamic> popDialog() => showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You guessed right'),
          content: Text('It was $_guessNumber'),
          actions: <TextButton>[
            TextButton(
                onPressed: () {
                  restartGame();
                  Navigator.of(context).pop();
                },
                child: const Text('Try again!')),
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))
          ],
        );
      });
}
