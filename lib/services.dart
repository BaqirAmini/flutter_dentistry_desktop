import 'package:flutter/material.dart';
import 'views/services/tiles.dart';

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
          appBar: AppBar(
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
              Tooltip(
                message: 'افزودن خدمات',
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.medical_services_outlined),
                ),
              ),
              const SizedBox(width: 20),
              Tooltip(
                message: 'رفتن به داشبورد',
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.home_outlined),
                ),
              ),
            ],
            leading: Tooltip(
              message: 'رفتن به صفحه قبلی',
              child: IconButton(
                onPressed: () {},
                icon: const BackButtonIcon(),
              ),
            ),
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

  onAddDetalService()
  {
    
  }
}
