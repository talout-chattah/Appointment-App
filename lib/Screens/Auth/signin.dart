import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../Home/home_screen.dart';
import 'background_painter.dart';

class SignIn extends StatefulWidget {
  const SignIn({
    Key? key,
  }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  ValueNotifier<bool> showSignInPage = ValueNotifier<bool>(true);

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _controller.forward(from: 0);
        },
        onLongPress: () {
          _controller.animateBack(0);
        },
        child: Stack(
          children: [
            SizedBox.expand(
              child: CustomPaint(
                painter: BackgroundPainter(
                  animation: _controller.view,
                ),
              ),
            ),
            Form(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hello,\nSign in!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: TextFormField(
                              controller: userNameController,
                              decoration: const InputDecoration(
                                labelText: 'UserName',
                                hintText: 'AmirBfk',
                                suffixIcon: Icon(
                                  CupertinoIcons.person,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                suffixIcon: Icon(
                                  CupertinoIcons.lock_fill,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              splashColor: Colors.white,
                              onTap: () {},
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('SignUp');
                                },
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    color: orange,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ClipOval(
                              child: Container(
                                width: 60,
                                height: 60,
                                color: darkBlue,
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      signin();
                                    },
                                    icon: const Icon(
                                      Icons.login,
                                      size: 35,
                                      color: orange,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> signin() async {
    if (userNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      var response = await http.post(
          Uri.parse("http://" + IP + "/api/auth/login"),
          body: ({
            'username': userNameController.text,
            'password': passwordController.text
          }));

      if (response.statusCode == 200) {
        Get.offAll(() => const HomeScreen());
        Map<String, dynamic> body = json.decode(response.body);
        print(body["token"]); // TODO: it's just for testing don't miss to delete it after finishing
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", body["token"]);
      } else {
        print(response.body);
        Get.snackbar(
          'Attention',
          'Invalid credentials',
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.warning_amber_rounded),
        );
      }
    } else {
      Get.snackbar(
        'Required',
        'Empty field not allowed',
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.warning_amber_rounded),
      );
    }
  }
}
