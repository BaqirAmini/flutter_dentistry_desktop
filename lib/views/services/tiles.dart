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
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: Card(
                  child: Stack(
                    children: [
                      Center(
                        child: onSetTileContent(
                            Icons.light_mode, 'معاینه دهن', 1000),
                      ),
                      Positioned(
                        top: 8.0,
                        left: 8.0,
                        child: PopupMenuButton(
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.list),
                                        title: Text('جزییات'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('تغییر دادن'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('حذف کردن'),
                                      ),
                                    ),
                                  ),
                                ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: Card(
                  child: Stack(
                    children: [
                      Center(
                        child: onSetTileContent(
                            Icons.light_mode, 'معاینه دهن', 1000),
                      ),
                      Positioned(
                        top: 8.0,
                        left: 8.0,
                        child: PopupMenuButton(
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.list),
                                        title: Text('جزییات'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('تغییر دادن'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('حذف کردن'),
                                      ),
                                    ),
                                  ),
                                ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: Card(
                  child: Stack(
                    children: [
                      Center(
                        child: onSetTileContent(
                            Icons.light_mode, 'معاینه دهن', 1000),
                      ),
                      Positioned(
                        top: 8.0,
                        left: 8.0,
                        child: PopupMenuButton(
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.list),
                                        title: Text('جزییات'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('تغییر دادن'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('حذف کردن'),
                                      ),
                                    ),
                                  ),
                                ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: Card(
                  child: Stack(
                    children: [
                      Center(
                        child: onSetTileContent(
                            Icons.light_mode, 'معاینه دهن', 1000),
                      ),
                      Positioned(
                        top: 8.0,
                        left: 8.0,
                        child: PopupMenuButton(
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.list),
                                        title: Text('جزییات'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('تغییر دادن'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('حذف کردن'),
                                      ),
                                    ),
                                  ),
                                ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: Card(
                  child: Stack(
                    children: [
                      Center(
                        child: onSetTileContent(
                            Icons.light_mode, 'معاینه دهن', 1000),
                      ),
                      Positioned(
                        top: 8.0,
                        left: 8.0,
                        child: PopupMenuButton(
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.list),
                                        title: Text('جزییات'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('تغییر دادن'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('حذف کردن'),
                                      ),
                                    ),
                                  ),
                                ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: Card(
                  child: Stack(
                    children: [
                      Center(
                        child: onSetTileContent(
                            Icons.light_mode, 'معاینه دهن', 1000),
                      ),
                      Positioned(
                        top: 8.0,
                        left: 8.0,
                        child: PopupMenuButton(
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.list),
                                        title: Text('جزییات'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('تغییر دادن'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('حذف کردن'),
                                      ),
                                    ),
                                  ),
                                ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: Card(
                  child: Stack(
                    children: [
                      Center(
                        child: onSetTileContent(
                            Icons.light_mode, 'معاینه دهن', 1000),
                      ),
                      Positioned(
                        top: 8.0,
                        left: 8.0,
                        child: PopupMenuButton(
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.list),
                                        title: Text('جزییات'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('تغییر دادن'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('حذف کردن'),
                                      ),
                                    ),
                                  ),
                                ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: Card(
                  child: Stack(
                    children: [
                      Center(
                        child: onSetTileContent(
                            Icons.light_mode, 'معاینه دهن', 1000),
                      ),
                      Positioned(
                        top: 8.0,
                        left: 8.0,
                        child: PopupMenuButton(
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.list),
                                        title: Text('جزییات'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('تغییر دادن'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('حذف کردن'),
                                      ),
                                    ),
                                  ),
                                ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: Card(
                  child: Stack(
                    children: [
                      Center(
                        child: onSetTileContent(
                            Icons.light_mode, 'معاینه دهن', 1000),
                      ),
                      Positioned(
                        top: 8.0,
                        left: 8.0,
                        child: PopupMenuButton(
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.list),
                                        title: Text('جزییات'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('تغییر دادن'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('حذف کردن'),
                                      ),
                                    ),
                                  ),
                                ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: Card(
                  child: Stack(
                    children: [
                      Center(
                        child: onSetTileContent(
                            Icons.light_mode, 'معاینه دهن', 1000),
                      ),
                      Positioned(
                        top: 8.0,
                        left: 8.0,
                        child: PopupMenuButton(
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.list),
                                        title: Text('جزییات'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('تغییر دادن'),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('حذف کردن'),
                                      ),
                                    ),
                                  ),
                                ]),
                      ),
                    ],
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
  onSetTileContent(IconData myIcon, String myText, int price) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.blue,
          child: Icon(Icons.light_mode, color: Colors.white),
        ),
        // SizedBox(height: 10.0,),
        Text(
          myText,
          style: const TextStyle(fontSize: 22.0),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          '$price افغانی',
          style: const TextStyle(
              fontSize: 14.0, color: Color.fromARGB(255, 105, 101, 101)),
        ),
      ],
    );
  }
}
