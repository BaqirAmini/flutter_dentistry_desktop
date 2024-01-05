import 'package:flutter/material.dart';
import 'package:flutter_dentistry/views/patients/tooth_selection_info.dart';

class AdultQuadrantGrid extends StatefulWidget {
  const AdultQuadrantGrid({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdultQuadrantGrid createState() => _AdultQuadrantGrid();
}

class _AdultQuadrantGrid extends State<AdultQuadrantGrid> {
  final List<String> _selectedTeethNum = [];
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
                  if (_selectedTeethNum.contains(id)) {
                    _selectedTeethNum.remove(id);
                  } else {
                    _selectedTeethNum.add(id);
                  }
                  _onArrangeAdultSelectedTeeth(_selectedTeethNum);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: _selectedTeethNum.contains(id)
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
    Tooth.adultToothSelected = _selectedTeethNum.isEmpty ? false : true;
    return InputDecorator(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: _selectedTeethNum.isEmpty
            ? 'Please select a tooth'
            : 'Adults\' Teeth Selection Chart',
        contentPadding: const EdgeInsets.all(20),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        labelStyle: TextStyle(
            color: _selectedTeethNum.isEmpty ? Colors.red : Colors.blue,
            fontSize: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(
              color: _selectedTeethNum.isEmpty ? Colors.red : Colors.blue),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
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
                      List<int>.generate(
                        8,
                        (i) => (i + 1),
                      ).reversed.toList(),
                    ),
                    _buildQuadrantWithLabel(
                      'Q1',
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
                      'Q3',
                      List<int>.generate(
                        8,
                        (i) => (i + 1),
                      ).reversed.toList(),
                    ),
                    _buildQuadrantWithLabel(
                      'Q4',
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

  void _onArrangeAdultSelectedTeeth(List<String> toothNumSelected) {
    var letterDelimiter = toothNumSelected.join(',');
    Tooth.selectedAdultTeeth = letterDelimiter;
  }
}
