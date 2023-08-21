import 'dart:io';
import 'dart:typed_data';

import 'package:el_kemma_optics/functions.dart';
import 'package:el_kemma_optics/prescriptions.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:el_kemma_optics/db_connection.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/src/painting/box_border.dart' as box;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';




class ClientsWindow extends StatelessWidget {
  const ClientsWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز عيون'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "التعامل مع العملاء",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 80),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddClientWindow()),
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(225, 35)),
                ),
                child: const Text(
                  'اضافة عميل',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FindClientWindow()),
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(225, 35)),
                ),
                child: const Text(
                  'البحث عن عميل محدد',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchClientWindow()),
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(225, 35)),
                ),
                child: const Text(
                  'اصدار تقرير عن العملاء',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(225, 35)),
                ),
                child: const Text(
                  'تحديث بيانات عميل',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(225, 35)),
                ),
                child: const Text(
                  'حذف عميل',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}


class AddClientWindow extends StatefulWidget {
  const AddClientWindow({Key? key}) : super(key: key);

  @override
  _AddClientWindowState createState() => _AddClientWindowState();
}
class _AddClientWindowState extends State<AddClientWindow> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController clientName = TextEditingController();
  final TextEditingController phoneNumber1 = TextEditingController();
  final TextEditingController phoneNumber2 = TextEditingController();
  final TextEditingController clientEmail = TextEditingController();
  String clientGender = "";
  DateTime? selectedDate;
  Gender? selectedGender;



  void insertClientData() {

    String name = clientName.text;
    String phone1 = phoneNumber1.text;
    String phone2 = phoneNumber2.text;
    String birthDate = selectedDate.toString();
    String gender = clientGender;

    String query = 'INSERT INTO clients (client_name, client_phone1, client_phone2, client_birth_date, client_gender) VALUES (?, ?, ?, ?, ?)';

    List<dynamic> params = [name, phone1, phone2, birthDate, gender];

    executeQuery(query, params);



    setState(() {});

    clientName.clear();
    phoneNumber1.clear();
    phoneNumber2.clear();
    clientEmail.clear();
    selectedDate = null;
    selectedGender = null;
    clientGender = "";

    showMessage(context, "تم اضافة العميل بنجاح");

  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز عيون'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "اضافة عميل جديد",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 250,
                        height: 50,
                        child: Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: TextFormField(
                            textAlign: TextAlign.right,
                            controller: clientName,
                            decoration: const InputDecoration(
                              labelText: 'الأسم',
                              border: OutlineInputBorder(),
                            ),

                            style: const TextStyle(fontSize: 13),
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'يجب ادخال تلك الخانة';
                              }
                              return null;
                            },
                          ),
                        )
                    ),
                  ],
                ),
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: TextFormField(
                          controller: phoneNumber1,
                          decoration: const InputDecoration(
                            labelText: "رقم الهاتف 1",
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 15),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'يجب ادخال تلك الخانة';
                            }
                            return null;
                          },
                        ),
                      )
                    ),
                  ],
                ),
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: TextField(
                          controller: phoneNumber2,
                          decoration: const InputDecoration(
                            labelText: "رقم الهاتف 2",
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 15),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25,),
                Row(
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: AbsorbPointer(
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 250,
                              height: 50,
                              child: Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: TextFormField(
                                  onTap: () => _selectDate(context),
                                  controller: TextEditingController(
                                    text: selectedDate == null
                                        ? "اختار تاريخ الميلاد"
                                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                  ),
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: "تاريخ الميلاد",
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      onPressed: () => _selectDate(context),
                                      icon: const Icon(Icons.calendar_today),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25,),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 260,
                    height: 50,
                    child: Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: TextField(
                        controller: clientEmail,
                        decoration: const InputDecoration(
                          labelText: "البريد الألكتروني",
                          border: OutlineInputBorder(),
                        ),
                        style: const TextStyle(fontSize: 13),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    )
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      const Text("انثى"),
                      Radio<Gender>(
                        value: Gender.Female,
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                            clientGender = "انثى";
                          });
                        },
                      ),


                      const SizedBox(width: 10),
                      const Text("ذكر"),
                      Radio<Gender>(
                        value: Gender.Male,
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                            clientGender = "ذكر";
                          });
                        },
                      ),

                      const SizedBox(width: 15),

                      const Text(
                        "النوع",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      insertClientData();

                    }
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(100, 35)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    "اضافة عميل",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
enum Gender {
  Male,
  Female,
}

