import 'package:get/get.dart';
import 'package:pfc/Models/Appointment.dart';
import '../Services/repository.dart';

class AppointmentController extends GetxController {
  final Repository _repository;

  AppointmentController(this._repository);

  @override
  void onReady() {
    super.onReady();
  }

  Future<String> addAppointment(Appointment appointment) async {
    return _repository.postAppointment(appointment);
  }

  // GET Appointments
  Future<List<Appointment>> fetchAppointmentList() async {
    return _repository.getAppointmentList();
  }

  // PATCH Appointment to change the completed status
  Future<String> markAppointmentCompleted(Appointment appointment) async {
    return _repository.patchCompleted(appointment);
  }

  // DELETE Appointment
  Future<String> deleteAppointment(Appointment appointment) async {
    return _repository.deletedAppointment(appointment);
  }
}
