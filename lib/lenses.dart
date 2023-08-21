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
              // ElevatedButton(
              //   onPressed: () {
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(builder: (context) => AddPrescriptionWindow(text: "")),
              //     // );
              //   },
              //   style: ButtonStyle(
              //     minimumSize: MaterialStateProperty.all(const Size(225, 35)), // Set the minimum dimensions
              //   ),
              //   child: const Text(
              //     'اضافة عدسة جديدة',
              //     style: TextStyle(fontSize: 18),
              //   ),
              // ),
              // const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SearchPrescriptionWindow()),
                  // );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(230, 35)), // Set the minimum dimensions
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