class Prescription {
  final int prescriptionId;
  final int clientId;
  final String clientName;
  final String prescriptionDate;
  final String rSphD;
  final String rCylD;
  final String rAxisD;
  final String rSphR;
  final String rCylR;
  final String rAxisR;
  final String lSphD;
  final String lCylD;
  final String lAxisD;
  final String lSphR;
  final String lCylR;
  final String lAxisR;
  final int ipd;
  final int doctorId;
  final String doctorName;
  final String prescriptionType;
  final String lensType;
  final String lensColor;
  final String solutionType;
  final String paymentMethod;
  final double totalPrice;

  Prescription({
    required this.prescriptionId,
    required this.clientId,
    required this.clientName,
    required this.prescriptionDate,
    required this.rSphD,
    required this.rCylD,
    required this.rAxisD,
    required this.rSphR,
    required this.rCylR,
    required this.rAxisR,
    required this.lSphD,
    required this.lCylD,
    required this.lAxisD,
    required this.lSphR,
    required this.lCylR,
    required this.lAxisR,
    required this.ipd,
    required this.doctorId,
    required this.doctorName,
    required this.prescriptionType,
    required this.lensType,
    required this.lensColor,
    required this.solutionType,
    required this.paymentMethod,
    required this.totalPrice,
  });

// Add any helper methods or additional constructors if needed
}


class FindClientWindow extends StatefulWidget {

  @override
  _FindClientWindowState createState(){
    return _FindClientWindowState();
  }
}

class _FindClientWindowState extends State<FindClientWindow> {

  TextEditingController phoneNumberController = TextEditingController();
  List<String> options = [];
  List<String> fetchedClients = [];
  String? selectedOption; // Declare the selected option variable
  bool isPhoneNumberFound = true;



  void updateOptions(String phoneNumber) async {
    Future<void> getNames() async {

      // final MySqlConnection connection = await getDBConnection();
      // var results = await connection.query(
      //     'select client_name from clients where client_phone1 = ? or client_phone2 = ?',
      //     [phoneNumber, phoneNumber]);

      String query = 'select client_name from clients where client_phone1 = ? or client_phone2 = ?';
      List<dynamic> params = [phoneNumber, phoneNumber];
      List<Map<String, dynamic>> fetchedData = await getData(query, params);

      fetchedClients = [];
      if (fetchedData.isNotEmpty) {
        for (var row in fetchedData) {
          var clientName = row['client_name'].toString();
          fetchedClients.add(clientName);
        }
        setState(() {
          isPhoneNumberFound = true;
          options = fetchedClients;
          selectedOption = options.isNotEmpty ? options[0] : null;
        });
      } else {
        setState(() {
          isPhoneNumberFound = false;
          options = [];
          selectedOption = null;
        });
      }
    }

    setState(() {
      myPhone = phoneNumberController.text;
      print(myPhone);
    });

    await getNames();

  }

  List<String> eye_power = ['0','0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'];

  int prescriptionId = 0;
  int clientId = 0;
  String clientName = 'لا يوجد';
  String prescriptionDate = 'لا يوجد';
  int ipd = 0;
  int doctorId = 0;
  String doctorName = 'لا يوجد';
  int age = 0;
  String clientPhone1 = 'لا يوجد';
  String clientPhone2 = 'لا يوجد';
  String clientGender = 'لا يوجد';
  String clientEmail = 'لا يوجد';
  String prescType = 'لا يوجد';
  String lensType = 'لا يوجد';
  String lensColor = 'لا يوجد';
  String solutionType = 'لا يوجد';
  String paymentMethod = 'لا يوجد';
  double price = 0;

