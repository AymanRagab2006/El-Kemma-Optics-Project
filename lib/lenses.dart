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
import 'package:dropdown_search/dropdown_search.dart';







class LensesWindow extends StatelessWidget {
  const LensesWindow({super.key});

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
                "التعامل مع العدسات اللاصقة",
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
                    MaterialPageRoute(builder: (context) => AddLensWindow()),
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(225, 35)), // Set the minimum dimensions
                ),
                child: const Text(
                  'اضافة عدسة جديدة',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LensPurchaseWindow()),
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(225, 35)), // Set the minimum dimensions
                ),
                child: const Text(
                  'اضافة فاتورة شراء',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              const SizedBox(height: 30),
              // ElevatedButton(
              //   onPressed: () {
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(builder: (context) => UpdatePrescriptionWindow()),
              //     // );
              //   },
              //   style: ButtonStyle(
              //     minimumSize: MaterialStateProperty.all(const Size(225, 35)), // Set the minimum dimensions
              //   ),
              //   child: const Text(
              //     'تحديث بيانات كشف',
              //     style: TextStyle(fontSize: 18),
              //   ),
              // ),
              // const SizedBox(height: 30),
              // ElevatedButton(
              //   onPressed: () {
              //
              //   },
              //   style: ButtonStyle(
              //     minimumSize: MaterialStateProperty.all(const Size(225, 35)), // Set the minimum dimensions
              //   ),
              //   child: const Text(
              //     'حذف كشف',
              //     style: TextStyle(fontSize: 18),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}


class LensData {
  String name = '';
  String color = '';
  String price = '';
  String quantity = '';
}


class AddLensWindow extends StatefulWidget {
  const AddLensWindow({Key? key}) : super(key: key);

  @override
  _AddLensWindowState createState() => _AddLensWindowState();
}

class _AddLensWindowState extends State<AddLensWindow> {

  TextEditingController lensNameController = TextEditingController();
  TextEditingController lensPriceController = TextEditingController();

  List<LensData> lensDataList = [];

  void addColorInput() {
    setState(() {
      lensDataList.add(LensData());
    });
  }

  void removeColorInput(int index) {
    setState(() {
      lensDataList.removeAt(index);
    });
  }

  void addLensesData() async{

    String name = lensNameController.text;
    double price = double.parse(lensPriceController.text);

    String query = '';
    List<dynamic> params = [];

    for (LensData lensData in lensDataList) {
      query = 'insert into lenses (lens_name, lens_color, lens_quantity, lens_price) values (?, ?, ?, ?)';
      params = [name, lensData.color, lensData.quantity, price];
      await executeQuery(query, params);
      // print('Name: $name, Color: ${lensData.color}, Price: ${lensPriceController.text}, Quantity: ${lensData.quantity}');
    }

    setState(() {
      lensNameController.clear();
      lensPriceController.clear();
      lensDataList.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز عيون'),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "اضافة عدسة جديدة",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: Flexible(
                        child: SizedBox(
                          width: 300,
                          height: 90,
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            controller: lensNameController,
                            decoration: const InputDecoration(
                              labelText: "اسم العدسة",
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(fontSize: 15),
                            keyboardType: TextInputType.name,
                          )
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: Flexible(
                        child: SizedBox(
                            width: 200,
                            height: 90,
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              controller: lensPriceController,
                              decoration: const InputDecoration(
                                labelText: "سعر العدسة",
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(fontSize: 15),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                            )
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: lensDataList.asMap().entries.map((entry) {
                    int index = entry.key;
                    LensData lensData = entry.value;

                    return Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              onChanged: (newColor) {
                                setState(() {
                                  lensData.color = newColor;
                                });
                              },
                              initialValue: lensData.color,
                              decoration: InputDecoration(labelText: 'لون العدسة'),
                              style: TextStyle(fontSize: 15),
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              onChanged: (newQuantity) {
                                setState(() {
                                  lensData.quantity = newQuantity;
                                });
                              },
                              initialValue: lensData.quantity,
                              decoration: InputDecoration(labelText: 'الكمية'),
                              style: TextStyle(fontSize: 15),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.grey, // Customize the color of the 'X' icon here
                              size: 30,
                            ),
                            onPressed: () {
                              removeColorInput(index);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 20,),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(150, 25)),
                  ),
                  onPressed: () {
                    addColorInput();
                  },
                  child: Text('اضافة لون جديد'),
                ),

                SizedBox(height: 60),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(150, 25)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    addLensesData();
                    showMessage(context, 'تمت اضافة العدسة بنجاح');
                  },
                  child: const Text(
                    'اضافة العدسة',
                    style: TextStyle(fontSize: 20),
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



class LensPurchaseWindow extends StatefulWidget {
  const LensPurchaseWindow({Key? key}) : super(key: key);

  @override
  _LensPurchaseWindowState createState() => _LensPurchaseWindowState();
}

class _LensPurchaseWindowState extends State<LensPurchaseWindow> {

  DateTime? selectedDate = DateTime.now();
  String? selectedLensName;
  String? selectedLensColor;
  TextEditingController lensQuantity = TextEditingController();

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

  void getLensNames() async {
    String query = 'select lens_name from lenses';
    List<dynamic> params = [];
    List<Map<String, dynamic>> fetchedData = await getData(query, params);
    // List<String> namesList = fetchedData.map((item) => item['lens_name'] as String).toList();

    List<String> namesList = fetchedData
        .map((item) => item['lens_name'] as String)
        .toSet()
        .toList();

    setState(() {
      lensNames = namesList;
    });
    print(lensNames);
  }

  void getLensColors() async {
    String query = 'select lens_color from lenses where lens_name =  ?';
    List<dynamic> params = [selectedLensName];
    List<Map<String, dynamic>> fetchedData = await getData(query, params);

    List<String> colorsList = fetchedData.map((item) => item['lens_color'] as String).toList();



    setState(() {
      lensColors = colorsList;
    });
    print(lensColors);
  }

  List<String> lensNames = [];
  List<String> lensColors = [];

  List<LensData> lensDataList = [];

  void addLensInput() {
    setState(() {
      lensDataList.add(LensData());
    });
  }

  void removeLensInput(int index) {
    setState(() {
      lensDataList.removeAt(index);
    });
  }

  void addLensPurchase() async {
    for (LensData lensData in lensDataList) {

      print('Name: ${lensData.name}, Color: ${lensData.color}, Quantity: ${lensData.quantity}');
    }
  }

  @override
  void initState() {
    super.initState();
    getLensNames();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز عيون'),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "اضافة فاتورة شراء عدسات",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: SizedBox(
                        width: 300,
                        height: 90,
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          onTap: () => _selectDate(context),
                          controller: TextEditingController(
                            text: selectedDate == null
                                ? "اختار تاريخ عملية الشراء"
                                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          ),
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "تاريخ عملية الشراء",
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => _selectDate(context),
                              icon: const Icon(Icons.calendar_today),
                            ),
                          ),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),

                SizedBox(height: 30,),


                Directionality(
                  textDirection: ui.TextDirection.rtl,

                  child: Column(
                    children: lensDataList.asMap().entries.map((entry) {
                      int index = entry.key;
                      LensData lensData = entry.value;
                      int rowNumber = index + 1;

                      return Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: Row(
                          children: [
                            Text('$rowNumber. '),
                            SizedBox(width: 10,),
                            SizedBox(
                              width: 200,
                              child: DropdownSearch<String>(
                                popupProps: PopupProps.menu(
                                  showSelectedItems: true,
                                  showSearchBox: true,
                                ),
                                items: lensNames,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "اسم العدسة",
                                  ),
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedLensName = newValue;
                                    lensData.name = newValue!;
                                    getLensColors();
                                  });
                                },
                                // selectedItem: "Brazil",

                              ),
                            ),
                            SizedBox(width: 20),
                            SizedBox(
                              width: 200,
                              child: DropdownSearch<String>(
                                popupProps: PopupProps.menu(
                                  showSelectedItems: true,
                                  showSearchBox: true,
                                ),
                                items: lensColors,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "لون العدسة",
                                  ),
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedLensColor = newValue;
                                    lensData.color = newValue!;
                                  });
                                },
                                // selectedItem: lensColors.isNotEmpty ? lensColors[0] : null,
                                // selectedItem: lensData.color,
                              ),
                            ),
                            SizedBox(width: 20,),
                            SizedBox(
                                width: 150,
                                child: TextFormField(
                                  textAlign: TextAlign.left,
                                  // controller: lensQuantity,
                                  onChanged: (newQuantity) {
                                    setState(() {
                                      lensData.quantity = newQuantity;
                                    });
                                  },
                                  initialValue: lensData.quantity,
                                  decoration: const InputDecoration(
                                    labelText: "الكمية",
                                    // border: OutlineInputBorder(),
                                  ),
                                  style: TextStyle(fontSize: 15),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                )
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.grey, // Customize the color of the 'X' icon here
                                size: 30,
                              ),
                              onPressed: () {
                                removeLensInput(index);
                              },
                            ),
                            SizedBox(height: 100,),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),



                SizedBox(height: 30,),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(150, 25)),
                  ),
                  onPressed: () {
                    addLensInput();
                  },
                  child: Text('اضافة عدسة'),
                ),

                SizedBox(height: 60),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(150, 25)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    addLensPurchase();
                    // showMessage(context, 'تمت اضافة العدسة بنجاح');
                  },
                  child: const Text(
                    'اضافة العدسات الى المخزن',
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