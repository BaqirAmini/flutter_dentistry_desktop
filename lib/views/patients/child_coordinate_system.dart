import 'package:flutter/material.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/patients/tooth_selection_info.dart';

void updateSelectedTeeth(List<String> selectedTeeth) async {
  final conn = await onConnToDb();
  await conn.close();

  // Convert the list of selected teeth to a string
  var selectedTeethString = selectedTeeth.join(',');
  print(selectedTeethString);
  // Update the database
/*   await conn.query(
    'INSERT INTO selected_teeth (tooth)',
    [selectedTeethString],
  ); */

  // Close the connection
  // await conn.close();
}

class ChildQuadrantGrid extends StatefulWidget {
  const ChildQuadrantGrid({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChildQuadrantGrid createState() => _ChildQuadrantGrid();
}

class _ChildQuadrantGrid extends State<ChildQuadrantGrid> {
  final List<String> _selectedTeethLetters = [];
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
                  if (_selectedTeethLetters.contains(id)) {
                    _selectedTeethLetters.remove(id);
                  } else {
                    _selectedTeethLetters.add(id);
                  }
                  _onArrangeChildSelectedTeeth(_selectedTeethLetters);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: _selectedTeethLetters.contains(id)
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
    Tooth.childToothSelected = _selectedTeethLetters.isEmpty ? false : true;
    return InputDecorator(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        border: const OutlineInputBorder(),
        labelText: _selectedTeethLetters.isEmpty
            ? 'Please select a tooth'
            : 'Children\'s Teeth Selection Chart',
        floatingLabelAlignment: FloatingLabelAlignment.center,
        labelStyle: TextStyle(
            color: _selectedTeethLetters.isEmpty ? Colors.red : Colors.blue,
            fontSize: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(30.0),
          ),
          borderSide: BorderSide(
            color: _selectedTeethLetters.isEmpty ? Colors.red : Colors.blue,
          ),
        ),
      ),
      child: Stack(
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
              color: Colors.blue,
            ),
          ),
          Center(
            child: Container(
              height: 1,
              width: double.infinity,
              color: Colors.blue,
            ),
          ),
        ],
      ),
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

  void _onArrangeChildSelectedTeeth(List<String> toothLetterSelected) {
    var letterDelimiter = toothLetterSelected.join(',');
    Tooth.selectedChildTeeth = letterDelimiter;
  }
}
