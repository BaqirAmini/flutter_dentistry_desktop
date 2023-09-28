import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dentistry App'),
        ),
        body: Center(
          child: Container(
            width: 600,
            height: 300,
            child: QuadrantGrid(),
          ),
        ),
      ),
    );
  }
}

class QuadrantGrid extends StatefulWidget {
  @override
  _QuadrantGridState createState() => _QuadrantGridState();
}

class _QuadrantGridState extends State<QuadrantGrid> {
  List<String> _selectedLetters = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildQuadrant(List<String>.generate(
                      5, (i) => String.fromCharCode(65 + i)).reversed.toList()),
                  _buildQuadrant(List<String>.generate(
                      5, (i) => String.fromCharCode(70 + i))),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildQuadrant(List<String>.generate(
                      5, (i) => String.fromCharCode(80 + i)).reversed.toList()),
                  _buildQuadrant(List<String>.generate(
                      5, (i) => String.fromCharCode(75 + i))),
                ],
              ),
            ),
          ],
        ),
        Center(
          child: Container(
            width: 1,
            height: double.infinity,
            color: Colors.black,
          ),
        ),
        Center(
          child: Container(
            height: 1,
            width: double.infinity,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildQuadrant(List<String> letters) {
    return Expanded(
      child: Row(
        children: letters.map((letter) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (_selectedLetters.contains(letter)) {
                    _selectedLetters.remove(letter);
                  } else {
                    _selectedLetters.add(letter);
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: _selectedLetters.contains(letter)
                      ? Colors.blue
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
