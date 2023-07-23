import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'package:flutter_dentistry/views/services/tiles.dart';

void main() => runApp(const Service());

class Service extends StatefulWidget {
  const Service({super.key});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  final TextEditingController _searchQuery = TextEditingController();
  bool _isSearching = false;
  String _searchText = "";
  late List<String> _list;
  List<String> _searchList = [];

  @override
  void initState() {
    super.initState();
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
          _buildSearchList();
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
          _buildSearchList();
        });
      }
    });
  }

  List<String> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _searchList = _list;
    } else {
      _searchList = _list
          .where((element) =>
              element.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
      return _searchList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 234, 231, 231),
          appBar: AppBar(
            leading:   Tooltip(
                message: 'رفتن به داشبورد',
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Dashboard(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.home_outlined),
                ),
              ),
            actions: [
              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search),
                onPressed: () {
                  setState(() {
                    if (_isSearching) {
                      _isSearching = false;
                      _searchQuery.clear();
                    } else {
                      _isSearching = true;
                    }
                  });
                },
              ),
              const SizedBox(width: 20),
              Builder(builder: (context) {
                return Tooltip(
                  message: 'افزودن خدمات',
                  child: IconButton(
                    onPressed: () {
                      onCreateDentalService(context);
                    },
                    icon: const Icon(Icons.medical_services_outlined),
                  ),
                );
              }),
              const SizedBox(width: 20),
            
            ],
            title: _isSearching
                ? TextField(
                    controller: _searchQuery,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "جستجو...",
                        hintStyle: TextStyle(color: Colors.white)),
                  )
                : const Text("خدمات ما"),
          ),
          body: const ServicesTile(),
        ),
      ),
    );
  }

  // This dialog creates a new Service
  onCreateDentalService(BuildContext context) {
// The global for the form
    final formKey = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
    final nameController = TextEditingController();
    final feeController = TextEditingController();

    return showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'ایجاد سرویس جدید',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Form(
              key: formKey,
              child: SizedBox(
                width: 500.0,
                height: 190.0,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'نام سرویس (خدمات)',
                          suffixIcon: Icon(Icons.medical_services_sharp),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.blue)),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: feeController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'فیس تعیین شده',
                          suffixIcon: Icon(Icons.money),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.blue)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('لغو')),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('ایجاد کردن'),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
