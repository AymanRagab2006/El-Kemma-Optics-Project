import 'package:el_kemma_optics/clients.dart';
import 'package:el_kemma_optics/doctors.dart';
import 'package:el_kemma_optics/lenses.dart';
import 'package:el_kemma_optics/prescriptions.dart';
import 'package:el_kemma_optics/db_connection.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ar'),
      title: 'مركز عيون',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
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
            children: [
              const Text(
                'اهلا بك في مركز عيون',
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
                      MaterialPageRoute(builder: (context) => const ClientsWindow())
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(200, 50)), // Set the minimum dimensions
                ),
                child: const Text(
                  'العملاء',
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrescriptionsWindow())
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(200, 50)), // Set the minimum dimensions
                ),
                child: const Text(
                    'الكشوفات',
                    style: TextStyle(
                        fontSize: 20
                    )
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DoctorsWindow())
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(200, 50)), // Set the minimum dimensions
                ),
                child: const Text(
                  'الأطباء',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),

              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LensesWindow())
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(200, 50)), // Set the minimum dimensions
                ),
                child: const Text(
                  'العدسات اللاصقة',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}