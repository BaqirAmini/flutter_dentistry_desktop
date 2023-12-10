import 'package:flutter/material.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/finance/fee/fee_related_fields.dart';
import 'package:flutter_dentistry/views/patients/patient_info.dart';
import 'package:flutter_dentistry/views/patients/tooth_selection_info.dart';
import 'package:flutter_dentistry/views/services/service_related_fields.dart';
import 'package:flutter_dentistry/views/staff/staff_info.dart';

class NewAppointment extends StatefulWidget {
  const NewAppointment({super.key});

  @override
  State<NewAppointment> createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {
  // This is to track current step of stepper
  int _currentStep = 0;
  final _serviceFormKey = GlobalKey<FormState>();
  final _feeFormKey = GlobalKey<FormState>();

/* ----------- New appointments step lists ----------- */
  List<Step> newApptStepList() => [
        Step(
            state: _currentStep <= 0 ? StepState.editing : StepState.complete,
            isActive: _currentStep >= 0,
            title: const Text('خدمات مورد نیاز'),
            content: Center(child: ServiceForm(formKey: _serviceFormKey))),
        Step(
          state: _currentStep <= 1 ? StepState.editing : StepState.complete,
          isActive: _currentStep >= 1,
          title: const Text('فیس'),
          content: SizedBox(
            child: Center(
              child: FeeForm(formKey: _feeFormKey),
            ),
          ),
        ),
      ];

/* -----------/. New appointments step lists ----------- */

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: Tooltip(
            message: 'رفتن به صفحه قبلی',
            child: IconButton(
              icon: const BackButtonIcon(),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: const Text('New Appointment'),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Stepper(
            controlsBuilder: (BuildContext context, ControlsDetails controls) {
              return Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: controls.onStepContinue,
                    child: Text((_currentStep == newApptStepList().length - 1)
                        ? 'ثبت کردن'
                        : 'ادامه'),
                  ),
                  TextButton(
                    onPressed: _currentStep == 0 ? null : controls.onStepCancel,
                    child: const Text('بازگشت'),
                  ),
                ],
              );
            },
            steps: newApptStepList(),
            currentStep: _currentStep,
            type: StepperType.horizontal,
            onStepCancel: () {
              print('Current Step: $_currentStep');
              setState(() {
                if (_currentStep > 0) {
                  _currentStep--;
                }
              });
            },
            onStepContinue: () async {
              if (_serviceFormKey.currentState!.validate()) {
                if (_currentStep < newApptStepList().length - 1) {
                  if (ServiceInfo.selectedServiceID == 2) {
                    if (PatientInfo.age! > 13) {
                      if (ServiceInfo.fMaterialSelected &&
                          Tooth.adultToothSelected) {
                        setState(() {
                          _currentStep++;
                        });
                      }
                    } else {
                      if (ServiceInfo.fMaterialSelected &&
                          Tooth.childToothSelected) {
                        setState(() {
                          _currentStep++;
                        });
                      }
                    }
                  } else if (ServiceInfo.selectedServiceID == 1) {
                    if (PatientInfo.age! > 13) {
                      if (Tooth.adultToothSelected) {
                        setState(() {
                          _currentStep++;
                        });
                      }
                    } else {
                      if (Tooth.childToothSelected) {
                        setState(() {
                          _currentStep++;
                        });
                      }
                    }
                  } else if (ServiceInfo.selectedServiceID == 3) {
                    if (ServiceInfo.levelSelected) {
                      setState(() {
                        _currentStep++;
                      });
                    }
                  } else if (ServiceInfo.selectedServiceID == 5) {
                    if (ServiceInfo.defaultOrthoType != null) {
                      setState(() {
                        _currentStep++;
                      });
                    }
                  } else if (ServiceInfo.selectedServiceID == 7) {
                    if (ServiceInfo.defaultMaxillo != null) {
                      if (ServiceInfo.defaultMaxillo == 'Tooth Extraction' ||
                          ServiceInfo.defaultMaxillo ==
                              'Tooth Reimplantation') {
                        if (PatientInfo.age! > 13) {
                          if (Tooth.adultToothSelected) {
                            setState(() {
                              _currentStep++;
                            });
                          }
                        } else {
                          if (Tooth.childToothSelected) {
                            setState(() {
                              _currentStep++;
                            });
                          }
                        }
                      } else if (ServiceInfo.defaultMaxillo ==
                          'Abscess Treatment') {
                        if (ServiceInfo.defaultGumAbscess != null) {
                          setState(() {
                            _currentStep++;
                          });
                        }
                      } else {
                        setState(() {
                          _currentStep++;
                        });
                      }
                    }
                  } else if (ServiceInfo.selectedServiceID == 9) {
                    if (ServiceInfo.defaultDentureValue != null) {
                      setState(() {
                        _currentStep++;
                      });
                    }
                  } else if (ServiceInfo.selectedServiceID == 11 &&
                      (ServiceInfo.defaultCrown != null ||
                          ServiceInfo.defaultCrown.toString().isNotEmpty)) {
                    if (PatientInfo.age! > 13) {
                      if (Tooth.adultToothSelected) {
                        setState(() {
                          _currentStep++;
                        });
                      }
                    } else {
                      if (Tooth.childToothSelected) {
                        setState(() {
                          _currentStep++;
                        });
                      }
                    }
                  } else if (ServiceInfo.selectedServiceID == 15) {
                    if (PatientInfo.age! > 13) {
                      if (Tooth.adultToothSelected) {
                        setState(() {
                          _currentStep++;
                        });
                      }
                    } else {
                      if (Tooth.childToothSelected) {
                        setState(() {
                          _currentStep++;
                        });
                      }
                    }
                  } else {
                    setState(() {
                      _currentStep++;
                    });
                  }
                } else if (_feeFormKey.currentState!.validate()) {
                  // First give time to insert into patient_services table
                  if (await AppointmentFunction.onAddServiceReq(
                      PatientInfo.patID!,
                      ServiceInfo.selectedServiceID!,
                      ServiceInfo.serviceNote)) {
                    if (await AppointmentFunction.onAddAppointment(
                        PatientInfo.patID!,
                        ServiceInfo.selectedServiceID!,
                        ServiceInfo.meetingDate!,
                        StaffInfo.staffID!)) {
                      Navigator.pop(context);
                    }
                  }
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

// Create a class with static functions which is required for new appointments.
class AppointmentFunction {
  // This function creates service requirements into patient_services table.
  static Future<bool> onAddServiceReq(
      int patientId, int serviceId, String? desc) async {
    try {
      final conn = await onConnToDb();
      if (ServiceInfo.selectedServiceID == 1) {
        await conn.query(
            'INSERT INTO patient_services (pat_ID, ser_ID, req_ID, value) VALUES (?, ?, ?, ?), (?, ?, ?, ?)',
            [
              patientId,
              serviceId,
              1,
              (Tooth.adultToothSelected)
                  ? Tooth.selectedAdultTeeth
                  : Tooth.selectedChildTeeth,
              patientId,
              serviceId,
              2,
              desc
            ]);
      } else if (ServiceInfo.selectedServiceID == 2) {
        await conn.query(
            'INSERT INTO patient_services (pat_ID, ser_ID, req_ID, value) VALUES (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?)',
            [
              patientId,
              serviceId,
              1,
              (Tooth.adultToothSelected)
                  ? Tooth.selectedAdultTeeth
                  : Tooth.selectedChildTeeth,
              patientId,
              serviceId,
              2,
              desc,
              patientId,
              serviceId,
              3,
              ServiceInfo.fillingGroupValue,
              patientId,
              serviceId,
              4,
              ServiceInfo.defaultFilling
            ]);
      } else if (ServiceInfo.selectedServiceID == 3) {
        await conn.query(
            'INSERT INTO patient_services (pat_ID, ser_ID, req_ID, value) VALUES (?, ?, ?, ?), (?, ?, ?, ?)',
            [
              patientId,
              serviceId,
              2,
              desc,
              patientId,
              serviceId,
              5,
              ServiceInfo.defaultBleachValue
            ]);
      } else if (ServiceInfo.selectedServiceID == 4) {
        await conn.query(
            'INSERT INTO patient_services (pat_ID, ser_ID, req_ID, value) VALUES (?, ?, ?, ?), (?, ?, ?, ?)',
            [
              patientId,
              serviceId,
              2,
              desc,
              patientId,
              serviceId,
              3,
              ServiceInfo.spGroupValue
            ]);
      } else if (ServiceInfo.selectedServiceID == 5) {
        await conn.query(
            'INSERT INTO patient_services (pat_ID, ser_ID, req_ID, value) VALUES (?, ?, ?, ?), (?, ?, ?, ?)',
            [
              patientId,
              serviceId,
              2,
              desc,
              patientId,
              serviceId,
              4,
              ServiceInfo.defaultOrthoType
            ]);
      } else if (ServiceInfo.selectedServiceID == 7) {
        if (ServiceInfo.defaultMaxillo == 'Tooth Extraction') {
          await conn.query(
              'INSERT INTO patient_services (pat_ID, ser_ID, req_ID, value) VALUES (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?)',
              [
                patientId,
                serviceId,
                3,
                ServiceInfo.defaultMaxillo,
                patientId,
                serviceId,
                1,
                (Tooth.adultToothSelected)
                    ? Tooth.selectedAdultTeeth
                    : Tooth.selectedChildTeeth,
                patientId,
                serviceId,
                2,
                desc
              ]);
        } else if (ServiceInfo.defaultMaxillo == 'Abscess Treatment') {
          await conn.query(
              'INSERT INTO patient_services (pat_ID, ser_ID, req_ID, value) VALUES (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?)',
              [
                patientId,
                serviceId,
                3,
                ServiceInfo.defaultMaxillo,
                patientId,
                serviceId,
                7,
                ServiceInfo.defaultGumAbscess,
                patientId,
                serviceId,
                9,
                ServiceInfo.defaultOrthoType,
                patientId,
                serviceId,
                2,
                desc
              ]);
        } else if (ServiceInfo.defaultMaxillo == 'T.M.J') {
          await conn.query(
              'INSERT INTO patient_services (pat_ID, ser_ID, req_ID, value) VALUES (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?)',
              [
                patientId,
                serviceId,
                3,
                ServiceInfo.defaultMaxillo,
                patientId,
                serviceId,
                9,
                ServiceInfo.abscessTreatValue,
                patientId,
                serviceId,
                2,
                desc
              ]);
        } else if (ServiceInfo.defaultMaxillo == 'Tooth Reimplantation') {
          await conn.query(
              'INSERT INTO patient_services (pat_ID, ser_ID, req_ID, value) VALUES (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?)',
              [
                patientId,
                serviceId,
                3,
                ServiceInfo.defaultMaxillo,
                patientId,
                serviceId,
                1,
                (Tooth.adultToothSelected)
                    ? Tooth.selectedAdultTeeth
                    : Tooth.selectedChildTeeth,
                patientId,
                serviceId,
                2,
                desc
              ]);
        } else {
          await conn.query(
              'INSERT INTO patient_services (pat_ID, ser_ID, req_ID, value) VALUES (?, ?, ?, ?)',
              [patientId, serviceId, 2, desc]);
        }
      } else if (ServiceInfo.selectedServiceID == 9) {
        if (ServiceInfo.dentureGroupValue == 'Partial') {
          await conn.query(
              'INSERT INTO patient_services (pat_ID, ser_ID, req_ID, value) VALUES (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?)',
              [
                patientId,
                serviceId,
                3,
                ServiceInfo.dentureGroupValue,
                patientId,
                serviceId,
                1,
                (Tooth.adultToothSelected)
                    ? Tooth.selectedAdultTeeth
                    : Tooth.selectedChildTeeth,
                patientId,
                serviceId,
                2,
                desc
              ]);
        } else {
          await conn.query(
              'INSERT INTO patient_services (pat_ID, ser_ID, req_ID, value) VALUES (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?)',
              [
                patientId,
                serviceId,
                3,
                ServiceInfo.dentureGroupValue,
                patientId,
                serviceId,
                7,
                ServiceInfo.defaultDentureValue,
                patientId,
                serviceId,
                2,
                desc
              ]);
        }
      } else if (ServiceInfo.selectedServiceID == 11) {
        await conn.query(
            'INSERT INTO patient_services (pat_ID, ser_ID, req_ID, value) VALUES (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?), (?, ?, ?, ?)',
            [
              patientId,
              serviceId,
              1,
              (Tooth.adultToothSelected)
                  ? Tooth.selectedAdultTeeth
                  : Tooth.selectedChildTeeth,
              patientId,
              serviceId,
              3,
              ServiceInfo.crownGroupValue,
              patientId,
              serviceId,
              4,
              ServiceInfo.defaultCrown,
              patientId,
              serviceId,
              2,
              desc
            ]);
      } else if (ServiceInfo.selectedServiceID == 15) {
        await conn.query(
            'INSERT INTO patient_services (pat_ID, ser_ID, req_ID, value) VALUES (?, ?, ?, ?), (?, ?, ?, ?)',
            [
              patientId,
              serviceId,
              1,
              (Tooth.adultToothSelected)
                  ? Tooth.selectedAdultTeeth
                  : Tooth.selectedChildTeeth,
              patientId,
              serviceId,
              2,
              desc
            ]);
      } else {
        await conn.query(
            'INSERT INTO patient_services (pat_ID, ser_ID, req_ID, value) VALUES (?, ?, ?, ?)',
            [patientId, serviceId, 2, desc]);
      }
      return true;
    } catch (e) {
      print('Inserting into patient_services field since: $e');
      return false;
    }
  }

// This function inserts appointments into appointments table when called.
  static Future<bool> onAddAppointment(
      int patient, int service, String meetDate, int staff) async {
    try {
      final conn = await onConnToDb();
      // Now create appointments
      await conn.query(
          'INSERT INTO appointments (pat_ID, service_ID, installment, round, discount, paid_amount, due_amount, meet_date, staff_ID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            patient,
            service,
            FeeInfo.installment,
            1,
            FeeInfo.discountRate,
            FeeInfo.receivedAmount,
            FeeInfo.dueAmount,
            meetDate,
            staff
          ]);
      return true;
    } catch (e) {
      print('The data failed to insert into appointments since: $e');
      return false;
    }
  }
}