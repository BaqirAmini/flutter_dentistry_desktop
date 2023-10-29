import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Children\'s Teeth Selection'),
        ),
        body: Center(
          child: SizedBox(
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

  Widget _buildQuadrant(String quadrantId, List<String> letters) {
    return Row(
      children: letters.map((letter) {
        String id = '$quadrantId-$letter';
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (_selectedLetters.contains(id)) {
                  _selectedLetters.remove(id);
                } else {
                  _selectedLetters.add(id);
                }
                printSelectedTeeth();
              });
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color:
                    _selectedLetters.contains(id) ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildQuadrantWithLabel(
                      'Q1',
                      List<String>.generate(
                              5, (i) => String.fromCharCode(65 + i))
                          .reversed
                          .toList()),
                  _buildQuadrantWithLabel(
                      'Q2',
                      List<String>.generate(
                          5, (i) => String.fromCharCode(65 + i))),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildQuadrantWithLabel(
                      'Q4',
                      List<String>.generate(
                              5, (i) => String.fromCharCode(65 + i))
                          .reversed
                          .toList()),
                  _buildQuadrantWithLabel(
                      'Q3',
                      List<String>.generate(
                          5, (i) => String.fromCharCode(65 + i))),
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

  Widget _buildQuadrantWithLabel(String quadrantId, List<String> letters) {
    return Expanded(
        child: Column(
      children: [
        Text(
          quadrantId,
          style: const TextStyle(fontSize: 24),
        ),
        Expanded(
          child: _buildQuadrant(quadrantId, letters),
        ),
      ],
    ));
  }

  void printSelectedTeeth() {
    print('Selected teeth:');
    for (String id in _selectedLetters) {
      print(id);
    }
  }
}
