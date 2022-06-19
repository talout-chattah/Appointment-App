import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pfc/Controllers/Appointment_controller.dart';
import 'package:pfc/Models/Appointment.dart';
import 'package:pfc/Screens/Home/add_appointment_screen.dart';
import 'package:pfc/Screens/profile_screen.dart';
import 'package:pfc/Services/appointment_repository.dart';
import 'package:pfc/Services/notification_services.dart';
import 'package:pfc/Widgets/appointment_tile.dart';
import 'package:pfc/constants.dart';
import 'package:pfc/theme.dart';
import '../../widgets/button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _appointmentController =
      Get.put(AppointmentController(AppointmentRepository()));
  var notifyHelper;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _appointmentController.fetchAppointmentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            _addAppointmentBar(),
            const SizedBox(height: 10),
            _dateBar(),
            const SizedBox(height: 10),
            _showAppointments()
          ],
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      /*leading: GestureDetector(
        onTap: () {
          //TODO permanently notification
          notifyHelper.displayNotification(
            title: "Talout|Chattah",
            body: "Welcome Talout",
          );

          //TODO scheduled notification works but need somme modifications cause it does not slide down in the screen
          //notifyHelper.scheduleNotification();
        },
        child: const Icon(
          Icons.import_contacts_sharp,
        ),
      ),*/
      actions: [
        GestureDetector(
          onTap: () {
            Get.to(const ProfileScreen());
          },
          child: const CircleAvatar(
            backgroundImage: AssetImage(
              'images/profile.png',
            ),
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }

  _addAppointmentBar() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  'Today',
                  style: headingStyle,
                ),
              ],
            ),
          ),
          MyButton(
            label: '+ Add Appointment',
            onTap: () async {
              await Get.to(() => const AddAppointmentScreen());
            },
            height: 50,
            width: 150,
          ),
        ],
      ),
    );
  }

  _dateBar() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        child: DatePicker(
          DateTime.now(),
          height: 100,
          width: 80,
          initialSelectedDate: DateTime.now(),
          selectionColor: lightBlue,
          selectedTextColor: Colors.white,
          monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          onDateChange: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        ),
      ),
    );
  }

  _showAppointments() {
    return Expanded(
      child: FutureBuilder<List<Appointment>>(
        future: _appointmentController.fetchAppointmentList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data!.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.assignment_outlined,
                  size: 100,
                  color: lightBlue,
                ),
                Text(
                  'There is no appointment at this day\n         you can add appointment',
                  style: TextStyle(color: lightBlue),
                )
              ],
            ));
          }
          return Obx(() {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  var appointment = snapshot.data?[index];
                  if (appointment?.date ==
                      DateFormat('yyyy-MM-dd').format(_selectedDate)) {
                    //TODO notification here
                      var hours = appointment?.startTime?.split(':')[0];
                       var minutes = appointment?.startTime?.split(':')[1];
                    notifyHelper.scheduleNotification(
                        int.parse(hours!),
                        int.parse(minutes!),
                        appointment);
                      print(appointment?.startTime);
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print('element of the list');
                                  _showBottomSheet(context, appointment!);
                                },
                                child: AppointmentTile(appointment),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                });
          });
        },
      ),
    );
  }

  _showBottomSheet(BuildContext context, Appointment appointment) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: appointment.isCompleted == true
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          const Spacer(),
          appointment.isCompleted == true
              ? Container()
              : _bottomSheetButton(
                  label: "Appointment Completed",
                  onTap: () {
                    setState(() {
                      _appointmentController
                          .markAppointmentCompleted(appointment);
                      Get.back();
                    });
                  },
                  color: lightBlue,
                  context: context,
                ),
          _bottomSheetButton(
            label: "Delete Appointment",
            onTap: () {
              setState(() {
                _appointmentController.deleteAppointment(appointment);
                Get.back();
              });
            },
            color: Colors.red[300]!,
            isClose: true,
            context: context,
          ),
          const SizedBox(
            height: 20,
          ),
          _bottomSheetButton(
            label: "Close",
            onTap: () {
              Get.back();
            },
            color: Colors.red[300]!,
            context: context,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ));
  }

  _bottomSheetButton(
      {required String label,
      required Function()? onTap,
      required Color color,
      required BuildContext context,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.white
                    : Colors.black
                : color,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : color,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
