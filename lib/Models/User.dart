class User {
  int? id;
  String? userName;
  String? firstName;
  String? lastName;
  String? email;
  String? password;

  User({
    this.id,
    this.userName,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    //data['id'] = this.id;
    data['username'] = this.userName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;

    return data;
  }
}