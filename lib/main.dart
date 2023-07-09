import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bubble Pop Game',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: BubblePopGame(),
    );
  }
}

class BubblePopGame extends StatefulWidget {
  @override
  _BubblePopGameState createState() => _BubblePopGameState();
}

class _BubblePopGameState extends State<BubblePopGame> {
  Bubble? currentBubble;
  int score = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    timer?.cancel();
    showBubble();
    timer = Timer(Duration(milliseconds: 1000), () {
      if (currentBubble != null) {
        removeBubble();
      }
      startGame();
    });
  }

  void showBubble() {
    setState(() {
      currentBubble = Bubble(
        position: Offset(
          20+Random().nextInt(300).toDouble(),
          15+Random().nextInt(500).toDouble(),
        ),
        size: Random().nextInt(40) + 20,
      );
    });
  }

  void removeBubble() {
    setState(() {
      currentBubble = null;
    });
  }

  void popBubble() {
    if (currentBubble != null) {
      setState(() {
        score++;
        removeBubble();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bubble Pop Game'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.lightBlueAccent,
                  Colors.blue,
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pop the Bubble',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Score: $score',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (currentBubble != null)
            Positioned(
              top: currentBubble!.position.dy - currentBubble!.size / 2,
              left: currentBubble!.position.dx - currentBubble!.size / 2,
              child: GestureDetector(
                onTap: () {
                  popBubble();
                },
                child: Container(
                  width: currentBubble!.size,
                  height: currentBubble!.size,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Bubble {
  final Offset position;
  final double size;

  Bubble({required this.position, required this.size});
}
