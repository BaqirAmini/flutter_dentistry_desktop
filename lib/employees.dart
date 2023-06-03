import 'package:flutter/material.dart';

void main() {
  return runApp(const Employee());
}

class Employee extends StatelessWidget {
  const Employee({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('کارمندان'),
          ),
          body: const MyDataTable(),
        ),
      ),
    );
  }
}

// Data table widget is here
class MyDataTable extends StatefulWidget {
  const MyDataTable({super.key});

  @override
  _MyDataTableState createState() => _MyDataTableState();
}

class _MyDataTableState extends State<MyDataTable> {
  // The original data source
  final List<MyData> _data = [
    MyData('احمد', 'کریمی', 'داکتر', const Icon(Icons.list), const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('سحر', 'قریشی', 'نرس', const Icon(Icons.list), const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('میرویس', 'فاتح', 'کارمند مالی', const Icon(Icons.list), const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('فیض', 'فهیمی', 'کمپوتر کار', const Icon(Icons.list), const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('بهمن', 'فهیمی', 'کمپوتر کار', const Icon(Icons.list), const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('حامد', 'حکیمی', 'نرس', const Icon(Icons.list), const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('مریم', 'رضایی', 'نرس', const Icon(Icons.list), const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('بصیر', 'عسکری', 'داکتر', const Icon(Icons.list), const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('حسین', 'احسانی', 'کارمند لابراتوار', const Icon(Icons.list), const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('مراد', 'بیگ', 'کارمند لابراتوار', const Icon(Icons.list), const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('Ali', 'Bieg', 'Financial', const Icon(Icons.list), const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('Reza', 'Rezaie', 'Services Provider', const Icon(Icons.list), const Icon(Icons.edit), const Icon(Icons.delete)),
  ];

// The filtered data source
  late List<MyData> _filteredData;

// The text editing controller for the search TextField
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
// Set the filtered data to the original data at first
    _filteredData = _data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 400.0,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'جستجو...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _filteredData = _data;
                        });
                      },
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filteredData = _data
                          .where((element) => element.firstName
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.print),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('افزودن کارمند جدید'),
              ),
            ],
          ),
        ),
        PaginatedDataTable(
          header: const Text("همه کارمندان"),
          columns: const [
            DataColumn(label: Text("اسم")),
            DataColumn(label: Text("تخلص")),
            DataColumn(label: Text("مقام")),
            DataColumn(label: Text("شرح")),
            DataColumn(label: Text("تغییر")),
            DataColumn(label: Text("حذف")),
          ],
          source: MyDataSource(_filteredData),
          rowsPerPage: _filteredData.length < 5 ? _filteredData.length : 5,
        )
      ],
    ));
  }
}

class MyDataSource extends DataTableSource {
  final List<MyData> data;

  MyDataSource(this.data);

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(data[index].firstName)),
      DataCell(Text(data[index].lastName)),
      DataCell(Text(data[index].position)),
      DataCell(IconButton(icon: data[index].employeeDetail, onPressed: (() { print('Details clicked.'); }),)),
      DataCell(IconButton(icon: data[index].editEmployee, onPressed: (() { print('Edit clicked.'); }),)),
      DataCell(IconButton(icon: data[index].deleteEmployee, onPressed: (() {}),)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class MyData {
  final String firstName;
  final String lastName;
  final String position;
  final Icon employeeDetail;
  final Icon editEmployee;
  final Icon deleteEmployee;

  MyData(this.firstName, this.lastName, this.position, this.employeeDetail, this.editEmployee, this.deleteEmployee);
}
