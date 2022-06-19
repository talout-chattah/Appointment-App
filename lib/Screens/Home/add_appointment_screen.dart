import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pfc/Controllers/Appointment_controller.dart';
import 'package:pfc/Models/Appointment.dart';
import 'package:pfc/Screens/Home/home_screen.dart';
import 'package:pfc/Services/appointment_repository.dart';
import 'package:pfc/constants.dart';
import 'package:pfc/theme.dart';
import 'package:pfc/widgets/button.dart';
import 'package:pfc/widgets/input_field.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final AppointmentController _appointmentController =
      Get.put(AppointmentController(AppointmentRepository()));
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  //TODO with who Controller
  DateTime _selectedDate = DateTime.now();
  String _endTime = DateFormat('hh:mm:ss').format(DateTime.now()).toString();
  String _startTime = DateFormat('hh:mm:ss').format(DateTime.now()).toString();
  int _selectedImportance = 0;
  String? token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Appointment",
                style: headingStyle,
              ),
              MyInputField(
                title: 'Title',
                hint: 'Enter the Appointment title here',
                controller: _titleController,
              ),
              MyInputField(
                title: 'Details',
                hint: 'Write the details of the Appointment',
                controller: _detailsController,
              ),
              /* const MyInputField(
                title: 'With who!',
                hint: '@Talout',
                //TODO need Controller
              ),*/
              MyInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                    title: 'Start Time',
                    hint: _startTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: true);
                      },
                      icon: const Icon(
                        Icons.access_time_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: MyInputField(
                    title: 'End Time',
                    hint: _endTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: false);
                      },
                      icon: const Icon(
                        Icons.access_time_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  )),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              _importanceSection(),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyButton(
                      label: 'Create Appointment',
                      onTap: () {
                        _validateData();
                      },
                      height: 60,
                      width: 160),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.arrow_back_ios,
          size: 30,
          color: lightBlue,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage(
            'images/profile.png',
          ),
          backgroundColor: Colors.white,
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2222),
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var df = DateFormat("h:mm a");
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    var dt = df.parse(_formatedTime);
    if (pickedTime == null) {
      print('time canceled');
    } else if (isStartTime == true) {
      setState(() {
        _startTime = DateFormat("HH:mm:ss").format(dt);
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = DateFormat("HH:mm:ss").format(dt);
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }

  _importanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Importance",
          style: titleStyle,
        ),
        const SizedBox(height: 8),
        Wrap(
          children: List<Widget>.generate(
            3,
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImportance = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? darkBlue
                        : index == 1
                            ? lightBlue
                            : orange,
                    child: _selectedImportance == index
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          )
                        : Container(), //TODO in this section I will send the importance of the appointment to the AI model
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty &&
        _detailsController.text.isNotEmpty) {
      _appointmentController.addAppointment(Appointment(
        title: _titleController.text,
        details: _detailsController.text,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        importance: _selectedImportance,
        isCompleted: false,
      ));
      Get.off(HomeScreen());
    } else if (_titleController.text.isEmpty ||
        _detailsController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'Title and Details fields are required',
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.warning_amber_rounded),
      );
    }
  }
}
