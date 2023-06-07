import 'package:flutter/material.dart';

class ServicesTile extends StatelessWidget {
  const ServicesTile({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 5,
            children: <Widget>[
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    print('First tile clicked.');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[200],
                    child: onSetTileContent(
                      Icons.light_mode,
                      'معاینه دهن',
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    print('Second tile clicked.');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[200],
                    child: onSetTileContent(
                      Icons.light_mode,
                      'پر کاری دندان',
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    print('Third tile clicked.');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[200],
                    child: onSetTileContent(
                      Icons.light_mode,
                      'جرم گیری دندان',
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    print('Fourth tile clicked.');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[200],
                    child: onSetTileContent(
                      Icons.light_mode,
                      'جراحی لثه دندان',
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    print('Fifth tile clicked.');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[200],
                    child: onSetTileContent(
                      Icons.light_mode,
                      'جراحی ریشه دندان',
                    ),
                  ),
                ),
              ),
             MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    print('Sixth tile clicked.');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[200],
                    child: onSetTileContent(
                      Icons.light_mode,
                      'سفید کردن دندان',
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    print('Seventh tile clicked.');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[200],
                    child: onSetTileContent(
                      Icons.light_mode,
                      'ارتودانسی',
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    print('Eighth tile clicked.');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[200],
                    child: onSetTileContent(
                      Icons.light_mode,
                      'پروتز دندان',
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    print('Ninth tile clicked.');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[200],
                    child: onSetTileContent(
                      Icons.light_mode,
                      'کشیدن دندان',
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    print('Tenth tile clicked.');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[200],
                    child: onSetTileContent(
                      Icons.light_mode,
                      'پوش کردن دندان',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// Set icon and text as contents of any tile.
  onSetTileContent(IconData myIcon, String myText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(myIcon, size: 40.0, color: Colors.blue,),
        Text(myText, style: const TextStyle(color: Colors.blue, fontSize: 25.0),),
      ],
    );
  }

  
}