  Future<void> findClient() async {


    String client_Name = selectedOption.toString();
    String phone = phoneNumberController.text;

    // var result = await connection.query('select client_id from clients where client_name = ? and (client_phone1 = ? or client_phone2 = ?)',
    //     [client_Name, phone, phone]);

    String query = 'select client_id from clients where client_name = ? and (client_phone1 = ? or client_phone2 = ?)';
    List<dynamic> params =  [client_Name, phone, phone];
    List<Map<String, dynamic>> fetchedData = await getData(query, params);
    int client_Id = int.parse(fetchedData[0]['client_id']);



    query = 'SELECT * FROM prescriptions WHERE client_id = ? ORDER BY prescription_date DESC LIMIT 1';
    params = [client_Id];
    fetchedData = await getData(query, params);

    if (fetchedData.isNotEmpty) {
      // Assuming you have a Prescription class to hold the data, adapt this based on your actual table structure
      final row = fetchedData[0];
      final prescription = Prescription(
        prescriptionId: int.parse(row['prescription_id']),
        clientId: int.parse(row['client_id']),
        clientName: row['client_name'].toString(),
        prescriptionDate: row['prescription_date'].toString(),
        rSphD: row['r_sph_d'].toString(),
        rCylD: row['r_cyl_d'].toString(),
        rAxisD: row['r_axis_d'].toString(),
        rSphR: row['r_sph_r'].toString(),
        rCylR: row['r_cyl_r'].toString(),
        rAxisR: row['r_axis_r'].toString(),
        lSphD: row['l_sph_d'].toString(),
        lCylD: row['l_cyl_d'].toString(),
        lAxisD: row['l_axis_d'].toString(),
        lSphR: row['l_sph_r'].toString(),
        lCylR: row['l_cyl_r'].toString(),
        lAxisR: row['l_axis_r'].toString(),
        ipd: int.parse(row['ipd']),
        doctorId: int.parse(row['doctor_id']),
        doctorName: row['doctor_name'].toString(),
        prescriptionType: row['prescription_type'].toString(),
        lensType: row['lens_type'].toString(),
        lensColor: row['lens_color'].toString(),
        solutionType: row['solution_type'].toString(),
        paymentMethod: row['payment_method'].toString(),
        totalPrice: double.parse(row['total_price']),
      );

      String formatEyePower(String power) {
        double value = double.parse(power);
        if (value == 0) {
          return '0';
        } else {
          String sign = value > 0 ? '+' : '-';
          return '$sign${value.abs()}';
        }
      }

      // var result = await connection.query('select * from clients where client_id = ?', [prescription.clientId]);

      query = 'select * from clients where client_id = ?';
      params = [prescription.clientId];
      fetchedData = await getData(query, params);



      setState(() {
        prescriptionId = prescription.prescriptionId;
        clientId = prescription.clientId;
        clientName = prescription.clientName;
        prescriptionDate = prescription.prescriptionDate;
        DateTime originalDate = DateTime.parse(prescriptionDate);
        DateFormat newDateFormat = DateFormat('dd/MM/yyyy');
        prescriptionDate = newDateFormat.format(originalDate);

        eye_power = [
          prescription.rSphD,
          prescription.rCylD,
          prescription.rAxisD,
          prescription.rSphR,
          prescription.rCylR,
          prescription.rAxisR,
          prescription.lSphD,
          prescription.lCylD,
          prescription.lAxisD,
          prescription.lSphR,
          prescription.lCylR,
          prescription.lAxisR,
        ].map((power) => formatEyePower(power)).toList();

        ipd = prescription.ipd;
        doctorId = prescription.doctorId;
        doctorName = prescription.doctorName;
        prescType = prescription.prescriptionType;
        lensType = prescription.lensType;
        lensColor = prescription.lensColor;
        solutionType = prescription.solutionType;
        paymentMethod =  prescription.paymentMethod;
        price = prescription.totalPrice;

        if(fetchedData.isNotEmpty){
          final row = fetchedData[0];
          clientPhone1 = row['client_phone1'].toString();
          clientPhone2 = row['client_phone2'].toString();
          clientGender = row['client_gender'].toString();
          final birthDate = DateTime.parse(row['client_birth_date'].toString()).toString();
          age = calculateAge(birthDate);
        }

      });


    } else {
      setState(() {

        eye_power = ['0','0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'];
        prescriptionId = 0;
        clientId = 0;
        clientName = 'لا يوجد';
        prescriptionDate = 'لا يوجد';
        ipd = 0;
        doctorId = 0;
        doctorName = 'لا يوجد';
        age = 0;
        clientPhone1 = 'لا يوجد';
        clientPhone2 = 'لا يوجد';
        clientGender = 'لا يوجد';
        clientEmail = 'لا يوجد';
        prescType = 'لا يوجد';
        lensType = 'لا يوجد';
        lensColor = 'لا يوجد';
        solutionType = 'لا يوجد';
        paymentMethod = 'لا يوجد';
        price = 0;

      });
      showMessage(context, "هذا العميل لا يمتلك اي كشوفات");
    }

  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedBirthDate) {
      setState(() {
        selectedBirthDate = picked;
      });
    }
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  String myPhone = "";




