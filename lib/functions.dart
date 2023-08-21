import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;



void showMessage(BuildContext context, String message) {
  if (Platform.isAndroid || Platform.isIOS) {
    // Show a toast message on mobile
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }
  else {
    // Show a message box on other platforms (e.g., web, desktop)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تنبيه'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('تم'),
            ),
          ],
        );
      },
    );
  }
}

int calculateAge(String birthDateString) {
  final birthDate = DateTime.parse(birthDateString);
  final now = DateTime.now();
  int age = now.year - birthDate.year;

  // Check if the birth date has occurred this year
  if (now.month < birthDate.month ||
      (now.month == birthDate.month && now.day < birthDate.day)) {
    age--;
  }

  return age;
}

void sendWhatsAppMessage(String phoneNumber, String message) async {
  String url = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';


  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

String calculateBirthDateFromAge(String age) {
  int ageInt = int.tryParse(age) ?? 0; // Convert the age string to an integer
  DateTime currentDate = DateTime.now();
  int birthYear = currentDate.year - ageInt;
  int birthMonth = currentDate.month;
  int birthDay = currentDate.day;

  DateTime birthDate = DateTime(birthYear, birthMonth, birthDay);
  String formattedDate = DateFormat('yyyy-MM-dd').format(birthDate);

  return formattedDate;
}


Future<void> executeQuery(String query, List<dynamic> params) async {
  final response = await http.post(
    Uri.parse('https://alkemma.com/api2/insert_update_data.php'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'query': query, 'params': params}),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print('Query executed successfully. Changes: ${data['changes']}');
  } else {
    print('Failed to execute query: ${response.reasonPhrase}');
  }
}

Future<List<Map<String, dynamic>>> getData(String query, List<dynamic> params) async {

  final response = await http.post(
    Uri.parse('https://alkemma.com/api2/get_data.php'),
    headers: {'Content-Type': 'application/json; charset=utf-8'},
    body: jsonEncode({'query': query, 'params': params}),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data);
  } else {
    throw Exception('Failed to fetch data');
  }
}


