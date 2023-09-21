import 'package:el_kemma_optics/db_connection.dart';
import 'package:el_kemma_optics/functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:ui' as ui;



class DoctorsWindow extends StatelessWidget {
  const DoctorsWindow({super.key});

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
                "التعامل مع الأطباء",
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
                    MaterialPageRoute(builder: (context) => const AddDoctorWindow()),
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(225, 50)), // Set the minimum dimensions
                ),
                child: const Text(
                  'اضافة طبيب',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(225, 50)), // Set the minimum dimensions
                ),
                child: const Text(
                  'اصدار تقرير عن الأطباء',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UpdateDoctorWindow()),
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(225, 50)), // Set the minimum dimensions
                ),
                child: const Text(
                  'تحديث بيانات طبيب',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(225, 50)), // Set the minimum dimensions
                ),
                child: const Text(
                  'حذف طبيب',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}


                              class WorkingShift {
                                final String day;
                                final TimeOfDay? startTime;
                                final TimeOfDay? endTime;

                                WorkingShift({
                                  required this.day,
                                  this.startTime,
                                  this.endTime,
                                });

                                WorkingShift copyWith({
                                  String? day,
                                  TimeOfDay? startTime,
                                  TimeOfDay? endTime,
                                }) {
                                  return WorkingShift(
                                    day: day ?? this.day,
                                    startTime: startTime ?? this.startTime,
                                    endTime: endTime ?? this.endTime,
                                  );
                                }
                              }

typedef StartTimeChangedCallback = void Function(TimeOfDay?, TimeOfDay?);
typedef EndTimeChangedCallback = void Function(TimeOfDay?, TimeOfDay?);

class WorkingHoursRow extends StatelessWidget {
  final List<String> daysOfWeek;
  final String selectedDay;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final ValueChanged<String?> onDayChanged; // Updated to accept nullable String
  final StartTimeChangedCallback onStartTimeChanged;
  final EndTimeChangedCallback onEndTimeChanged;
  final VoidCallback onRemove;

  WorkingHoursRow({
    required this.daysOfWeek,
    required this.selectedDay,
    required this.startTime,
    required this.endTime,
    required this.onDayChanged,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: DropdownButton<String?>(
                    value: selectedDay,
                    onChanged: onDayChanged,
                    items: daysOfWeek.map((day) {
                      return DropdownMenuItem<String>(
                        value: day,
                        child: Text(day),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(width: 8),

                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? newStartTime = await showTimePicker(
                        context: context,
                        initialTime: startTime ?? TimeOfDay(hour: 9, minute: 0),
                      );
                      onStartTimeChanged(newStartTime, endTime); // Pass the endTime as well
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set the background color to white
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Colors.blue, width: 2.0), // Set the blue border with a width of 2.0
                      ),
                    ),
                    child: Text(
                      startTime == null ? "من" : "${startTime!.format(context)}",
                      style: TextStyle(color: Colors.black), // Set the text color to black
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? newEndTime = await showTimePicker(
                        context: context,
                        initialTime: endTime ?? TimeOfDay(hour: 17, minute: 0),
                      );
                      onEndTimeChanged(startTime, newEndTime); // Pass the startTime as well
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set the background color to white
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Colors.blue, width: 2.0), // Set the blue border with a width of 2.0
                      ),
                    ),
                    child: Text(
                      endTime == null ? "الى" : "${endTime!.format(context)}",
                      style: TextStyle(color: Colors.black), // Set the text color to black
                    ),
                  ),
                ),

                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onRemove,
                  child: const Icon(
                    Icons.remove, // Replace this with your preferred 'X' icon
                    color: Colors.grey, // You can customize the color of the 'X' icon here
                    size: 25, // You can customize the size of the 'X' icon here
                  ),
                ),
              ],
            )
          )
      ],
    );
  }
}

class UpdateDoctorWindow extends StatefulWidget {
  const UpdateDoctorWindow({Key? key}) : super(key: key);

  @override
  _UpdateDoctorWindowState createState() => _UpdateDoctorWindowState();
}

class _UpdateDoctorWindowState extends State<UpdateDoctorWindow> {

  TextEditingController doctorNameController = TextEditingController();
  TextEditingController doctorPhoneController = TextEditingController();
  DateTime? selectedBirthDate;
  String? _selectedDoctorGender;

  int doctorID = 0;
  String doctorName = 'لا يوجد';
  String doctorPhone = 'لا يوجد';
  String doctorGender = 'لا يوجد';
  String doctorBirthDate = 'لا يوجد';
  int totalPrescriptionsNumber = 0;
  List<Map<String, dynamic>> doctorWorkingHours = [];



