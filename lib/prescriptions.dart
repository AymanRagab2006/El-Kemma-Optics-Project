import 'dart:typed_data';
import 'package:el_kemma_optics/clients.dart';
import 'package:el_kemma_optics/db_connection.dart';
import 'package:el_kemma_optics/functions.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:ui' as ui;
import 'package:flutter/src/painting/box_border.dart' as box;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';





class PrescriptionsWindow extends StatelessWidget {
  const PrescriptionsWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز عيون'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter, // Set alignment to top center
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align widgets to the start (top) of the column
            children: [
              const Text(
                "التعامل مع الكشوفات",
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
                    MaterialPageRoute(builder: (context) => AddPrescriptionWindow(text: "")),
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(225, 35)), // Set the minimum dimensions
                ),
                child: const Text(
                  'اضافة كشف',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPrescriptionWindow()),
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(230, 35)), // Set the minimum dimensions
                ),
                child: const Text(
                  'اصدار تقرير عن الكشوفات',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdatePrescriptionWindow()),
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(225, 35)), // Set the minimum dimensions
                ),
                child: const Text(
                  'تحديث بيانات كشف',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(225, 35)), // Set the minimum dimensions
                ),
                child: const Text(
                  'حذف كشف',
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



class UpdatePrescriptionWindow extends StatefulWidget {
  const UpdatePrescriptionWindow({Key? key}) : super(key: key);

  @override
  _UpdatePrescriptionWindowState createState() => _UpdatePrescriptionWindowState();
}

class _UpdatePrescriptionWindowState extends State<UpdatePrescriptionWindow> {


  TextEditingController prescriptionId = TextEditingController();
  TextEditingController ipd = TextEditingController();
  TextEditingController totalPrice = TextEditingController();
  List<String> doctorOptions = [];
  List<String> fetchedClients = [];
  List<String> fetchedDoctors = [];
  String? selectedDoctorOption;
  String? selectedNameOption;
  DateTime? selectedPrescDate;

  bool isLensSelected = false;
  bool isPrescriptionIdFound = true;

  String? selectedPrescriptionType;
  String? selectedLensType;
  String? selectedLensColor;
  String? selectedSolutionType;
  String? _selectedPaymentMethod;

  List<TextEditingController> controllers = List.generate(12, (_) => TextEditingController(),);
  List<String> eye_power = List.generate(12, (_) => '');

  List<String> prescriptionTypes = ["رمد", "نظارة", "عدسات", "عملية ليزك", "المياه البيضاء"];

  List<String> lensTypes = [
    "Acuvue 2",
    "Bella",
    "Bella elite",
    "Bella glow",
    "Bio(3)",
    "Bio toric",
    "Clear vision",
    "Comfort",
    "Dahab",
    "Desio",
    "Flexcon",
    "Lens(s)",
    "Magic",
    "My lens",
    "Oasys",
    "Oasys toric",
    "Pure vision 2",
    "Soft toric",
    "Zeiss",
  ];

  List<String> lensColors = [];

  List<String> solutionTypes = [
    "bio true 60 ml",
    "Renu 60 ml",
    "Dahab 100 ml",
  ];

  void UpdateLensColors() {

    List<String> list = [];

    setState(() {
      lensColors.clear();
      list.clear();
      selectedLensColor = null;
    });


    List<String> myLensColors = [
      "Blue",
      "Capri",
      "Light brown",
      "Light gray",
      "Light green",
      "Oro brown",
      "Oro gray",
      "Oro hazel",
      "Turquoise",
    ];

    List<String> magicLensColors = [
      "Accio Hazel",
      "Blue",
      "Charm gray",
      "Golden brown",
      "Hermon green",
      "Oblivion gray",
      "Turquoise",
    ];

    List<String> dahabLensColors = [
      "Blue",
      "Cappuccino",
      "Gray",
      "Green",
      "Hazel",
      "Honey",
    ];
    List<String> desioLensColors = [
      "Charming green",
      "Delicious honey",
      "Irresistible blue",
      "Precious gray",
      "Rebal gray",
      "Romantic blue",
      "Tender hazel",
      "Wild green",
    ];
    List<String> luminousLensColors = [
      "Blue",
      "Crystal",
      "Dazzling green",
      "Gray",
      "Green",
      "Hazel",
      "Lazord",
      "Latin brown",
      "Latin gray",
      "Lemon",
    ];
    List<String> bellaEliteLensColors = [
      "Amber gray",
      "Crystal N",
      "Gray beige",
      "Midnight blue",
      "Mint gray",
      "Sandy brown",
      "Sandy gray",
      "Silky gold",
      "Silky green",
    ];
    List<String> bellaGlowLensColors = [
      "Gray caramel",
      "Husky gray Green",
      "Lime green",
      "Luminous blue",
      "Navy gray",
      "Radiant brown",
      "Radiant hazelnut",
      "Radiant gray",
      "Vivid blue",
    ];
    List<String> bellaLensColors = [
      "Almond brown",
      "Brown shadow",
      "Caribbean green",
      "Cool blue",
      "Cool gray",
      "Cool hazel",
      "Gray green",
      "Gray shadow",
      "Natural blue",
      "Natural gray",
      "Natural green",
      "Natural hazel",
    ];
    List<String> transparent = ["Transparent"];




    setState(() {
      if (selectedLensType == "My lens") {
        list = myLensColors;
      } else if (selectedLensType == "Magic") {
        list = magicLensColors;
      } else if (selectedLensType == "Dahab") {
        list = dahabLensColors;
      } else if (selectedLensType == "Desio") {
        list = desioLensColors;
      } else if (selectedLensType == "Luminous") {
        list = luminousLensColors;
      } else if (selectedLensType == "Bella elite") {
        list = bellaEliteLensColors;
      } else if (selectedLensType == "Bella glow") {
        list = bellaGlowLensColors;
      } else if (selectedLensType == "Bella") {
        list = bellaLensColors;
      } else {
        list = transparent;
      }
    });

    setState(() {

      lensColors = list.toList();
      // selectedLensColor = lensColors.first;
    });

  }


  @override
  void dispose() {

    prescriptionId.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
    ipd.dispose();
    totalPrice.dispose();

    super.dispose();
  }


  void updateDoctorOptions() async {

    Future<void> getDoctors() async {

      String query = 'select doctor_name from doctors';
      List<dynamic> params = [];
      List<Map<String, dynamic>> fetchedData = await getData(query, params);



      fetchedDoctors = [];
      if (fetchedData.isNotEmpty) {
        for (var row in fetchedData) {
          var doctorName = row['doctor_name'].toString();
          fetchedDoctors.add(doctorName);
        }
        setState(() {
          doctorOptions = fetchedDoctors;
          // selectedDoctorOption = doctorOptions.isNotEmpty ? doctorOptions[0] : null;
        });
      } else {
        setState(() {
          doctorOptions = [];
          selectedDoctorOption = null;
        });
      }
    }

    await getDoctors();
  }

  Future<void> _selectPrescDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedPrescDate) {
      setState(() {
        selectedPrescDate = picked;
      });
    }
  }

  Column showLensMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            Flexible(
              child: SizedBox(
                width: 200,
                height: 90,
                child: Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLensColor = newValue;
                      });
                    },
                    value: selectedLensColor, // Set the selected value for lens color
                    items: lensColors.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                    hint: const Text(
                      'اختار لون العدسة',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Flexible(
              child: SizedBox(
                width: 200,
                height: 90,
                child: Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: DropdownButtonFormField<String>(
                    value: selectedLensType,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLensType = newValue; // Update the selectedOption
                        UpdateLensColors();
                      });
                    },
                    items: lensTypes.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                    hint: const Text(
                      'اختار نوع العدسة',
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
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: SizedBox(
                width: 200,
                height: 90,
                child: Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: DropdownButtonFormField<String>(
                    value: selectedSolutionType,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSolutionType = newValue;
                      });
                    },
                    items: solutionTypes.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                    hint: const Text(
                      'اختار نوع المحلول',
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

      ],
    );
  }

  List<String> eyePower = ['0','0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'];

  int clientId = 0;
  String clientName = 'لا يوجد';
  String prescriptionDate = 'لا يوجد';
  int Ipd = 0;
  int doctorId = 0;
  String doctorName = 'لا يوجد';
  String prescType = 'لا يوجد';
  String lensType = 'لا يوجد';
  String lensColor = 'لا يوجد';
  String solutionType = 'لا يوجد';
  String paymentMethod = 'لا يوجد';
  double price = 0;
  int oldDoctorId = 0;
  String clientPhone = "لا يوجد";

  void getPrescriptionData() async {

    String query = '';
    List<dynamic> params = [];
    List<Map<String, dynamic>> fetchedData = [];

    updateDoctorOptions();

    int prescId = int.parse(prescriptionId.text);

    query = 'select * from prescriptions where prescription_id = ?';
    params = [prescId];
    fetchedData = await getData(query, params);

    if (fetchedData.isEmpty) {
      setState(() {
        isPrescriptionIdFound = false;
      });

    }
    else {
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


      setState(() {

        isPrescriptionIdFound = true;
        clientId = prescription.clientId;
        clientName = prescription.clientName;
        prescriptionDate = prescription.prescriptionDate;
        DateTime originalDate = DateTime.parse(prescriptionDate);
        DateFormat newDateFormat = DateFormat('yyyy-MM-dd');
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

        Ipd = prescription.ipd;
        doctorId = prescription.doctorId;
        doctorName = prescription.doctorName;
        prescType = prescription.prescriptionType;
        lensType = prescription.lensType;
        lensColor = prescription.lensColor;
        solutionType = prescription.solutionType;
        paymentMethod =  prescription.paymentMethod;
        price = prescription.totalPrice;

      });


      query = 'select client_phone1 from clients where client_id = ?';
      params = [clientId];
      fetchedData = await getData(query, params);
      var phone = fetchedData[0]['client_phone1'];

      setState(() {

        print(phone);
        clientPhone = phone.toString();

        selectedNameOption = prescription.clientName;
        selectedPrescDate = DateTime.parse(prescriptionDate);
        for (int i = 0; i <12; i++){
          controllers[i] = TextEditingController(text: eye_power[i]);
        }
        ipd = TextEditingController(text: Ipd.toString());
        selectedDoctorOption = doctorName;

        if (prescType.isNotEmpty && prescType != "null") selectedPrescriptionType = prescType;

        if(selectedPrescriptionType == 'عدسات'){
          if (lensType.isNotEmpty && lensType != "null") selectedLensType = lensType;
          UpdateLensColors();
          if (lensColor.isNotEmpty && lensColor != "null") selectedLensColor = lensColor;
          if (solutionType.isNotEmpty && solutionType != "null") selectedSolutionType = solutionType;
          isLensSelected = true;
        }
        else {
          isLensSelected = false;
        }

        _selectedPaymentMethod = paymentMethod;
        totalPrice = TextEditingController(text: price.toString());

      });
    }
  }

  Future<void> updatePresc() async {

    String query = '';
    List<dynamic> params = [];
    List<Map<String, dynamic>> fetchedData = [];

    int prescId = int.parse(prescriptionId.text);

    query = 'select prescriptions_numbers from doctors where doctor_id = ?';
    params = [doctorId];

    fetchedData = await getData(query, params);
    int prescNum = int.parse(fetchedData[0]['prescriptions_numbers']);
    prescNum -= 1;

    query = 'update doctors set prescriptions_numbers = ? where doctor_id = ?';
    params = [prescNum, doctorId];
    executeQuery(query, params);

    String prescDate = selectedPrescDate.toString();
    var r_sph_d = eye_power[0];
    var r_cyl_d = eye_power[1];
    var r_axis_d = eye_power[2];
    var r_sph_r = eye_power[3];
    var r_cyl_r = eye_power[4];
    var r_axis_r = eye_power[5];
    var l_sph_d = eye_power[6];
    var l_cyl_d = eye_power[7];
    var l_axis_d = eye_power[8];
    var l_sph_r = eye_power[9];
    var l_cyl_r = eye_power[10];
    var l_axis_r = eye_power[11];

    int IPD = 0;
    if (ipd.text.isNotEmpty) IPD = int.parse(ipd.text);

    String doctorName = selectedDoctorOption.toString();

    query = 'select doctor_id from doctors where doctor_name = ?';
    params = [doctorName];
    fetchedData = await getData(query, params);

    int doctorID = int.parse(fetchedData[0]['doctor_id']);

    String prescType = selectedPrescriptionType.toString();
    String lensType = selectedLensType.toString();
    String lensColor = selectedLensColor.toString();
    String solutionType = selectedSolutionType.toString();
    String paymentMethod = _selectedPaymentMethod.toString();
    double price = 0;
    if (totalPrice.text.isNotEmpty) price = double.parse(totalPrice.text);


    query = 'update prescriptions set prescription_date = ?, '
        'r_sph_d = ?, r_cyl_d = ?, r_axis_d = ?, r_sph_r = ?, r_cyl_r = ?, r_axis_r = ?, '
        'l_sph_d = ?, l_cyl_d = ?, l_axis_d = ?, l_sph_r = ?, l_cyl_r = ?, l_axis_r = ?, '
        'ipd = ?, doctor_id = ?, doctor_name = ?, prescription_type = ?, '
        'lens_type = ?, lens_color = ?, solution_type = ?, payment_method = ?, total_price = ? WHERE prescription_id = ?';

    params = [prescDate,  r_sph_d, r_cyl_d, r_axis_d, r_sph_r, r_cyl_r, r_axis_r,
      l_sph_d, l_cyl_d, l_axis_d, l_sph_r, l_cyl_r, l_axis_r,
      IPD, doctorID, doctorName, prescType,
      lensType, lensColor, solutionType, paymentMethod, price, prescId];

    await executeQuery(query, params);


    query = 'select prescriptions_numbers from doctors where doctor_id = ?';
    params = [doctorID];

    fetchedData = await getData(query, params);
    int prescNum2 = int.parse(fetchedData[0]['prescriptions_numbers']);
    prescNum2 += 1;

    query = 'update doctors set prescriptions_numbers = ? where doctor_id = ?';
    params = [prescNum2, doctorID];
    executeQuery(query, params);

    setState(() {
      prescriptionId.clear();
      selectedNameOption = null;
      for (var i = 0; i < controllers.length; i++) {
        controllers[i].clear();
      }
      selectedPrescDate = null;
      ipd.clear();
      selectedDoctorOption = null;
      updateDoctorOptions();
      selectedPrescriptionType = null;
      isLensSelected = false;
      selectedLensType = null;
      selectedLensColor = null;
      selectedSolutionType = null;
      _selectedPaymentMethod = null;
      totalPrice.clear();
      clientName = "لا يوجد";
      clientPhone = "لا يوجد";
    });

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "تحديث بيانات كشف",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),



                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SizedBox(
                            width: 200,
                            height: 80,
                            child: Directionality(
                              textDirection: ui.TextDirection.rtl,
                              child: TextFormField(
                                textAlign: TextAlign.right,
                                controller: prescriptionId,
                                decoration: InputDecoration(
                                  labelText: "الرقم التعريفي للكشف",
                                  border: const OutlineInputBorder(),
                                  errorText: isPrescriptionIdFound
                                      ? null
                                      : 'هذا الكشف غير موجود', // Show error message if phone number is not found
                                ),
                                style: const TextStyle(fontSize: 15),
                                keyboardType: TextInputType.phone,
                              ),
                            )

                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  ElevatedButton(
                    onPressed: () {
                      getPrescriptionData(); // Call the function to handle button press
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size(100, 20)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      "بحث",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),

                  const SizedBox(height: 30),

                  RichText(
                    textDirection: ui.TextDirection.rtl,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'الأسم: ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' $clientName', // Replace 'yourVariable' with the actual variable you want to display
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal, // You can change this to bold if you want both parts to be bold
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  RichText(
                    textDirection: ui.TextDirection.rtl,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'رقم الهاتف: ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' $clientPhone', // Replace 'yourVariable' with the actual variable you want to display
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal, // You can change this to bold if you want both parts to be bold
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            _selectPrescDate(context);
                          },
                          child: AbsorbPointer(
                            child: SizedBox(
                              width: 200,
                              height: 50,
                              child: Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: "تاريخ الكشف",
                                    border: OutlineInputBorder(),
                                  ),
                                  style: const TextStyle(fontSize: 15),
                                  keyboardType: TextInputType.datetime,
                                  controller: TextEditingController(
                                    text: selectedPrescDate != null
                                        ? formatter.format(selectedPrescDate!)
                                        : '',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Align(
                      alignment: Alignment.center,
                      child: Container(
                        // width: 600,
                        height: 200,
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
                                                      child: TextField(
                                                        textAlign: TextAlign.center,
                                                        // textAlignVertical: TextAlignVertical.top,
                                                        style: const TextStyle(fontSize: 8),
                                                        decoration: const InputDecoration(
                                                          border: UnderlineInputBorder(),
                                                        ),
                                                        controller: controllers[0],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            eye_power[0] = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Expanded(
                                                    child: Container(
                                                      height: 30,
                                                      alignment: Alignment.center,
                                                      child: TextField(
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(fontSize: 8),
                                                        decoration: const InputDecoration(
                                                          border: UnderlineInputBorder(),
                                                        ),
                                                        controller: controllers[1],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            eye_power[1] = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Expanded(
                                                    child: Container(
                                                      height: 30,
                                                      alignment: Alignment.center,
                                                      child: TextField(
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(fontSize: 8),
                                                        decoration: const InputDecoration(
                                                          border: UnderlineInputBorder(),
                                                        ),
                                                        controller: controllers[2],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            eye_power[2] = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
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
                                                      child: TextField(
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(fontSize: 8),
                                                        decoration: const InputDecoration(
                                                          border: UnderlineInputBorder(),
                                                        ),
                                                        controller: controllers[3],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            eye_power[3] = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Expanded(
                                                    child: Container(
                                                      height: 30,
                                                      alignment: Alignment.center,
                                                      child: TextField(
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(fontSize: 8),
                                                        decoration: const InputDecoration(
                                                          border: UnderlineInputBorder(),
                                                        ),
                                                        controller: controllers[4],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            eye_power[4] = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Expanded(
                                                    child: Container(
                                                      height: 30,
                                                      alignment: Alignment.center,
                                                      child: TextField(
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(fontSize: 8),
                                                        decoration: const InputDecoration(
                                                          border: UnderlineInputBorder(),
                                                        ),
                                                        controller: controllers[5],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            eye_power[5] = value;
                                                          });
                                                        },
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
                                                      child: TextField(
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(fontSize: 8),
                                                        decoration: const InputDecoration(
                                                          border: UnderlineInputBorder(),
                                                        ),
                                                        controller: controllers[6],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            eye_power[6] = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Expanded(
                                                    child: Container(
                                                      height: 30,
                                                      alignment: Alignment.center,
                                                      child: TextField(
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(fontSize: 8),
                                                        decoration: const InputDecoration(
                                                          border: UnderlineInputBorder(),
                                                        ),
                                                        controller: controllers[7],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            eye_power[7] = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Expanded(
                                                    child: Container(
                                                      height: 30,
                                                      alignment: Alignment.center,
                                                      child: TextField(
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(fontSize: 8),
                                                        decoration: const InputDecoration(
                                                          border: UnderlineInputBorder(),
                                                        ),
                                                        controller: controllers[8],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            eye_power[8] = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
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
                                                      child: TextField(
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(fontSize: 8),
                                                        decoration: const InputDecoration(
                                                          border: UnderlineInputBorder(),
                                                        ),
                                                        controller: controllers[9],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            eye_power[9] = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Expanded(
                                                    child: Container(
                                                      height: 30,
                                                      alignment: Alignment.center,
                                                      child: TextField(
                                                        textAlign: TextAlign.center,
                                                        textAlignVertical: TextAlignVertical.top,
                                                        style: const TextStyle(fontSize: 8),
                                                        decoration: const InputDecoration(
                                                          border: UnderlineInputBorder(),
                                                        ),
                                                        controller: controllers[10],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            eye_power[10] = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Expanded(
                                                    child: Container(
                                                      height: 30,
                                                      alignment: Alignment.center,
                                                      child: TextField(
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(fontSize: 8),
                                                        decoration: const InputDecoration(
                                                          border: UnderlineInputBorder(),
                                                        ),
                                                        controller: controllers[11],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            eye_power[11] = value;
                                                          });
                                                        },
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
                      )
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: 80,
                          height: 50,
                          child: TextFormField(
                            controller: ipd,
                            decoration: const InputDecoration(
                              labelText: "I.P.D:",
                              border: OutlineInputBorder(),
                            ),
                            style: const TextStyle(fontSize: 12),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),

                    ],
                  ),

                  // const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: 250,
                          height: 90,
                          child: Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: DropdownButtonFormField<String>(
                              value: selectedDoctorOption,
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
                              // value: selectedDoctorOption, // Declare and initialize selectedOption
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDoctorOption = newValue; // Update the selectedOption
                                });
                              },
                              items: doctorOptions.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(
                                    option,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                );
                              }).toList(),
                              hint: const Text(
                                'اسم الطبيب',
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: 250,
                          height: 90,
                          child: Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: DropdownButtonFormField<String>(
                              value: selectedPrescriptionType,
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
                              // value: selectedDoctorOption, // Declare and initialize selectedOption
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedPrescriptionType = newValue; // Update the selectedOption
                                  if (newValue == 'عدسات'){
                                    setState(() {
                                      isLensSelected = true;
                                    });
                                  }
                                  else {
                                    setState(() {
                                      isLensSelected = false;
                                    });
                                  }
                                });
                              },
                              items: prescriptionTypes.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(
                                    option,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                );
                              }).toList(),
                              hint: const Text(
                                'اختار نوع الكشف',
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

                  const SizedBox(height: 20),

                  Visibility(
                    visible: (isLensSelected),
                    child: showLensMenu(),
                  ),

                  const SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "طريقة الدفع",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('فيزا'),
                        Radio(
                          value: "فيزا",
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value as String?;
                            });
                          },
                        ),
                        const SizedBox(width: 5),
                        const Text('جهات'),
                        Radio(
                          value: "جهات",
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value as String?;
                            });
                          },
                        ),
                        const SizedBox(width: 5),
                        const Text('كاش'),
                        Radio(
                          value: "كاش",
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value as String?;
                            });
                          },
                        ),
                        const SizedBox(width: 10),

                      ],
                    ),
                  ),
                  SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SizedBox(
                            width: 200,
                            height: 60,
                            child: Directionality(
                              textDirection: ui.TextDirection.rtl,
                              child: TextFormField(
                                textAlign: TextAlign.right,
                                controller: totalPrice,
                                decoration: const InputDecoration(
                                  labelText: "السعر",
                                  border: OutlineInputBorder(),
                                ),
                                style: const TextStyle(fontSize: 15),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),

                  ElevatedButton(
                    onPressed: () {
                      updatePresc();
                      showMessage(context, "تم تحديث بيانات الكشف بنجاح");
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size(150, 50)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      "تحديث الكشف",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }
}



class SearchPrescriptionWindow extends StatefulWidget {
  const SearchPrescriptionWindow({Key? key}) : super(key: key);

  @override
  _SearchPrescriptionWindowState createState() => _SearchPrescriptionWindowState();
}

class _SearchPrescriptionWindowState extends State<SearchPrescriptionWindow> {

  TextEditingController prescId = TextEditingController();
  TextEditingController clientId = TextEditingController();
  TextEditingController clientName = TextEditingController();
  TextEditingController clientPhone = TextEditingController();
  TextEditingController minAge = TextEditingController();
  TextEditingController maxAge = TextEditingController();
  String? clientGender;
  DateTime? selectedMinDate;
  DateTime? selectedMaxDate;
  TextEditingController minSph = TextEditingController();
  TextEditingController maxSph = TextEditingController();
  TextEditingController minCyl = TextEditingController();
  TextEditingController maxCyl = TextEditingController();
  TextEditingController minAxis = TextEditingController();
  TextEditingController maxAxis = TextEditingController();
  TextEditingController minIpd = TextEditingController();
  TextEditingController maxIpd = TextEditingController();
  TextEditingController doctorId = TextEditingController();
  TextEditingController doctorName = TextEditingController();
  TextEditingController prescType = TextEditingController();
  TextEditingController lensType = TextEditingController();
  TextEditingController lensColor = TextEditingController();
  TextEditingController solutionType = TextEditingController();
  String? paymentMethod;
  TextEditingController minPrice = TextEditingController();
  TextEditingController maxPrice = TextEditingController();

  bool prescIdCheck = false;
  bool clientIdCheck = false;
  bool clientNameCheck = false;
  bool phoneCheck = false;
  bool ageCheck = false;
  bool genderCheck = false;
  bool prescDateCheck = false;
  bool sphCheck = false;
  bool cylCheck = false;
  bool axisCheck = false;
  bool ipdCheck = false;
  bool doctorIdCheck = false;
  bool doctorNameCheck = false;
  bool prescTypeCheck = false;
  bool lensTypeCheck = false;
  bool lensColorCheck = false;
  bool solutionTypeCheck = false;
  bool paymentMethodCheck = false;
  bool totalPriceCheck = false;

  // List of Arabic names for the checkboxes
  List<String> checkboxNames = [
    "الرقم التعريفي للكشف",
    "اسم العميل",
    "رقم الهاتف",
    "العمر",
    "تاريخ الكشف",
    "R Sph. D.",
    "R Cyl. D",
    "R Axis. D",
    "R Sph. R.",
    "R Cyl. R",
    "R Axis. R",
    "L Sph. D.",
    "L Cyl. D",
    "L Axis. D",
    "L Sph. R.",
    "L Cyl. R",
    "L Axis. R",
    "I.P.D",
    "اسم الطبيب",
    "نوع الكشف",
    "نوع العدسة",
    "لون العدسة",
    "نوع المحلول",
    "طريقة الدفع",
    "السعر",

  ];

  List<DataColumn> createDataColumns() {
    return checkboxNames.map((name) => DataColumn(label: Text(name))).toList();
  }

  Future<void> _selectMinDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedMinDate) {
      setState(() {
        selectedMinDate = picked;
      });
    }
  }

  Future<void> _selectMaxDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedMaxDate) {
      setState(() {
        selectedMaxDate = picked;
      });
    }
  }


  Future<void> searchingResults() async{

    final MySqlConnection connection = await getDBConnection();

    String searchFilters = "";
    String query = '';
    List<dynamic> params = [];
    List<Map<String, dynamic>> fetchedData = [];

    if (prescIdCheck) {
      String prescriptionId = prescId.text;
      searchFilters += "prescription_id = '$prescriptionId' AND ";
    }

    if (clientIdCheck) {
      String clientID = clientId.text;
      searchFilters += "client_id = '$clientID' AND ";
    }

    if (clientNameCheck) {
      String name = clientName.text;
      searchFilters += "client_name LIKE '%$name%' AND ";
    }

    if (phoneCheck) {

      String phone = clientPhone.text;
      // var result = await connection.query('SELECT client_id FROM clients WHERE client_phone1 LIKE ? OR client_phone2 LIKE ?', ['%$phone%', '%$phone%',]);

      // List<Map<String, dynamic>> resultList = result.map((row) => row.fields).toList();

      // List<String> searchClientIds = resultList.map((row) => row['client_id'].toString()).toList();

      query = 'SELECT client_id FROM clients WHERE client_phone1 LIKE ? OR client_phone2 LIKE ?';
      params = ['%$phone%', '%$phone%',];

      fetchedData = await getData(query, params);

      List<String> searchClientIds = fetchedData.map((row) => row['client_id'].toString()).toList();

      searchFilters += "(";
      if (fetchedData.isNotEmpty){
        List<String> clientIdsConditions = searchClientIds.map((clientId) => "client_id = $clientId").toList();
        searchFilters += "(${clientIdsConditions.join(" OR ")})";
      } else {
        searchFilters += "client_id = 0";
      }

      searchFilters += ") AND ";

    }

    if (prescDateCheck) {
      String minDate = selectedMinDate.toString();
      String maxDate = selectedMaxDate.toString();
      searchFilters += "(prescription_date BETWEEN '$minDate' AND '$maxDate') AND ";
    }

    if (ageCheck) {
      String MinAge = minAge.text;
      String MaxAge = maxAge.text;

      String minBirthDate = calculateBirthDateFromAge(MaxAge);
      String maxBirthDate = calculateBirthDateFromAge(MinAge);

      // var result = await connection.query("SELECT client_id FROM clients WHERE client_birth_date BETWEEN '$minBirthDate' AND '$maxBirthDate'");
      //
      // List<Map<String, dynamic>> resultList = result.map((row) => row.fields).toList();
      // List<String> searchClientIds = resultList.map((row) => row['client_id'].toString()).toList();

      query = 'SELECT client_id FROM clients WHERE client_birth_date BETWEEN ? AND ?';
      params = [minBirthDate, maxBirthDate];

      fetchedData = await getData(query, params);

      List<String> searchClientIds = fetchedData.map((row) => row['client_id'].toString()).toList();

      searchFilters += "(";
      if (fetchedData.isNotEmpty){
        List<String> clientIdsConditions = searchClientIds.map((clientId) => "client_id = $clientId").toList();
        searchFilters += "(${clientIdsConditions.join(" OR ")})";
      } else {
        searchFilters += "client_id = 0";
      }

      searchFilters += ") AND ";
    }



    if (prescDateCheck) {

      String minDate = selectedMinDate.toString();
      String maxDate = selectedMaxDate.toString();

      searchFilters += "(prescription_date BETWEEN '$minDate' AND '$maxDate') AND ";
    }

    if (sphCheck) {
      int minSphValue = int.tryParse(minSph.text) ?? 0;
      int maxSphValue = int.tryParse(maxSph.text) ?? 0;

      searchFilters += "(((r_sph_d BETWEEN '$minSphValue' AND '$maxSphValue') OR (l_sph_d BETWEEN '$minSphValue' AND '$maxSphValue')) OR  "
          "((r_sph_r BETWEEN '$minSphValue' AND '$maxSphValue') OR (l_sph_r BETWEEN '$minSphValue' AND '$maxSphValue'))) AND ";
    }

    if (cylCheck) {
      int minCylValue = int.tryParse(minCyl.text) ?? 0;
      int maxCylValue = int.tryParse(maxCyl.text) ?? 0;

      searchFilters += "(((r_cyl_d BETWEEN '$minCylValue' AND '$maxCylValue') OR (l_cyl_d BETWEEN '$maxCylValue' AND '$maxCylValue')) OR  "
          "((r_cyl_r BETWEEN '$minCylValue' AND '$maxCylValue') OR (l_cyl_r BETWEEN '$minCylValue' AND '$maxCylValue'))) AND ";
    }

    if (axisCheck) {
      int minAxisValue = int.tryParse(minAxis.text) ?? 0;
      int maxAxisValue = int.tryParse(maxAxis.text) ?? 0;

      searchFilters += "(((r_axis_d BETWEEN '$minAxisValue' AND '$maxAxisValue') OR (l_axis_d BETWEEN '$maxAxisValue' AND '$maxAxisValue')) OR  "
          "((r_axis_r BETWEEN '$minAxisValue' AND '$maxAxisValue') OR (l_axis_r BETWEEN '$minAxisValue' AND '$maxAxisValue'))) AND ";
    }

    if (ipdCheck) {
      String MinIpd = minIpd.text;
      String MaxIpd = maxIpd.text;

      searchFilters += "ipd BETWEEN '$MinIpd' AND '$MaxIpd' AND ";
    }

    if (doctorIdCheck){
      String doctorID = doctorId.text;
      searchFilters += "doctor_id = '$doctorID' AND ";
    }

    if (doctorNameCheck) {
      String name = doctorName.text;
      searchFilters += "doctor_name LIKE '%$name%' AND ";
    }

    if (prescTypeCheck) {
      String name = prescType.text;
      searchFilters += "prescription_type LIKE '%$name%' AND ";
    }

    if (lensTypeCheck) {
      String name = lensType.text;
      searchFilters += "lens_type LIKE '%$name%' AND ";
    }

    if (lensColorCheck) {
      String name = lensColor.text;
      searchFilters += "lens_color LIKE '%$name%' AND ";
    }

    if (solutionTypeCheck) {
      String name = solutionType.text;
      searchFilters += "solution_type LIKE '%$name%' AND ";
    }

    if (paymentMethodCheck) {
      String name = paymentMethod.toString();
      searchFilters += "payment_method LIKE '%$name%' AND ";
    }

    if (totalPriceCheck) {
      String MinPrice = minPrice.text;
      String MaxPrice = maxPrice.text;

      searchFilters += "total_price BETWEEN '$MinPrice' AND '$MaxPrice' AND ";
    }

    if (genderCheck){

      String gender = clientGender.toString();

      // var result = await connection.query("SELECT client_id FROM clients WHERE client_gender = '$gender'");
      //
      // List<Map<String, dynamic>> resultList = result.map((row) => row.fields).toList();
      // List<String> searchClientIds = resultList.map((row) => row['client_id'].toString()).toList();

      query = 'SELECT client_id FROM clients WHERE client_gender = ?';
      params = [gender];

      fetchedData = await getData(query, params);

      List<String> searchClientIds = fetchedData.map((row) => row['client_id'].toString()).toList();

      searchFilters += "(";
      if (fetchedData.isNotEmpty){
        List<String> clientIdsConditions = searchClientIds.map((clientId) => "client_id = $clientId").toList();
        searchFilters += "(${clientIdsConditions.join(" OR ")})";
      } else {
        searchFilters += "client_id = 0";
      }

      searchFilters += ") AND ";
    }


    if(searchFilters.isNotEmpty){
      searchFilters = searchFilters.substring(0, searchFilters.length - 4);
      query = "SELECT * FROM prescriptions WHERE $searchFilters";
      params = [];
    }

    if(searchFilters.isEmpty || query.isEmpty){
      query = "SELECT * FROM prescriptions";
      params = [];
    }


    print("Search Filters: '$searchFilters'");
    print("Query: '$query'");

    // final finalResult = await connection.query(query);


    List<Map<String, dynamic>> finalResult = await getData(query, params);
    List<String> clientIdsFromFirstQuery = finalResult.map((row) => row['client_id'].toString()).toList();
    print(clientIdsFromFirstQuery);


    List<Map<String, dynamic>> combinedResults = [];

    for (String clientId in clientIdsFromFirstQuery) {

      query = "SELECT client_phone1, client_phone2, client_birth_date, client_gender FROM clients WHERE client_id = ?";
      params = [clientId];

      // final result = await connection.query(query);
      fetchedData = await getData(query, params);

      combinedResults.addAll(fetchedData);
    }

    // final clientIdResult = await connection.query(clientIdQuery);

    print(finalResult);
    print(combinedResults);

    setState(() {
      query = "";
      searchFilters = "";
      prescIdCheck = false;
      clientIdCheck = false;
      clientNameCheck = false;
      phoneCheck = false;
      ageCheck = false;
      genderCheck = false;
      prescDateCheck = false;
      sphCheck = false;
      cylCheck = false;
      axisCheck = false;
      ipdCheck = false;
      doctorIdCheck = false;
      doctorNameCheck = false;
      prescTypeCheck = false;
      lensTypeCheck = false;
      lensColorCheck = false;
      solutionTypeCheck = false;
      paymentMethodCheck = false;
      totalPriceCheck = false;

      prescId.clear();
      clientId.clear();
      clientName.clear();
      clientPhone.clear();
      minAge.clear();
      maxAge.clear();
      selectedMinDate = null;
      selectedMaxDate = null;
      minSph.clear();
      maxSph.clear();
      minCyl.clear();
      maxCyl.clear();
      minAxis.clear();
      maxAxis.clear();
      minIpd.clear();
      maxIpd.clear();
      doctorId.clear();
      doctorName.clear();
      prescType.clear();
      lensType.clear();
      lensColor.clear();
      solutionType.clear();
      paymentMethod = null;
      minPrice.clear();
      maxPrice.clear();

    });



    var data = finalResult;
    var data2 = combinedResults.map((clientData) => clientData).toList();
    setState(() {
      tableDataList = data;
      clientDataList = data2;
      len = tableDataList.length + 2;
    });

  }

  List<Map<String, dynamic>> tableDataList = [];
  List<Map<String, dynamic>> clientDataList = [];
  List<Map<String, dynamic>> combinedResults = [];
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
      var clientData = i < clientDataList.length ? clientDataList[i] : {};
      var age = calculateAge(clientData['client_birth_date'].toString());
      final prescriptionDate = rowData['prescription_date'] != null
          ? DateFormat('dd/MM/yyyy').format(rowData['prescription_date'] as DateTime)
          : '';

      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 0)).value = rowData['prescription_id'];
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 1)).value = rowData['client_name'].toString();
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 2)).value = clientData['client_phone1'].toString();
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 3)).value = age.toString();
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 4)).value = prescriptionDate;
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 5)).value = rowData['r_sph_d'];
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 6)).value = rowData['r_cyl_d'];
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 7)).value = rowData['r_axis_d'];
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 8)).value = rowData['r_sph_r'];
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 9)).value = rowData['r_cyl_r'];
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 10)).value = rowData['r_axis_r'];
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 11)).value = rowData['l_sph_d'];
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 12)).value = rowData['l_cyl_d'];
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 13)).value = rowData['l_axis_d'];
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 14)).value = rowData['l_sph_r'];
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 15)).value = rowData['l_cyl_r'];
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 16)).value = rowData['l_axis_r'];
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 17)).value = rowData['ipd'];
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 18)).value = (rowData['doctor_name'].toString());
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 19)).value = (rowData['prescription_type'].toString());
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 20)).value = (rowData['lens_type'].toString());
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 21)).value = (rowData['lens_color'].toString());
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 22)).value = (rowData['solution_type'].toString());
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 23)).value = (rowData['payment_method'].toString());
      sheet.cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 24)).value = (rowData['total_price']);
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "اصدار تقرير عن الكشوفات",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),

              Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Column(
                  children: [

                    // prescId
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: prescIdCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              prescIdCheck = value ?? false;
                            });
                          },
                        ),
                        Text('الرقم التعريفي للكشف'),
                        SizedBox(width: 5,),
                        Visibility(
                          visible: prescIdCheck,
                          child:
                            Row(
                              children: [
                                SizedBox(
                                  width: 125,
                                  height: 40,
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      controller: prescId,
                                      decoration: const InputDecoration(
                                        hintText: 'ادخل القيمة',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: OutlineInputBorder(),
                                      ),

                                      style: const TextStyle(fontSize: 15),
                                      keyboardType: TextInputType.number,
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
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //clientId
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: clientIdCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              clientIdCheck = value ?? false;
                            });
                          },
                        ),
                        Text('الرقم التعريفي للعميل'),
                        SizedBox(width: 5,),
                        Visibility(
                          visible: clientIdCheck,
                          child:
                          Row(
                            children: [
                              SizedBox(
                                  width: 125,
                                  height: 40,
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      controller: clientId,
                                      decoration: const InputDecoration(
                                        hintText: 'ادخل القيمة',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: OutlineInputBorder(),
                                      ),

                                      style: const TextStyle(fontSize: 15),
                                      keyboardType: TextInputType.number,
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
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //clientName
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: clientNameCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              clientNameCheck = value ?? false;
                            });
                          },
                        ),
                        Text('اسم العميل'),
                        SizedBox(width: 5,),
                        Visibility(
                            visible: clientNameCheck,
                            child:
                            Row(
                              children: [
                                SizedBox(
                                    width: 180,
                                    height: 40,
                                    child: Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: TextFormField(
                                        textAlign: TextAlign.right,
                                        controller: clientName,
                                        decoration: const InputDecoration(
                                          hintText: 'ادخل القيمة',
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //Phone
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: phoneCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              phoneCheck = value ?? false;
                            });
                          },
                        ),
                        Text('رقم الهاتف'),
                        SizedBox(width: 5,),
                        Visibility(
                          visible: phoneCheck,
                          child:
                            Row(
                              children: [
                                SizedBox(
                                  width: 180,
                                  height: 40,
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      controller: clientPhone,
                                      decoration: const InputDecoration(
                                        hintText: 'ادخل القيمة',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: OutlineInputBorder(),
                                      ),

                                      style: const TextStyle(fontSize: 15),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'يجب ادخال تلك الخانة';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          )
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //Age
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: ageCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              ageCheck = value ?? false;
                            });
                          },
                        ),
                        Text('الفئة العمرية'),
                        SizedBox(width: 5,),
                        Visibility(
                            visible: ageCheck,
                            child:
                            Row(
                              children: [
                                SizedBox(
                                  width: 70,
                                  height: 40,
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      controller: minAge,
                                      decoration: const InputDecoration(
                                        labelText: 'من',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: OutlineInputBorder(),
                                      ),

                                      style: const TextStyle(fontSize: 15),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'يجب ادخال تلك الخانة';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                SizedBox(
                                  width: 70,
                                  height: 40,
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      controller: maxAge,
                                      decoration: const InputDecoration(
                                        labelText: 'الى',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: OutlineInputBorder(),
                                      ),

                                      // style: const TextStyle(fontSize: 20),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'يجب ادخال تلك الخانة';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //Gender
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: genderCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              genderCheck = value ?? false;
                            });
                          },
                        ),
                        Text('النوع'),
                        SizedBox(width: 5,),
                        Visibility(
                          visible: genderCheck,

                          child: Row(
                            children: [
                              Directionality(
                                textDirection: ui.TextDirection.ltr,
                                child:  Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('انثى'),
                                      Radio(
                                        value: "انثى",
                                        groupValue: clientGender,
                                        onChanged: (value) {
                                          setState(() {
                                            clientGender = value as String?;
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 3),
                                      const Text('ذكر'),
                                      Radio(
                                        value: "ذكر",
                                        groupValue: clientGender,
                                        onChanged: (value) {
                                          setState(() {
                                            clientGender = value as String?;
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //Prescription Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: prescDateCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              prescDateCheck = value ?? false;
                            });
                          },
                        ),
                        Text('تاريخ الكشف'),
                        SizedBox(width: 5,),
                        Visibility(
                            visible: prescDateCheck,
                            child:
                            Row(
                              children: [
                                SizedBox(
                                  width: 105,
                                  height: 40,
                                  child: TextFormField(
                                    textAlign: TextAlign.right,
                                    onTap: () => _selectMinDate(context),
                                    controller: TextEditingController(
                                      text: selectedMinDate == null
                                          ? "اختار تاريخ الكشف"
                                          : "${selectedMinDate!.day}/${selectedMinDate!.month}/${selectedMinDate!.year}",
                                    ),
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: "من",
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        onPressed: () => _selectMinDate(context),
                                        icon: const Icon(Icons.calendar_today),
                                      ),
                                    ),
                                    style: const TextStyle(fontSize: 5),
                                  ),
                                ),
                                SizedBox(width: 2,),
                                SizedBox(
                                  width: 105,
                                  height: 40,
                                  child: TextFormField(
                                    textAlign: TextAlign.right,
                                    onTap: () => _selectMaxDate(context),
                                    controller: TextEditingController(
                                      text: selectedMaxDate == null
                                          ? "اختار تاريخ الكشف"
                                          : "${selectedMaxDate!.day}/${selectedMaxDate!.month}/${selectedMaxDate!.year}",
                                    ),
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: "الى",
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        onPressed: () => _selectMaxDate(context),
                                        icon: const Icon(Icons.calendar_today),
                                      ),
                                    ),
                                    style: const TextStyle(fontSize: 5),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //Sph.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: sphCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              sphCheck = value ?? false;
                            });
                          },
                        ),
                        Text('Sph.'),
                        SizedBox(width: 5,),
                        Visibility(
                            visible: sphCheck,
                            child:
                            Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: TextFormField(
                                      textDirection: ui.TextDirection.ltr,
                                      textAlign: TextAlign.right,
                                      controller: minSph,
                                      decoration: const InputDecoration(
                                        labelText: 'من',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: OutlineInputBorder(),
                                      ),

                                      style: const TextStyle(fontSize: 13),
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'يجب ادخال تلك الخانة';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: TextFormField(
                                      textDirection: ui.TextDirection.ltr,
                                      textAlign: TextAlign.right,
                                      controller: maxSph,
                                      decoration: const InputDecoration(
                                        labelText: 'الى',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: OutlineInputBorder(),
                                      ),

                                      style: const TextStyle(fontSize: 13),
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'يجب ادخال تلك الخانة';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //Cyl.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: cylCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              cylCheck = value ?? false;
                            });
                          },
                        ),
                        Text('Cyl.'),
                        SizedBox(width: 5,),
                        Visibility(
                            visible: cylCheck,
                            child:
                            Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: TextFormField(
                                      textDirection: ui.TextDirection.ltr,
                                      textAlign: TextAlign.right,
                                      controller: minCyl,
                                      decoration: const InputDecoration(
                                        labelText: 'من',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: OutlineInputBorder(),
                                      ),

                                      style: const TextStyle(fontSize: 13),
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'يجب ادخال تلك الخانة';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: TextFormField(
                                      textDirection: ui.TextDirection.ltr,
                                      textAlign: TextAlign.right,
                                      controller: maxCyl,
                                      decoration: const InputDecoration(
                                        labelText: 'الى',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: OutlineInputBorder(),
                                      ),

                                      style: const TextStyle(fontSize: 13),
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'يجب ادخال تلك الخانة';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //Axis.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: axisCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              axisCheck = value ?? false;
                            });
                          },
                        ),
                        Text('Axis'),
                        SizedBox(width: 5,),
                        Visibility(
                            visible: axisCheck,
                            child:
                            Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: TextFormField(
                                      textDirection: ui.TextDirection.ltr,
                                      textAlign: TextAlign.right,
                                      controller: minAxis,
                                      decoration: const InputDecoration(
                                        labelText: 'من',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: OutlineInputBorder(),
                                      ),

                                      style: const TextStyle(fontSize: 13),
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'يجب ادخال تلك الخانة';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: TextFormField(
                                      textDirection: ui.TextDirection.ltr,
                                      textAlign: TextAlign.right,
                                      controller: maxAxis,
                                      decoration: const InputDecoration(
                                        labelText: 'الى',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: OutlineInputBorder(),
                                      ),

                                      style: const TextStyle(fontSize: 13),
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'يجب ادخال تلك الخانة';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //I.P.D.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: ipdCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              ipdCheck = value ?? false;
                            });
                          },
                        ),
                        Text('I.P.D'),
                        SizedBox(width: 5,),
                        Visibility(
                            visible: ipdCheck,
                            child:
                            Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      controller: minIpd,
                                      decoration: const InputDecoration(
                                        labelText: 'من',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: OutlineInputBorder(),
                                      ),

                                      style: const TextStyle(fontSize: 15),
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'يجب ادخال تلك الخانة';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      controller: maxIpd,
                                      decoration: const InputDecoration(
                                        labelText: 'الى',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: OutlineInputBorder(),
                                      ),

                                      style: const TextStyle(fontSize: 15),
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'يجب ادخال تلك الخانة';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    // Doctor Id
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: doctorIdCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              doctorIdCheck = value ?? false;
                            });
                          },
                        ),
                        Text('الرقم التعريفي للطبيب'),
                        SizedBox(width: 5,),
                        Visibility(
                            visible: doctorIdCheck,
                            child:
                            Row(
                              children: [
                                SizedBox(
                                    width: 125,
                                    height: 40,
                                    child: Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: TextFormField(
                                        textAlign: TextAlign.right,
                                        controller: doctorId,
                                        decoration: const InputDecoration(
                                          hintText: 'ادخل القيمة',
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                          border: OutlineInputBorder(),
                                        ),

                                        style: const TextStyle(fontSize: 15),
                                        keyboardType: TextInputType.number,
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
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //Doctor Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: doctorNameCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              doctorNameCheck = value ?? false;
                            });
                          },
                        ),
                        Text('اسم الطبيب'),
                        SizedBox(width: 5,),
                        Visibility(
                            visible: doctorNameCheck,
                            child:
                            Row(
                              children: [
                                SizedBox(
                                    width: 190,
                                    height: 40,
                                    child: Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: TextFormField(
                                        textAlign: TextAlign.right,
                                        controller: doctorName,
                                        decoration: const InputDecoration(
                                          hintText: 'ادخل القيمة',
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //Presc Type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: prescTypeCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              prescTypeCheck = value ?? false;
                            });
                          },
                        ),
                        Text('نوع الكشف'),
                        SizedBox(width: 5,),
                        Visibility(
                            visible: prescTypeCheck,
                            child:
                            Row(
                              children: [
                                SizedBox(
                                    width: 180,
                                    height: 40,
                                    child: Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: TextFormField(
                                        textAlign: TextAlign.right,
                                        controller: prescType,
                                        decoration: const InputDecoration(
                                          hintText: 'ادخل القيمة',
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                          border: OutlineInputBorder(),
                                        ),

                                        style: const TextStyle(fontSize: 15),
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
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //Lens Type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: lensTypeCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              lensTypeCheck = value ?? false;
                            });
                          },
                        ),
                        Text('نوع العدسة'),
                        SizedBox(width: 5,),
                        Visibility(
                            visible: lensTypeCheck,
                            child:
                            Row(
                              children: [
                                SizedBox(
                                    width: 180,
                                    height: 40,
                                    child: Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: TextFormField(
                                        textAlign: TextAlign.right,
                                        controller: lensType,
                                        decoration: const InputDecoration(
                                          hintText: 'ادخل القيمة',
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                          border: OutlineInputBorder(),
                                        ),

                                        style: const TextStyle(fontSize: 15),
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
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //Lens Color
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: lensColorCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              lensColorCheck = value ?? false;
                            });
                          },
                        ),
                        Text('لون العدسة'),
                        SizedBox(width: 5,),
                        Visibility(
                            visible: lensColorCheck,
                            child:
                            Row(
                              children: [
                                SizedBox(
                                    width: 180,
                                    height: 40,
                                    child: Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: TextFormField(
                                        textAlign: TextAlign.right,
                                        controller: lensColor,
                                        decoration: const InputDecoration(
                                          hintText: 'ادخل القيمة',
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                          border: OutlineInputBorder(),
                                        ),

                                        style: const TextStyle(fontSize: 15),
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
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //Solution Type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: solutionTypeCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              solutionTypeCheck = value ?? false;
                            });
                          },
                        ),
                        Text('نوع المحلول'),
                        SizedBox(width: 5,),
                        Visibility(
                            visible: solutionTypeCheck,
                            child:
                            Row(
                              children: [
                                SizedBox(
                                    width: 180,
                                    height: 40,
                                    child: Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: TextFormField(
                                        textAlign: TextAlign.right,
                                        controller: solutionType,
                                        decoration: const InputDecoration(
                                          hintText: 'ادخل القيمة',
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                          border: OutlineInputBorder(),
                                        ),

                                        style: const TextStyle(fontSize: 15),
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
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //Payment Method
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: paymentMethodCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              paymentMethodCheck = value ?? false;
                            });
                          },
                        ),
                        Text('طريقة الدفع'),
                        SizedBox(width: 0,),
                        Visibility(
                          visible: paymentMethodCheck,

                          child: Row(
                            children: [
                              Directionality(
                                textDirection: ui.TextDirection.ltr,
                                child:  Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('فيزا'),
                                    Radio(
                                      value: "فيزا",
                                      groupValue: paymentMethod,
                                      onChanged: (value) {
                                        setState(() {
                                          paymentMethod = value as String?;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 0),
                                    const Text('جهات'),
                                    Radio(
                                      value: "جهات",
                                      groupValue: paymentMethod,
                                      onChanged: (value) {
                                        setState(() {
                                          paymentMethod = value as String?;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 0),
                                    const Text('كاش'),
                                    Radio(
                                      value: "كاش",
                                      groupValue: paymentMethod,
                                      onChanged: (value) {
                                        setState(() {
                                          paymentMethod = value as String?;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 0),

                                  ],
                                ),
                              ),
                              )

                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    //Total Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: totalPriceCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              totalPriceCheck = value ?? false;
                            });
                          },
                        ),
                        Text('السعر'),
                        SizedBox(width: 5,),
                        Visibility(
                            visible: totalPriceCheck,
                            child:
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      controller: minPrice,
                                      decoration: const InputDecoration(
                                        labelText: 'من',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: OutlineInputBorder(),
                                      ),

                                      style: const TextStyle(fontSize: 15),
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'يجب ادخال تلك الخانة';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      controller: maxPrice,
                                      decoration: const InputDecoration(
                                        labelText: 'الى',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        border: OutlineInputBorder(),
                                      ),

                                      style: const TextStyle(fontSize: 15),
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'يجب ادخال تلك الخانة';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
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
                        // (searchingResults());
                        searchingResults();
                      },
                      child: const Text(
                        "بحث",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),

                    SizedBox(height: 20,),

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
                      child: DataTable(

                        columns: createDataColumns(),
                        rows: List.generate(
                          len > tableDataList.length ? tableDataList.length : len,

                              (index) {
                            final rowData = tableDataList[index];

                            final clientData = index < clientDataList.length ? clientDataList[index] : {};

                            final prescriptionDate = rowData['prescription_date'].toString();
                            final age = calculateAge(clientData['client_birth_date'].toString());

                            return DataRow(
                              cells: [
                                DataCell(Text(rowData['prescription_id'].toString())),
                                DataCell(Text(rowData['client_name'].toString())),
                                DataCell(Text(clientData['client_phone1'].toString())),
                                DataCell(Text(age.toString())),
                                DataCell(Text(prescriptionDate)),
                                DataCell(
                                  Directionality(
                                    textDirection: ui.TextDirection.ltr,
                                    child: Text(rowData['r_sph_d'].toString()),
                                  ),
                                ),
                                DataCell(
                                  Directionality(
                                    textDirection: ui.TextDirection.ltr,
                                    child: Text(rowData['r_cyl_d'].toString()),
                                  ),
                                ),
                                DataCell(
                                  Directionality(
                                    textDirection: ui.TextDirection.ltr,
                                    child: Text(rowData['r_axis_d'].toString()),
                                  ),
                                ),
                                DataCell(
                                  Directionality(
                                    textDirection: ui.TextDirection.ltr,
                                    child: Text(rowData['r_sph_r'].toString()),
                                  ),
                                ),
                                DataCell(
                                  Directionality(
                                    textDirection: ui.TextDirection.ltr,
                                    child: Text(rowData['r_cyl_r'].toString()),
                                  ),
                                ),
                                DataCell(
                                  Directionality(
                                    textDirection: ui.TextDirection.ltr,
                                    child: Text(rowData['r_axis_r'].toString()),
                                  ),
                                ),
                                DataCell(
                                  Directionality(
                                    textDirection: ui.TextDirection.ltr,
                                    child: Text(rowData['l_sph_d'].toString()),
                                  ),
                                ),
                                DataCell(
                                  Directionality(
                                    textDirection: ui.TextDirection.ltr,
                                    child: Text(rowData['l_cyl_d'].toString()),
                                  ),
                                ),
                                DataCell(
                                  Directionality(
                                    textDirection: ui.TextDirection.ltr,
                                    child: Text(rowData['l_axis_d'].toString()),
                                  ),
                                ),
                                DataCell(
                                  Directionality(
                                    textDirection: ui.TextDirection.ltr,
                                    child: Text(rowData['l_sph_r'].toString()),
                                  ),
                                ),
                                DataCell(
                                  Directionality(
                                    textDirection: ui.TextDirection.ltr,
                                    child: Text(rowData['l_cyl_r'].toString()),
                                  ),
                                ),
                                DataCell(
                                  Directionality(
                                    textDirection: ui.TextDirection.ltr,
                                    child: Text(rowData['l_axis_r'].toString()),
                                  ),
                                ),
                                DataCell(
                                  Directionality(
                                    textDirection: ui.TextDirection.ltr,
                                    child: Text(rowData['ipd'].toString()),
                                  ),
                                ),
                                DataCell(Text(rowData['doctor_name'].toString())),
                                DataCell(Text(rowData['prescription_type'].toString())),
                                DataCell(Text(rowData['lens_type'].toString())),
                                DataCell(Text(rowData['lens_color'].toString())),
                                DataCell(Text(rowData['solution_type'].toString())),
                                DataCell(Text(rowData['payment_method'].toString())),
                                DataCell(Text(rowData['total_price'].toString())),

                              ],
                            );
                          },
                        ),
                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}




class AddPrescriptionWindow extends StatefulWidget {
  final String text;
  AddPrescriptionWindow({Key? key, required this.text}) : super(key: key);

  @override
  _AddPrescriptionWindowState createState() => _AddPrescriptionWindowState();
}

class _AddPrescriptionWindowState extends State<AddPrescriptionWindow> {

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController ipd = TextEditingController();
  TextEditingController totalPrice = TextEditingController();
  List<String> nameOptions = [];
  List<String> doctorOptions = [];
  List<String> fetchedClients = [];
  List<String> fetchedDoctors = [];
  String? selectedNameOption; // Declare the selected option variable
  String? selectedDoctorOption;
  bool isPhoneNumberFound = true;
  DateTime? selectedBirthDate;
  DateTime? selectedPrescDate;

  bool isLensSelected = false;

  String? selectedPrescriptionType;
  String? selectedLensType;
  String? selectedLensColor;
  String? selectedSolutionType;
  String? _selectedPaymentMethod;

  String? message;

  List<TextEditingController> controllers = List.generate(12, (_) => TextEditingController(),);
  List<String> eye_power = List.generate(12, (_) => '');

  List<String> prescriptionTypes = ["رمد", "نظارة", "عدسات", "عملية ليزك", "المياه البيضاء"];

  List<String> lensTypes = [
    "Acuvue 2",
    "Bella",
    "Bella elite",
    "Bella glow",
    "Bio(3)",
    "Bio toric",
    "Clear vision",
    "Comfort",
    "Dahab",
    "Desio",
    "Flexcon",
    "Lens(s)",
    "Magic",
    "My lens",
    "Oasys",
    "Oasys toric",
    "Pure vision 2",
    "Soft toric",
    "Zeiss",
  ];

  List<String> lensColors = [];

  List<String> solutionTypes = [
    "bio true 60 ml",
    "Renu 60 ml",
    "Dahab 100 ml",
  ];

  void UpdateLensColors() {

    List<String> list = [];

    setState(() {
      lensColors.clear();
      list.clear();
      selectedLensColor = null;
    });


    List<String> myLensColors = [
      "Blue",
      "Capri",
      "Light brown",
      "Light gray",
      "Light green",
      "Oro brown",
      "Oro gray",
      "Oro hazel",
      "Turquoise",
    ];

    List<String> magicLensColors = [
      "Accio Hazel",
      "Blue",
      "Charm gray",
      "Golden brown",
      "Hermon green",
      "Oblivion gray",
      "Turquoise",
    ];

    List<String> dahabLensColors = [
      "Blue",
      "Cappuccino",
      "Gray",
      "Green",
      "Hazel",
      "Honey",
    ];
    List<String> desioLensColors = [
      "Charming green",
      "Delicious honey",
      "Irresistible blue",
      "Precious gray",
      "Rebal gray",
      "Romantic blue",
      "Tender hazel",
      "Wild green",
    ];
    List<String> luminousLensColors = [
      "Blue",
      "Crystal",
      "Dazzling green",
      "Gray",
      "Green",
      "Hazel",
      "Lazord",
      "Latin brown",
      "Latin gray",
      "Lemon",
    ];
    List<String> bellaEliteLensColors = [
      "Amber gray",
      "Crystal N",
      "Gray beige",
      "Midnight blue",
      "Mint gray",
      "Sandy brown",
      "Sandy gray",
      "Silky gold",
      "Silky green",
    ];
    List<String> bellaGlowLensColors = [
      "Gray caramel",
      "Husky gray Green",
      "Lime green",
      "Luminous blue",
      "Navy gray",
      "Radiant brown",
      "Radiant hazelnut",
      "Radiant gray",
      "Vivid blue",
    ];
    List<String> bellaLensColors = [
      "Almond brown",
      "Brown shadow",
      "Caribbean green",
      "Cool blue",
      "Cool gray",
      "Cool hazel",
      "Gray green",
      "Gray shadow",
      "Natural blue",
      "Natural gray",
      "Natural green",
      "Natural hazel",
    ];
    List<String> transparent = ["Transparent"];




    setState(() {
      if (selectedLensType == "My lens") {
        list = myLensColors;
      } else if (selectedLensType == "Magic") {
        list = magicLensColors;
      } else if (selectedLensType == "Dahab") {
        list = dahabLensColors;
      } else if (selectedLensType == "Desio") {
        list = desioLensColors;
      } else if (selectedLensType == "Luminous") {
        list = luminousLensColors;
      } else if (selectedLensType == "Bella elite") {
        list = bellaEliteLensColors;
      } else if (selectedLensType == "Bella glow") {
        list = bellaGlowLensColors;
      } else if (selectedLensType == "Bella") {
        list = bellaLensColors;
      } else if(selectedLensType != null){
        list = transparent;
      }
    });

    setState(() {

      lensColors = list.toList();
      // selectedLensColor = lensColors.first;
    });

  }


  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    phoneNumber.dispose();
    ipd.dispose();
    totalPrice.dispose();
    super.dispose();
  }

  void updateNameOptions(String phoneNumber) async {

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
          nameOptions = fetchedClients;
          selectedNameOption = nameOptions.isNotEmpty ? nameOptions[0] : null;
        });
      } else {
        setState(() {
          isPhoneNumberFound = false;
          nameOptions = [];
          selectedNameOption = null;
        });
      }
    }

    await getNames();
  }

  void updateDoctorOptions() async {

    Future<void> getDoctors() async {

      String query = 'select doctor_name from doctors';
      List<dynamic> params = [];
      List<Map<String, dynamic>> fetchedData = await getData(query, params);



      fetchedDoctors = [];
      if (fetchedData.isNotEmpty) {
        for (var row in fetchedData) {
          var doctorName = row['doctor_name'].toString();
          fetchedDoctors.add(doctorName);
        }
        setState(() {
          doctorOptions = fetchedDoctors;
          // selectedDoctorOption = doctorOptions.isNotEmpty ? doctorOptions[0] : null;
        });
      } else {
        setState(() {
          doctorOptions = [];
          selectedDoctorOption = null;
        });
      }
    }

    await getDoctors();
  }

  Future<void> addNewPresc() async {

    String clientName = selectedNameOption.toString();
    String phone = phoneNumber.text;


    String query = 'select client_id from clients where client_name = ? and (client_phone1 = ? or client_phone2 = ?)';
    List<dynamic> params = [clientName, phone, phone];
    List<Map<String, dynamic>> fetchedData = await getData(query, params);

    int clientID = int.parse(fetchedData[0]['client_id']);

    String prescDate = selectedPrescDate.toString();
    var r_sph_d = eye_power[0];
    var r_cyl_d = eye_power[1];
    var r_axis_d = eye_power[2];
    var r_sph_r = eye_power[3];
    var r_cyl_r = eye_power[4];
    var r_axis_r = eye_power[5];
    var l_sph_d = eye_power[6];
    var l_cyl_d = eye_power[7];
    var l_axis_d = eye_power[8];
    var l_sph_r = eye_power[9];
    var l_cyl_r = eye_power[10];
    var l_axis_r = eye_power[11];

    int IPD = 0;
    if (ipd.text.isNotEmpty) IPD = int.parse(ipd.text);

    String doctorName = selectedDoctorOption.toString();

    query = 'select doctor_id from doctors where doctor_name = ?';
    params = [doctorName];
    fetchedData = await getData(query, params);

    int doctorID = int.parse(fetchedData[0]['doctor_id']);
    String prescType = selectedPrescriptionType.toString();
    String lensType = selectedLensType.toString();
    String lensColor = selectedLensColor.toString();
    String solutionType = selectedSolutionType.toString();
    String paymentMethod = _selectedPaymentMethod.toString();
    double price = 0;
    if (totalPrice.text.isNotEmpty) price = double.parse(totalPrice.text);


    query = 'insert into prescriptions (client_id, client_name, prescription_date, '
        'r_sph_d, r_cyl_d, r_axis_d, r_sph_r, r_cyl_r, r_axis_r, '
        'l_sph_d, l_cyl_d, l_axis_d, l_sph_r, l_cyl_r, l_axis_r,'
        'ipd, doctor_id, doctor_name, prescription_type, '
        'lens_type, lens_color, solution_type, payment_method, total_price) '
        'values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';

    params = [clientID, clientName, prescDate,
      r_sph_d, r_cyl_d, r_axis_d, r_sph_r, r_cyl_r, r_axis_r,
      l_sph_d, l_cyl_d, l_axis_d, l_sph_r, l_cyl_r, l_axis_r,
      IPD, doctorID, doctorName, prescType,
      lensType, lensColor, solutionType, paymentMethod, price];

    executeQuery(query, params);


    query = 'select prescriptions_numbers from doctors where doctor_id = ?';
    params = [doctorID];
    fetchedData = await getData(query, params);
    int prescNum = int.parse(fetchedData[0]['prescriptions_numbers']);
    prescNum += 1;

    query = 'update doctors set prescriptions_numbers = ? where doctor_id = ?';
    params = [prescNum, doctorID];
    executeQuery(query, params);

    query = 'select client_birth_date from clients where client_id = ?';
    params = [clientID];
    fetchedData = await getData(query, params);
    String date = fetchedData[0]['client_birth_date'].toString();

    int age = calculateAge(date);

    setState(() {
      message = "Prescription Details for $clientName:\n\n"
          "Phone: $phone\n\n"
          "العمر: $age\n\n"
          "نوع الكشف: كشف نظارة"
          "\n\nRight Eye:\n"
          "  - Sphere (D): $r_sph_d\n"
          "  - Cylinder (D): $r_cyl_d\n"
          "  - Axis (D): $r_axis_d\n"
          "  - Sphere (R): $r_sph_r\n"
          "  - Cylinder (R): $r_cyl_r\n"
          "  - Axis (R): $r_axis_r\n\n"
          "Left Eye:\n"
          "  - Sphere (D): $l_sph_d\n"
          "  - Cylinder (D): $l_cyl_d\n"
          "  - Axis (D): $l_axis_d\n"
          "  - Sphere (R): $l_sph_r\n"
          "  - Cylinder (R): $l_cyl_r\n"
          "  - Axis (R): $l_axis_r\n\n"
          "IPD : $IPD\n\n";

    });

    if (selectedPrescriptionType == 'نظارة') {
      print("message: $message");
      sendWhatsAppMessage("+2001097968038", "$message");
    }

    setState(() {



      phoneNumber.clear();
      selectedNameOption = null;
      for (var i = 0; i < controllers.length; i++) {
        controllers[i].clear();
      }
      selectedPrescDate = null;
      ipd.clear();
      selectedDoctorOption = null;
      updateDoctorOptions();
      selectedPrescriptionType = null;
      isLensSelected = false;
      selectedLensType = null;
      selectedLensColor = null;
      selectedSolutionType = null;
      _selectedPaymentMethod = null;
      totalPrice.clear();
      message  = "";
    });


  }

  Future<void> _selectPrescDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedPrescDate) {
      setState(() {
        selectedPrescDate = picked;
      });
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


  final _formKey = GlobalKey<FormState>();

  TextEditingController clientName = TextEditingController();
  TextEditingController phoneNumber1 = TextEditingController();
  TextEditingController phoneNumber2 = TextEditingController();
  TextEditingController clientEmail = TextEditingController();
  String clientGender = "";
  // DateTime? selectedDate;
  Gender? selectedGender;


  @override
  void initState() {
    super.initState();
    updateDoctorOptions();
    clientName = TextEditingController();
    phoneNumber1 = TextEditingController();
    phoneNumber2 = TextEditingController();
    clientEmail = TextEditingController();
    phoneNumber.text = widget.text;
    updateNameOptions(phoneNumber.text);
    UpdateLensColors();
    // Initialize other controllers here if needed
  }




  Future<void> insertClientData() async {

    String name = clientName.text;
    String phone1 = phoneNumber1.text;
    String phone2 = phoneNumber2.text;
    String birthDate = selectedBirthDate.toString();
    String gender = clientGender;


    String query = 'insert into clients (client_name, client_phone1, client_phone2, client_birth_date, client_gender) '
        'values (?, ?, ?, ?, ?)';
    List<dynamic> params = [name, phone1, phone2, birthDate, gender];

    executeQuery(query, params);


    String updatePhone = phoneNumber.text;
    print(updatePhone);
    setState(() {
      phoneNumber = TextEditingController(text: updatePhone);
      showAddClient(updatePhone); // Pass the current value of phoneNumber
    });


    clientName.clear();
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

  Column showLensMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            Flexible(
              child: SizedBox(
                width: 200,
                height: 90,
                child: Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLensColor = newValue;
                      });
                    },
                    value: selectedLensColor, // Set the selected value for lens color
                    items: lensColors.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                    hint: const Text(
                        'اختار لون العدسة',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Flexible(
              child: SizedBox(
                width: 200,
                height: 90,
                child: Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLensType = newValue; // Update the selectedOption
                        UpdateLensColors();
                      });
                    },
                    items: lensTypes.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                    hint: const Text(
                        'اختار نوع العدسة',
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
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: SizedBox(
                width: 200,
                height: 90,
                child: Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSolutionType = newValue;
                      });
                    },
                    items: solutionTypes.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                    hint: const Text(
                        'اختار نوع المحلول',
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

      ],
    );
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              const Text(
                "اضافة كشف جديد",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: SizedBox(
                        width: 250,
                        height: 90,
                        child: Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: TextFormField(
                            textAlign: TextAlign.right,
                            controller: phoneNumber,
                            decoration: InputDecoration(
                              labelText: "رقم الهاتف",
                              border: const OutlineInputBorder(),
                              errorText: isPhoneNumberFound
                                  ? null
                                  : 'الرقم غير موجود', // Show error message if phone number is not found
                            ),
                            style: const TextStyle(fontSize: 15),
                            keyboardType: TextInputType.phone,
                            onChanged: updateNameOptions, // Call updateOptions on phone number change
                          ),
                        )

                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: 250,
                      height: 90,
                      child: Directionality(
                        textDirection: ui.TextDirection.rtl,
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
                          value: selectedNameOption, // Declare and initialize selectedOption
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedNameOption = newValue; // Update the selectedOption
                            });
                          },
                          items: nameOptions.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(
                                option,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                          hint: const Text(
                            'اختار اسم العميل',
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _selectPrescDate(context);
                      },
                      child: AbsorbPointer(
                        child: SizedBox(
                          width: 250,
                          height: 60,
                          child: Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: "تاريخ الكشف",
                                border: OutlineInputBorder(),
                              ),
                              style: const TextStyle(fontSize: 15),
                              keyboardType: TextInputType.datetime,
                              controller: TextEditingController(
                                text: selectedPrescDate != null
                                    ? formatter.format(selectedPrescDate!)
                                    : '',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Align(
                alignment: Alignment.center,
                child: Container(
                  // width: 600,
                  height: 200,
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
                                                child: TextField(
                                                  textAlign: TextAlign.center,
                                                  // textAlignVertical: TextAlignVertical.top,
                                                  style: const TextStyle(fontSize: 8),
                                                  decoration: const InputDecoration(
                                                    border: UnderlineInputBorder(),
                                                  ),
                                                  controller: controllers[0],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      eye_power[0] = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Container(
                                                height: 30,
                                                alignment: Alignment.center,
                                                child: TextField(
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 8),
                                                  decoration: const InputDecoration(
                                                    border: UnderlineInputBorder(),
                                                  ),
                                                  controller: controllers[1],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      eye_power[1] = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Container(
                                                height: 30,
                                                alignment: Alignment.center,
                                                child: TextField(
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 8),
                                                  decoration: const InputDecoration(
                                                    border: UnderlineInputBorder(),
                                                  ),
                                                  controller: controllers[2],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      eye_power[2] = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
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
                                                child: TextField(
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 8),
                                                  decoration: const InputDecoration(
                                                    border: UnderlineInputBorder(),
                                                  ),
                                                  controller: controllers[3],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      eye_power[3] = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Container(
                                                height: 30,
                                                alignment: Alignment.center,
                                                child: TextField(
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 8),
                                                  decoration: const InputDecoration(
                                                    border: UnderlineInputBorder(),
                                                  ),
                                                  controller: controllers[4],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      eye_power[4] = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Container(
                                                height: 30,
                                                alignment: Alignment.center,
                                                child: TextField(
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 8),
                                                  decoration: const InputDecoration(
                                                    border: UnderlineInputBorder(),
                                                  ),
                                                  controller: controllers[5],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      eye_power[5] = value;
                                                    });
                                                  },
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
                                                child: TextField(
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 8),
                                                  decoration: const InputDecoration(
                                                    border: UnderlineInputBorder(),
                                                  ),
                                                  controller: controllers[6],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      eye_power[6] = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Container(
                                                height: 30,
                                                alignment: Alignment.center,
                                                child: TextField(
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 8),
                                                  decoration: const InputDecoration(
                                                    border: UnderlineInputBorder(),
                                                  ),
                                                  controller: controllers[7],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      eye_power[7] = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Container(
                                                height: 30,
                                                alignment: Alignment.center,
                                                child: TextField(
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 8),
                                                  decoration: const InputDecoration(
                                                    border: UnderlineInputBorder(),
                                                  ),
                                                  controller: controllers[8],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      eye_power[8] = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
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
                                                child: TextField(
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 8),
                                                  decoration: const InputDecoration(
                                                    border: UnderlineInputBorder(),
                                                  ),
                                                  controller: controllers[9],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      eye_power[9] = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Container(
                                                height: 30,
                                                alignment: Alignment.center,
                                                child: TextField(
                                                  textAlign: TextAlign.center,
                                                  textAlignVertical: TextAlignVertical.top,
                                                  style: const TextStyle(fontSize: 8),
                                                  decoration: const InputDecoration(
                                                    border: UnderlineInputBorder(),
                                                  ),
                                                  controller: controllers[10],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      eye_power[10] = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Container(
                                                height: 30,
                                                alignment: Alignment.center,
                                                child: TextField(
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 8),
                                                  decoration: const InputDecoration(
                                                    border: UnderlineInputBorder(),
                                                  ),
                                                  controller: controllers[11],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      eye_power[11] = value;
                                                    });
                                                  },
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
                )
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: 80,
                      height: 50,
                      child: TextFormField(
                        controller: ipd,
                        decoration: const InputDecoration(
                          labelText: "I.P.D:",
                          border: OutlineInputBorder(),
                        ),
                        style: const TextStyle(fontSize: 12),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),

                ],
              ),

              // const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: 250,
                      height: 90,
                      child: Directionality(
                        textDirection: ui.TextDirection.rtl,
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
                          // value: selectedDoctorOption, // Declare and initialize selectedOption
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDoctorOption = newValue; // Update the selectedOption
                            });
                          },
                          items: doctorOptions.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(
                                option,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            );
                          }).toList(),
                          hint: const Text(
                            'اسم الطبيب',
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: 250,
                      height: 90,
                      child: Directionality(
                        textDirection: ui.TextDirection.rtl,
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
                          // value: selectedDoctorOption, // Declare and initialize selectedOption
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPrescriptionType = newValue; // Update the selectedOption
                              if (newValue == 'عدسات'){
                                setState(() {
                                  isLensSelected = true;
                                });
                              }
                              else {
                                setState(() {
                                  isLensSelected = false;
                                });
                              }
                            });
                          },
                          items: prescriptionTypes.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(
                                option,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            );
                          }).toList(),
                          hint: const Text(
                            'اختار نوع الكشف',
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

              const SizedBox(height: 20),

              Visibility(
                visible: (isLensSelected),
                child: showLensMenu(),
              ),

              const SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "طريقة الدفع",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('فيزا'),
                    Radio(
                      value: "فيزا",
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value as String?;
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                    const Text('جهات'),
                    Radio(
                      value: "جهات",
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value as String?;
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                    const Text('كاش'),
                    Radio(
                      value: "كاش",
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value as String?;
                        });
                      },
                    ),
                    const SizedBox(width: 10),

                  ],
                ),
              ),
              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: 200,
                      height: 60,
                      child: Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          controller: totalPrice,
                          decoration: const InputDecoration(
                            labelText: "السعر",
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 15),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                      )
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40,),

              ElevatedButton(
                onPressed: (isPhoneNumberFound && phoneNumber.text.isNotEmpty && selectedDoctorOption != null) ? () {
                  addNewPresc();
                  showMessage(context, "تمت اضافة الكشف بنجاح");

                } : null,
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(100, 25)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: const Text(
                  "اضافة الكشف",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Visibility(
                visible: (phoneNumber.text.length == 11 && !isPhoneNumberFound),
                child: showAddClient(phoneNumber.text),
              ),
            ]
          ),
        ),
      ),
    );
  }
}