import 'package:flutter/material.dart';

class StaffMoreDetail extends StatefulWidget {
  const StaffMoreDetail({super.key});

  @override
  State<StaffMoreDetail> createState() => _StaffMoreDetailState();
}

class _StaffMoreDetailState extends State<StaffMoreDetail> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Card(
              child: Stack(
                children: [
                  Positioned(
                    top: 8.0,
                    left: 8.0,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  const Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: Text(
                      'معلومات شخصی',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  const Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30.0,
                        ),
                        Text('Ali Ahmadi'),
                        Text('Dentist'),
                        SizedBox(
                          height: 20.0,
                        ),
                        Column(
                          children: [
                            Text('نام'),
                            Text('علی'),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Column(
                          children: [
                            Text('نمبر تذکره'),
                            Text('1399-1205-56273'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
