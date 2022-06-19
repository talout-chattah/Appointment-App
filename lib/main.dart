import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfc/Screens/Auth/auth_container.dart';
import 'package:pfc/Screens/Home/add_appointment_screen.dart';
import 'package:pfc/Screens/Home/home_screen.dart';
import 'package:pfc/theme.dart';
import 'Screens/Auth/signin.dart';
import 'Screens/Auth/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PFC Project',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeMode.system,
      routes: {
        "SignIn": (context) => const SignIn(),
        "SignUp": (context) => const SignUp(),
        "Home": (context) => const HomeScreen(),
        "AddAppointment": (context) => const AddAppointmentScreen(),
      },
      home: const AuthContainer(),
    );
  }
}