  final _formKey = GlobalKey<FormState>();

  TextEditingController clientName2 = TextEditingController();
  TextEditingController phoneNumber1 = TextEditingController();
  TextEditingController phoneNumber2 = TextEditingController();
  TextEditingController clientEmail2 = TextEditingController();
  String clientGender2 = "";
  DateTime? selectedBirthDate;
  Gender? selectedGender;



  Future<void> insertClientData() async {

    String name = clientName2.text;
    String phone1 = phoneNumber1.text;
    String phone2 = phoneNumber2.text;
    String birthDate = selectedBirthDate.toString();
    String gender = clientGender;

    String query = 'insert into clients (client_name, client_phone1, client_phone2, client_birth_date, client_gender) '
        'values (?, ?, ?, ?, ?)';
    List<dynamic> params = [name, phone1, phone2, birthDate, gender];

    executeQuery(query, params);


    String updatePhone = phoneNumberController.text;
    print(updatePhone);
    setState(() {
      phoneNumberController = TextEditingController(text: updatePhone);
      showAddClient(updatePhone); // Pass the current value of phoneNumber
    });


    clientName2.clear();
    phoneNumber1.clear();
    phoneNumber2.clear();
    selectedBirthDate = null;
    selectedGender = null;
    clientGender = "";



  }

