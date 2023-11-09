import 'package:flutter/material.dart';

class ChildQuadrantGrid extends StatefulWidget {
  const ChildQuadrantGrid({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChildQuadrantGrid createState() => _ChildQuadrantGrid();
}

class _ChildQuadrantGrid extends State<ChildQuadrantGrid> {
  final List<String> _selectedLetters = [];
  final Map<String, bool> _isHovering = {};

  Widget _buildQuadrant(String quadrantId, List<String> letters) {
    return Row(
      children: letters.map((letter) {
        String id = '$quadrantId-$letter';
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
                    letter.toString(),
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
                      'Q2',
                      List<String>.generate(
                              5, (i) => String.fromCharCode(65 + i))
                          .reversed
                          .toList()),
                  _buildQuadrantWithLabel(
                      'Q1',
                      List<String>.generate(
                          5, (i) => String.fromCharCode(65 + i))),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildQuadrantWithLabel(
                      'Q3',
                      List<String>.generate(
                              5, (i) => String.fromCharCode(65 + i))
                          .reversed
                          .toList()),
                  _buildQuadrantWithLabel(
                      'Q4',
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