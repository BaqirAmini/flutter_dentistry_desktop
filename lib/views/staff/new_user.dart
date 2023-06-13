import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewUser extends StatefulWidget {
  const NewUser({super.key});

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
// position types dropdown variables
  String positionDropDown = 'داکتر دندان';
  var positionItems = [
    'داکتر دندان',
    'نرس',
    'مدیر سیستم',
  ];
// The global for the form
  final _formKey = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
  final _userNameController = TextEditingController();
  final _unConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: 500.0,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: const Text(
                    'لطفا یوزنیم، رمز و وظیفه را با دقت در خانه های مربوط شان درج نمایید.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _userNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'یوزنیم (نام کاربری)',
                      suffixIcon: Icon(Icons.person_outline_sharp),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _userNameController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'رمز',
                      suffixIcon: Icon(Icons.password_rounded),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _unConfirmController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'تکرار رمز',
                      hintText: 'هر آنچه که در اینجا وارد میکنید باید با رمز تان مطابقت کند',
                      suffixIcon: Icon(Icons.password_rounded),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'عنوان وظیفه',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: SizedBox(
                        height: 26.0,
                        child: DropdownButton(
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          value: positionDropDown,
                          items: positionItems.map((String positionItems) {
                            return DropdownMenuItem(
                              value: positionItems,
                              alignment: Alignment.centerRight,
                              child: Text(positionItems),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              positionDropDown = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 400.0,
                  height: 35.0,
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('ثبت کردن'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
