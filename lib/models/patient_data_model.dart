class Patients
{
  String? firstName;
  String? lastName;
  int? age;
  String? position;
  String? service;

  Patients({this.firstName, this.lastName, this.age, this.position, this.service});
}

 List<Patients> allPatients = [
  Patients(firstName: "Ali", lastName: "Hussaini", age: 12, position: "no position", service: "Tooth Bleaching"),
];
