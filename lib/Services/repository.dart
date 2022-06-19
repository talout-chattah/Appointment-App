import 'package:pfc/Models/Appointment.dart';

abstract class Repository {
  Future<List<Appointment>> getAppointmentList();
  Future<String> patchCompleted(Appointment appointment);
  Future<String> putCompleted(Appointment appointment);
  Future<String> deletedAppointment(Appointment appointment);
  Future<String> postAppointment(Appointment appointment);
}
