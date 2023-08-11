import 'package:expressway/textInput_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controller/auth_controller.dart';
import 'dashController_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ztvqvfhnwegmlmgyumsh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp0dnF2Zmhud2VnbWxtZ3l1bXNoIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTE0MjY2MDgsImV4cCI6MjAwNzAwMjYwOH0.OYcSpCrnbIjv8ckn0ik9iBMr6381eYm-K2WywEs391c',
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'mySkool',
      home: CheckLogged(),
    );
  }
}

class CheckLogged extends StatefulWidget {
  CheckLogged({super.key});

  @override
  State<CheckLogged> createState() => _CheckLoggedState();
}

class _CheckLoggedState extends State<CheckLogged> {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.userLogged.value) {
        return DashControllerView();
      } else {
        return SignUp();
      }
    });
  }
}

class LogIn extends StatelessWidget {
  LogIn({super.key});
  final TextInputWidget textInputWidget = Get.put(TextInputWidget());
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  color: Colors.transparent,
                  // height: 100,
                  // width: 100,
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.cover,
                  )),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Login',
                style: GoogleFonts.roboto(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 400,
                child: textInputWidget.basicInput('Email', 'email@mail.com', 'userLoginemail', Icons.person_3_outlined),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 400,
                child: textInputWidget.basicInput('Password', 'password', 'userPass', Icons.password_outlined),
              ),
              const SizedBox(
                height: 20,
              ),
              textInputWidget.customElevatedButtonGreen(() async {
                authController.validateLogInForm();
                authController.validLogInForm.value == false
                    ? Get.snackbar(
                        'Error',
                        'Your form is not valid',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      )
                    : authController.loginUser();
              }, 'Login'),
              const SizedBox(
                height: 20,
              ),
              textInputWidget.sentenceWithLinkText('I don\'t have an account', 'Sign up', () {
                Get.to(SignUp());
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final TextInputWidget textInputWidget = Get.put(TextInputWidget());
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.transparent,
                // height: 100,
                // width: 100,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Signup',
                style: GoogleFonts.roboto(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 400,
                child: textInputWidget.basicInput('Firstname', 'Joe', 'firstNameReg', Icons.person_3_outlined),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 400,
                child: textInputWidget.basicInput('Secondname', 'Joe', 'secondNameReg', Icons.person_3_outlined),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 400,
                child: textInputWidget.basicInput('Email', 'you@mail.com', 'userRegMail', Icons.person_3_outlined),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 400,
                child: textInputWidget.basicInput('ID', '23***', 'newId', Icons.badge),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 400,
                child: textInputWidget.basicInput('Password', 'password', 'newPass', Icons.password_outlined),
              ),
              const SizedBox(
                height: 20,
              ),
              textInputWidget.customElevatedButtonGreen(() async {
                authController.validateSignUpForm();
                authController.validForm.value == false
                    ? Get.snackbar(
                        'Error',
                        'Your form is not valid',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      )
                    : await authController.createNewUserSupabase();
              }, 'Register'),
              const SizedBox(
                height: 20,
              ),
              textInputWidget.sentenceWithLinkText('I have an account', 'Login', () {
                Get.to(LogIn());
              }),
            ],
          ),
        ),
      ),
    );
  }
}
