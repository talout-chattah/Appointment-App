class Appointment {
  int? id;
  String? title;
  String? details;
  bool? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? importance; // color

  //ToDo the list of all the presence in the appointment
  Appointment({
    this.id,
    this.title,
    this.details,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.importance
    //ToDo the list of all the presence in the appointment
  });

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    details = json['description'];
    isCompleted = json['is_completed'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    importance =json['importance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['id'] = this.id.toString();
    data['title'] = this.title.toString();
    data['description'] = this.details.toString();
    data['is_completed'] = this.isCompleted.toString();
    data['date'] = this.date.toString();
    data['start_time'] = this.startTime.toString();
    data['end_time'] = this.endTime.toString();
    data['importance'] = this.importance.toString();

    return data;
  }
}
