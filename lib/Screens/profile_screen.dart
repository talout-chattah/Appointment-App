import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfc/Screens/Auth/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: lightBlue,
          ),
        ),
      ),
      backgroundColor: context.theme.backgroundColor,
      body: Center(
        child: Column(
          children: const [
            Padding(
              padding: EdgeInsets.all(20),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(
                  'images/profile.png',
                ),
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton.icon(
            onPressed: () async {
              Get.offAll(const SignIn());
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.clear();
            },
            label: const Text("Logout"),
            icon: const Icon(Icons.logout),
            color: context.theme.backgroundColor,
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
