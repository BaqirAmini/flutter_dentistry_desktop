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
          title: const Text('Adults\'s Teeth Selection'),
        ),
        body: Center(
          child: SizedBox(
            width: 800,
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
  final List<String> _selectedLetters = [];
  final Map<String, bool> _isHovering = {};

  Widget _buildQuadrant(String quadrantId, List<int> toothNumbers) {
    return Row(
      children: toothNumbers.map((toothNum) {
        String id = '$quadrantId-$toothNum';
        return Expanded(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isHovering[id] = true),
            onExit: (_) => setState(() => _isHovering[id] = false),
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: _selectedLetters.contains(id)
                      ? Colors.blue
                      : (_isHovering[id] ?? false
                          ? const Color.fromARGB(255, 71, 190, 245)
                          : Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    toothNum.toString(),
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
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
                    List<int>.generate(
                      8,
                      (i) => (i + 1),
                    ).reversed.toList(),
                  ),
                  _buildQuadrantWithLabel(
                    'Q2',
                    List<int>.generate(
                      8,
                      (i) => (i + 1),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildQuadrantWithLabel(
                    'Q4',
                    List<int>.generate(
                      8,
                      (i) => (i + 1),
                    ).reversed.toList(),
                  ),
                  _buildQuadrantWithLabel(
                    'Q3',
                    List<int>.generate(
                      8,
                      (i) => (i + 1),
                    ),
                  ),
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

  Widget _buildQuadrantWithLabel(String quadrantId, List<int> toothNumbers) {
    return Expanded(
        child: Column(
      children: [
        Text(
          quadrantId,
          style: const TextStyle(fontSize: 24),
        ),
        Expanded(
          child: _buildQuadrant(quadrantId, toothNumbers),
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
