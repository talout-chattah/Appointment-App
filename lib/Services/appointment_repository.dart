import 'dart:convert';
import 'package:get/get.dart';
import 'package:pfc/Models/Appointment.dart';
import 'package:pfc/Services/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class AppointmentRepository implements Repository {
  String apiURL = "http://" + IP + "/api";

  @override
  Future<String> deletedAppointment(Appointment appointment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var url = Uri.parse('$apiURL/detail/${appointment.id}');
    var result = 'false';
    await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
    }).then((response) {
      print(response.body);
      return result = 'true';
    });
    return result;
  }

  @override
  Future<List<Appointment>> getAppointmentList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    print('stoken from appointment repository: ${token}');
    List<Appointment> appointmentList = <Appointment>[].obs;
    var url = Uri.parse('$apiURL/appointment');
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print('status code: ${response.statusCode}');
    print('response body: ${response.body}');
    var body = json.decode(response.body);
    for (var i = 0; i < body.length; i++) {
      appointmentList.add(Appointment.fromJson(body[i]));
    }
    return appointmentList;
  }

  @override
  Future<String> patchCompleted(Appointment appointment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var url = Uri.parse('$apiURL/detail/${appointment.id}');
    String resData = '';

    await http.patch(url, body: {
      'is_completed': (!appointment.isCompleted!).toString()
    }, headers: {
      'Authorization': 'Bearer $token',
    }).then((response) {
      Map<String, dynamic> result = json.decode(response.body);
      print(result);
      return resData = result['true'];
    });

    return resData;
  }

  @override
  Future<String> postAppointment(Appointment appointment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    print(appointment.toJson());
    var url = Uri.parse('$apiURL/appointment');
    var result = '';
    var response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: appointment.toJson());
    print(response.statusCode);
    print(response.body);
    return 'true';
  }

  @override
  Future<String> putCompleted(Appointment appointment) {
    // TODO: implement putCompleted
    throw UnimplementedError();
  }
}
