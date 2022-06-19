import 'package:flutter/material.dart';
import 'package:pfc/Screens/Auth/signin.dart';
import 'package:pfc/Screens/Home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthContainer extends StatefulWidget {
  const AuthContainer({Key? key}) : super(key: key);

  @override
  State<AuthContainer> createState() => _AuthContainerState();
}

class _AuthContainerState extends State<AuthContainer> {
  String? token;
  bool initial = true;

  @override
  Widget build(BuildContext context) {
    if (initial) {
      SharedPreferences.getInstance().then((sharedPrefValue) {
        setState(() {
          initial = false;
          token = sharedPrefValue.getString("token");
          print(token); //TODO: don't miss to delete it
        });
      });
      return const CircularProgressIndicator();
    } else {
      if (token == null) {
        return const SignIn();
      } else {
        return const HomeScreen();
      }
    }
  }
}