  Container showAddClient(String phoneNumber) {

    phoneNumber1 = TextEditingController(text: phoneNumber);

    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "اضافة عميل جديد",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 250,
                    height: 50,
                    child: Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: TextFormField(
                        textAlign: TextAlign.right,
                        controller: clientName2,
                        decoration: const InputDecoration(
                          labelText: 'الأسم',
                          border: OutlineInputBorder(),
                        ),

                        style: const TextStyle(fontSize: 13),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'يجب ادخال تلك الخانة';
                          }
                          return null;
                        },
                      ),
                    )
                ),
              ],
            ),
            SizedBox(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 250,
                    height: 50,
                    child: Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: TextFormField(
                        controller: phoneNumber1,
                        decoration: const InputDecoration(
                          labelText: "رقم الهاتف 1",
                          border: OutlineInputBorder(),
                        ),
                        style: const TextStyle(fontSize: 15),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'يجب ادخال تلك الخانة';
                          }
                          return null;
                        },
                      ),
                    )
                ),
              ],
            ),
            SizedBox(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 50,
                  child: Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: TextField(
                      controller: phoneNumber2,
                      decoration: const InputDecoration(
                        labelText: "رقم الهاتف 2",
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 15),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25,),
            Row(
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      _selectBirthDate(context);
                    },
                    child: AbsorbPointer(
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 250,
                          height: 50,
                          child: Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: TextFormField(
                              onTap: () => _selectBirthDate(context),
                              controller: TextEditingController(
                                text: selectedBirthDate == null
                                    ? "اختار تاريخ الميلاد"
                                    : "${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}",
                              ),
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "تاريخ الميلاد",
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  onPressed: () => _selectBirthDate(context),
                                  icon: const Icon(Icons.calendar_today),
                                ),
                              ),
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25,),

            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Text("انثى"),
                  Radio<Gender>(
                    value: Gender.Female,
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                        clientGender = "انثى";
                      });
                    },
                  ),


                  const SizedBox(width: 10),
                  const Text("ذكر"),
                  Radio<Gender>(
                    value: Gender.Male,
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                        clientGender = "ذكر";
                      });
                    },
                  ),

                  const SizedBox(width: 15),

                  const Text(
                    "النوع",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  insertClientData();
                  showMessage(context, "تم اضافة العميل بنجاح");
                }
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(100, 35)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              child: const Text(
                "اضافة عميل",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز عيون'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "البحث عن عميل",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: 300,
                      height: 90,
                      child: Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: TextFormField(
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                            labelText: "رقم الهاتف",
                            border: const OutlineInputBorder(),
                            errorText: isPhoneNumberFound
                                ? null
                                : 'هذا الرقم غير موجود', // Show error message if phone number is not found
                          ),
                          style: const TextStyle(fontSize: 15),
                          keyboardType: TextInputType.phone,
                          onChanged: updateOptions, // Call updateOptions on phone number change
                        ),
                      ),

                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: SizedBox(
                        width: 300,
                        height: 100,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              // borderSide: BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            border: OutlineInputBorder(
                              // borderSide: BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          value: selectedOption, // Declare and initialize selectedOption
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedOption = newValue; // Update the selectedOption
                            });
                          },
                          items: options.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(
                                option,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                          hint: const Text(
                              'اسم العميل',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),

                  ),

                ],
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  findClient(); // Call the function to handle button press
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(100, 25)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: const Text(
                  "بحث",
                  style: TextStyle(fontSize: 17),
                ),
              ),
              const SizedBox(height: 50),

              RichText(
                textDirection: ui.TextDirection.rtl,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'الرقم التعريفي: ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' $clientId', // Replace 'yourVariable' with the actual variable you want to display
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal, // You can change this to bold if you want both parts to be bold
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),

              RichText(
                textDirection: ui.TextDirection.rtl,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'الأسم: ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' $clientName', // Replace 'yourVariable' with the actual variable you want to display
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal, // You can change this to bold if you want both parts to be bold
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),

              RichText(
                textDirection: ui.TextDirection.rtl,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'العمر: ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' $age', // Replace 'yourVariable' with the actual variable you want to display
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal, // You can change this to bold if you want both parts to be bold
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),

              RichText(
                textDirection: ui.TextDirection.rtl,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'أرقام الهاتف : ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' $clientPhone2 - $clientPhone1', // Replace 'yourVariable' with the actual variable you want to display
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal, // You can change this to bold if you want both parts to be bold
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              RichText(
                textDirection: ui.TextDirection.rtl,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'النوع : ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' $clientGender', // Replace 'yourVariable' with the actual variable you want to display
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal, // You can change this to bold if you want both parts to be bold
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),

              RichText(
                textDirection: ui.TextDirection.rtl,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'تاريخ اخر كشف : ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' $prescriptionDate', // Replace 'yourVariable' with the actual variable you want to display
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal, // You can change this to bold if you want both parts to be bold
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),

              RichText(
                textDirection: ui.TextDirection.rtl,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'اسم الطبيب لاخر كشف : ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' $doctorName', // Replace 'yourVariable' with the actual variable you want to display
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal, // You can change this to bold if you want both parts to be bold
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),

              RichText(
                textDirection: ui.TextDirection.rtl,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'نوع الكشف: ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' $prescType', // Replace 'yourVariable' with the actual variable you want to display
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal, // You can change this to bold if you want both parts to be bold
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const SizedBox(width: 4,),
                  RichText(
                    textDirection: ui.TextDirection.rtl,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'لون العدسة: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' $lensColor', // Replace 'yourVariable' with the actual variable you want to display
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal, // You can change this to bold if you want both parts to be bold
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4,),
                  RichText(
                    textDirection: ui.TextDirection.rtl,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'نوع العدسة: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' $lensType', // Replace 'yourVariable' with the actual variable you want to display
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal, // You can change this to bold if you want both parts to be bold
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),

              RichText(
                textDirection: ui.TextDirection.rtl,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'نوع المحلول: ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' $solutionType', // Replace 'yourVariable' with the actual variable you want to display
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal, // You can change this to bold if you want both parts to be bold
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),

              RichText(
                textDirection: ui.TextDirection.rtl,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'طريقة الدفع: ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' $paymentMethod', // Replace 'yourVariable' with the actual variable you want to display
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal, // You can change this to bold if you want both parts to be bold
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),

              RichText(
                textDirection: ui.TextDirection.rtl,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'المبلغ المدفوع: ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' $price', // Replace 'yourVariable' with the actual variable you want to display
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal, // You can change this to bold if you want both parts to be bold
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),

              SizedBox(
                // width: 600,
                // height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // width: 400,
                      height: 175,
                      decoration: BoxDecoration(
                        border: box.Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: const Text(
                                    'R',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 30,
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Sph.',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 30,
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Cyl.',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 30,
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Axis',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 2,
                                        color: Colors.black,
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Container(
                                            // width: 20,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'D.',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      border: box.Border.all(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        eye_power[0], // Replace this with the actual data for 'D.'
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Container(
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      border: box.Border.all(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        eye_power[1], // Replace this with the actual data for 'D.'
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Container(
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      border: box.Border.all(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        eye_power[2], // Replace this with the actual data for 'D.'
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5,),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Container(
                                            // width: 50,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'R.',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      border: box.Border.all(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        eye_power[3], // Replace this with the actual data for 'D.'
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Container(
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      border: box.Border.all(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        eye_power[4], // Replace this with the actual data for 'D.'
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Container(
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      border: box.Border.all(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        eye_power[5], // Replace this with the actual data for 'D.'
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5,),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 2,
                            color: Colors.black,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: const Text(
                                    'L',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 30,
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Sph.',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 30,
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Cyl.',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 30,
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Axis',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 2,
                                        color: Colors.black,
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          const SizedBox(width: 5,),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      border: box.Border.all(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        eye_power[6], // Replace this with the actual data for 'D.'
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Container(
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      border: box.Border.all(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        eye_power[7], // Replace this with the actual data for 'D.'
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Container(
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      border: box.Border.all(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        eye_power[8], // Replace this with the actual data for 'D.'
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5,),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const SizedBox(width: 5,),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      border: box.Border.all(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        eye_power[9], // Replace this with the actual data for 'D.'
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Container(
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      border: box.Border.all(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        eye_power[10], // Replace this with the actual data for 'D.'
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Container(
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      border: box.Border.all(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        eye_power[11], // Replace this with the actual data for 'D.'
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5,),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    // Add the I.P.D label and the variable value outside the box frame
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'I.P.D:',
                          style: TextStyle(
                            fontSize: 15,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: 80,
                          height: 30  ,
                          // padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: box.Border.all(color: Colors.black, width: 1),
                          ),
                          child: Text(
                            '$ipd', // Replace this with the actual variable for I.P.D
                            style: const TextStyle(fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddPrescriptionWindow(text: myPhone,))
                      );
                    },
                    style: ButtonStyle(
                      // minimumSize: MaterialStateProperty.all(const Size(100, 20)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      "اضافة كشف",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  SizedBox(width: 5),
                  // ElevatedButton(
                  //   onPressed: () {
                  //
                  //   },
                  //   style: ButtonStyle(
                  //     // minimumSize: MaterialStateProperty.all(const Size(140, 40)),
                  //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //       RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(30.0),
                  //       ),
                  //     ),
                  //   ),
                  //   child: const Text(
                  //     "الكشوفات الخاصة بالعميل",
                  //     style: TextStyle(fontSize: 12),
                  //   ),
                  // ),
                ]
              ),
              SizedBox(height: 10,),

              Visibility(
                visible: (phoneNumberController.text.length == 11 && !isPhoneNumberFound),
                child: showAddClient(phoneNumberController.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SearchClientWindow extends StatefulWidget {
  const SearchClientWindow({Key? key}) : super(key: key);

  @override
  _SearchClientWindowState createState() => _SearchClientWindowState();
}

class _SearchClientWindowState extends State<SearchClientWindow> {


  List<String> checkboxNames = [
    "الرقم التعريفي للعميل",
    "اسم العميل",
    "رقم الهاتف 1",
    "رقم الهاتف 2",
    "العمر",
    "النوع",
  ];

  List<DataColumn> createDataColumns() {
    return checkboxNames.map((name) => DataColumn(label: Text(name))).toList();
  }

  Future<void> searchingResults() async {

    String query = 'select * from clients';
    List<dynamic> params = [];
    List<Map<String, dynamic>> fetchedData = await getData(query, params);
    print(fetchedData);




    setState(() {
      tableDataList = fetchedData;
      len = tableDataList.length;
    });

  }

  List<Map<String, dynamic>> tableDataList = [];
  int len = 0;

  void generateExcel() async {

    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    // Add the column headings to the Excel sheet
    for (var i = 0; i < checkboxNames.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i)).value = checkboxNames[i];
    }

    // Add the row data to the Excel sheet
    for (var i = 0; i < tableDataList.length; i++) {
      var rowData = tableDataList[i];
      var age = calculateAge(rowData['client_birth_date'].toString());


      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 0)).value = rowData['client_id'];
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 1)).value = rowData['client_name'].toString();
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 2)).value = rowData['client_phone1'].toString();
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 3)).value = rowData['client_phone2'].toString();
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 4)).value = age.toString();
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 5)).value = rowData['client_gender'];
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 6)).value = rowData['r_axis_d'];

    }

    // Get the documents directory path
    Directory? externalDir = await getExternalStorageDirectory();
    if (externalDir == null) {
      print("Error: External storage directory not found.");
      return;
    }

    String fileName = "مركز عيون.xlsx"; // Replace with your desired file name
    String savePath = '${externalDir.path}/$fileName';


    // Encode the Excel data to bytes
    var excelBytes = excel.encode();
    Uint8List uint8list = Uint8List.fromList(excelBytes!);

    // Save the bytes to a file
    File(savePath).writeAsBytesSync(uint8list);


    // Open the Excel file using the open_file package
    OpenFile.open(savePath);




  }

  @override
  void initState() {
    super.initState();

    searchingResults();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز عيون'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "اصدار تقرير عن العملاء",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 60),

              const Text(
                "النتائج",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20,),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: DataTable(

                    columns: createDataColumns(),
                    rows: List.generate(
                      len > tableDataList.length ? tableDataList.length : len,

                          (index) {
                        final rowData = tableDataList[index];



                        final age = calculateAge(rowData['client_birth_date'].toString());

                        return DataRow(
                          cells: [
                            DataCell(Text(rowData['client_id'].toString())),
                            DataCell(Text(rowData['client_name'].toString())),
                            DataCell(Text(rowData['client_phone1'].toString())),
                            DataCell(Text(rowData['client_phone2'].toString())),
                            DataCell(Text(age.toString())),
                            DataCell(Text(rowData['client_gender'].toString())),

                          ],
                        );
                      },
                    ),
                  ),
                )

              ),

              SizedBox(height: 30,),

              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(100, 25)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                onPressed: () {
                  generateExcel();
                },
                child: const Text(
                  "اطبع",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}