  bool isDoctorNameFound = true;


  List<WorkingShift> workingHours = [];

  String? selectedDay;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  List<String> daysOfWeek = ['السبت', 'الأحد', 'الأثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'];

  void addWorkingShift(String day, TimeOfDay? startTime, TimeOfDay? endTime) {
    setState(() {
      workingHours.add(WorkingShift(day: day, startTime: startTime, endTime: endTime));
    });
  }
  void removeWorkingHours(int index) {
    setState(() {
      workingHours.removeAt(index);
    });
  }

  TimeOfDay parseTimeString(String timeString) {
    final parts = timeString.split(':');
    if (parts.length != 3) {
      throw FormatException("Invalid time format");
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    final second = int.tryParse(parts[2]);

    if (hour == null || minute == null || second == null) {
      throw FormatException("Invalid hour, minute, or second");
    }

    if (hour < 0 || hour >= 24 || minute < 0 || minute >= 60 || second < 0 || second >= 60) {
      throw FormatException("Invalid hour, minute, or second values");
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  String? formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay != null) {
      final now = DateTime.now();
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
      final formattedTime = DateFormat('HH:mm:ss').format(dateTime);
      return formattedTime;
    }
    return null;
  }

  void getDoctorData() async {

    String query = '';
    List<dynamic> params = [];
    List<Map<String, dynamic>> fetchedData = [];


    doctorName = doctorNameController.text;

    query = 'select * from doctors where doctor_name = ?';
    params = [doctorName];
    fetchedData = await getData(query, params);

    if(fetchedData.isEmpty){
      setState(() {
        isDoctorNameFound = false;
        doctorID = 0;
        doctorName = 'لا يوجد';
        doctorPhone = 'لا يوجد';
        doctorGender = 'لا يوجد';
        doctorBirthDate = 'لا يوجد';
        _selectedDoctorGender = null;

        totalPrescriptionsNumber = 0;
        doctorWorkingHours = [];
        workingHours.clear();
        selectedBirthDate = null;
      });
    }

    else {
      final row = fetchedData[0];
      setState(() {
        isDoctorNameFound = true;
        doctorID = int.parse(row['doctor_id']);
        doctorName = row['doctor_name'].toString();
        doctorPhone = row['doctor_phone'].toString();

        doctorBirthDate = row['doctor_birth_date'].toString();
        DateTime originalDate = DateTime.parse(doctorBirthDate);
        DateFormat newDateFormat = DateFormat('yyyy-MM-dd');
        doctorBirthDate = newDateFormat.format(originalDate);

        selectedBirthDate = DateTime.parse(doctorBirthDate);

        doctorGender = row['doctor_gender'];
        _selectedDoctorGender = doctorGender;
        totalPrescriptionsNumber = int.parse(row['prescriptions_numbers']);

      });

      query = 'select * from doctors_working_hours where doctor_id = ?';
      params = [doctorID];
      fetchedData = await getData(query, params);
      setState(() {
        doctorWorkingHours = fetchedData;
      });
      for(var row in doctorWorkingHours){
        addWorkingShift(row['day'], parseTimeString(row['start_time']), parseTimeString(row['end_time']));
      }
      print(workingHours);
    }
  }

  void updateDoctorData() async {


    String query = '';
    List<dynamic> params = [];

    print(doctorID);

    query = 'update doctors set doctor_birth_date = ?, doctor_gender = ? where doctor_id = ?';
    params = [selectedBirthDate.toString(), _selectedDoctorGender.toString(), doctorID];
    await executeQuery(query, params);

    query = 'delete from doctors_working_hours where doctor_id = ?';
    params = [doctorID];
    await executeQuery(query, params);

    for (WorkingShift shift in workingHours) {

      String? startTime = formatTimeOfDay(shift.startTime);
      String? endTime = formatTimeOfDay(shift.endTime);

      query = 'insert into doctors_working_hours (doctor_id, day, start_time, end_time) values (?, ?, ?, ?)';
      params = [doctorID, shift.day, startTime, endTime];
      await executeQuery(query, params);
    }

    setState(() {
      doctorNameController.clear();
      isDoctorNameFound = false;
      doctorID = 0;
      doctorName = 'لا يوجد';
      doctorPhone = 'لا يوجد';
      doctorGender = 'لا يوجد';
      doctorBirthDate = 'لا يوجد';
      selectedBirthDate = null;
      _selectedDoctorGender = null;

      totalPrescriptionsNumber = 0;
      doctorWorkingHours = [];
      workingHours.clear();
    });
  }



  Future<void> _selectedBirthDate(BuildContext context) async {
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
  Widget build(BuildContext context){

    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text("مركز عيون"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "تحديث بيانات طبيب",
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
                      width: 200,
                      height: 80,
                      child: Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          controller: doctorNameController,
                          decoration: InputDecoration(
                            labelText: "اسم الطبيب",
                            border: const OutlineInputBorder(),
                            errorText: isDoctorNameFound
                                ? null
                                : 'هذا الطبيب غير موجود', // Show error message if phone number is not found
                          ),
                          style: const TextStyle(fontSize: 15),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),

              ElevatedButton(
                onPressed: () {
                  getDoctorData(); // Call the function to handle button press
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
                      text: ' $doctorName', // Replace 'yourVariable' with the actual variable you want to display
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
                      text: 'عدد الكشوفات: ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' $totalPrescriptionsNumber', // Replace 'yourVariable' with the actual variable you want to display
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
                        _selectedBirthDate(context);
                      },
                      child: AbsorbPointer(
                        child: SizedBox(
                          width: 200,
                          height: 50,
                          child: Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: "تاريخ الميلاد",
                                border: OutlineInputBorder(),
                              ),
                              style: const TextStyle(fontSize: 15),
                              keyboardType: TextInputType.datetime,
                              controller: TextEditingController(
                                text: selectedBirthDate != null
                                    ? formatter.format(selectedBirthDate!)
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "النوع",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('انثى'),
                    Radio(
                      value: "انثى",
                      groupValue: _selectedDoctorGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedDoctorGender = value as String?;
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                    const Text('ذكر'),
                    Radio(
                      value: "ذكر",
                      groupValue: _selectedDoctorGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedDoctorGender = value as String?;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),


              for (int i = 0; i < workingHours.length; i++)
                WorkingHoursRow(
                  // Pass the list of days of the week and the selected day to the row
                  daysOfWeek: daysOfWeek,
                  selectedDay: workingHours[i].day,
                  startTime: workingHours[i].startTime,
                  endTime: workingHours[i].endTime,
                  onDayChanged: (newDay) {
                    // Update the selected day for the corresponding working hour
                    setState(() {
                      workingHours[i] = workingHours[i].copyWith(day: newDay);
                    });
                  },
                  onStartTimeChanged: (newStartTime, newEndTime) {
                    setState(() {
                      workingHours[i] = workingHours[i].copyWith(startTime: newStartTime, endTime: newEndTime);
                    });
                  },
                  onEndTimeChanged: (newStartTime, newEndTime) {
                    setState(() {
                      workingHours[i] = workingHours[i].copyWith(startTime: newStartTime, endTime: newEndTime);
                    });
                  },
                  onRemove: () {
                    removeWorkingHours(i);
                  },
                ),

              ElevatedButton(
                onPressed: () {
                  addWorkingShift('السبت', null, null); // You can provide default values for startTime and endTime
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(100, 25)),
                ),

                child: const Text("اضافة موعد عمل"),
              ),

              SizedBox(height: 50,),

              ElevatedButton(
                onPressed: (isDoctorNameFound) ? () {
                  updateDoctorData();
                  showMessage(context, "تم تحديث بيانات الطبيب بنجاح");
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
                  "تحديث البيانات",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class AddDoctorWindow extends StatefulWidget {
  const AddDoctorWindow({Key? key}) : super(key: key);

  @override
  _AddDoctorWindowState createState() => _AddDoctorWindowState();
}

class _AddDoctorWindowState extends State<AddDoctorWindow> {

  TextEditingController doctorName = TextEditingController();
  TextEditingController doctorPhone = TextEditingController();

  String? genderValue; // To store the selected gender
  DateTime? selectedDate; // To store the selected birth date

  String? selectedDay;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  List<String> daysOfWeek = ['السبت', 'الأحد', 'الأثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'];
  // List<Doctor> doctors = []; // List to store doctors

  List<WorkingShift> workingHours = [];



  String? formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay != null) {
      final now = DateTime.now();
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
      final formattedTime = DateFormat('HH:mm:ss').format(dateTime);
      return formattedTime;
    }
    return null;
  }

  Future<void> addDoctor() async{

    String name = doctorName.text;
    String phone = doctorPhone.text;
    String birth = selectedDate.toString();
    String gender = genderValue.toString();

    // final Results result = await connection.query('insert into doctors (doctor_name, doctor_phone, doctor_gender, doctor_birth_date, presc_numbers) '
    //     'values (?, ?, ?, ?, ?)', [name, phone, gender, birth, 0]);

    String query = 'insert into doctors (doctor_name, doctor_phone, doctor_gender, doctor_birth_date, prescriptions_numbers) values (?, ?, ?, ?, ?) ';
    List<dynamic> params = [name, phone, gender, birth, 0];
    executeQuery(query, params);

    query = 'select * from doctors order by doctor_id desc limit 1';
    params = [];
    List<Map<String, dynamic>> fetchedData = await getData(query, params);

    int? doctorId = int.parse(fetchedData[0]['doctor_id']);

    // print("Id: $doctorId");


    for (WorkingShift shift in workingHours) {

      String? startTime = formatTimeOfDay(shift.startTime);
      String? endTime = formatTimeOfDay(shift.endTime);

      query = 'insert into doctors_working_hours (doctor_id, day, start_time, end_time) values (?, ?, ?, ?)';
      params = [doctorId, shift.day, startTime, endTime];

      await executeQuery(query, params);
    }

    setState(() {});

    doctorName.clear();
    doctorPhone.clear();
    selectedDate = null;
    genderValue = null;
    for (int i = 0; i < workingHours.length; i++) {
      removeWorkingHours(i);
    }

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


  void addWorkingShift(String day, TimeOfDay? startTime, TimeOfDay? endTime) {
    setState(() {
      workingHours.add(WorkingShift(day: day, startTime: startTime, endTime: endTime));
    });
  }

  void removeWorkingHours(int index) {
    setState(() {
      workingHours.removeAt(index);
    });
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
                "اضافة طبيب جديد",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Flexible(
                      child: SizedBox(
                        width: 300,
                        height: 90, // Set the desired width here
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          controller: doctorName,
                          decoration: const InputDecoration(
                            labelText: "اسم الطبيب",
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(fontSize: 15),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Directionality(textDirection: ui.TextDirection.rtl,
                    child: Flexible(
                      child: SizedBox(
                        width: 300,
                        height: 90, // Set the desired width here
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          controller: doctorPhone,
                          decoration: const InputDecoration(
                            labelText: "رقم الطبيب",
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 15),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // SizedBox(height: 20),
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
                  )
                ],
              ),
              // SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Text('انثى'),
                    Radio(
                      value: "انثى",
                      groupValue: genderValue,
                      onChanged: (value) {
                        setState(() {
                          genderValue = value as String?;
                        });
                      },
                    ),

                    const SizedBox(width: 10),

                    const Text('ذكر'),
                    Radio(
                      value: "ذكر",
                      groupValue: genderValue,
                      onChanged: (value) {
                        setState(() {
                          genderValue = value as String?;
                        });
                      },
                    ),

                    const SizedBox(width: 20),

                    const Text(
                      "النوع",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20,),


              // Display working hours rows
              for (int i = 0; i < workingHours.length; i++)
                WorkingHoursRow(
                  // Pass the list of days of the week and the selected day to the row
                  daysOfWeek: daysOfWeek,
                  selectedDay: workingHours[i].day,
                  startTime: workingHours[i].startTime,
                  endTime: workingHours[i].endTime,
                  onDayChanged: (newDay) {
                    // Update the selected day for the corresponding working hour
                    setState(() {
                      workingHours[i] = workingHours[i].copyWith(day: newDay);
                    });
                  },
                  onStartTimeChanged: (newStartTime, newEndTime) {
                    setState(() {
                      workingHours[i] = workingHours[i].copyWith(startTime: newStartTime, endTime: newEndTime);
                    });
                  },
                  onEndTimeChanged: (newStartTime, newEndTime) {
                    setState(() {
                      workingHours[i] = workingHours[i].copyWith(startTime: newStartTime, endTime: newEndTime);
                    });
                  },
                  onRemove: () {
                    removeWorkingHours(i);
                  },
                ),

              ElevatedButton(
                onPressed: () {
                  addWorkingShift('السبت', null, null); // You can provide default values for startTime and endTime
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(150, 25)),
                ),
                child: const Text("اضافة موعد عمل"),
              ),

              SizedBox(height: 20,),
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
                  addDoctor();
                  showMessage(context, "تمت اضافة الطبيب بنجاح");
                },
                child: const Text(
                  "اضافة طبيب",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}