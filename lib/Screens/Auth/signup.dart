import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pfc/Models/User.dart';
import 'package:pfc/Screens/Home/home_screen.dart';
import '../../constants.dart';
import 'background_painter.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var userNameController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
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
        onTap: (){
          _controller.forward(from: 0);
        },
        onLongPress: (){
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
                      flex: 2,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Create Your\n Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: TextFormField(
                              controller: userNameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                hintText: 'AmirBfk',
                                suffixIcon: Icon(CupertinoIcons.person),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: TextFormField(
                              controller: firstNameController,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                                hintText: 'Talout',
                                suffixIcon: Icon(CupertinoIcons.person),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: TextFormField(
                              controller: lastNameController,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                                hintText: 'Chattah',
                                suffixIcon: Icon(CupertinoIcons.person),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'example@example.com',
                                suffixIcon: Icon(
                                  CupertinoIcons.envelope_fill,
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
                                  Navigator.of(context).pushNamed('SignIn');
                                },
                                child: const Text(
                                  'Sign In',
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
                                height: 60,
                                width: 60,
                                color: darkBlue,
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      signup();
                                    },
                                    icon: Icon(Icons.login, size: 35,color: orange,),
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
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signup() async {

    if (userNameController.text.isNotEmpty &&
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      var response = await http.post(
        Uri.parse("http://"+IP+"/api/auth/registration"),
        body: User(
                userName: userNameController.text,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                email: emailController.text,
                password: passwordController.text)
            .toJson(),
      );

      if (response.statusCode == 201) {
        Get.offAll(() => const HomeScreen());

      } else {
        Map<String, dynamic> body = json.decode(response.body);
        Get.snackbar(
          'Attention',
          '${body['username']!= null?body['username'].toString().replaceAll('[', '').replaceAll(']', ''): ""}\n ${body['password']!= null? body['password'].toString().replaceAll('[', '').replaceAll(']', ''):""}\n ${body['email']!= null?body['email'].toString().replaceAll('[', '').replaceAll(']', ''):""}',
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.warning_amber_rounded),
        );
      }
    } else {
      Get.snackbar(
        'Required',
        'Empty Field Not Allowed',
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.warning_amber_rounded),
      );
    }
  }
}
