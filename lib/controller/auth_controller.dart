import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../dashController_view.dart';

class AuthController extends GetxController {
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await checkLogged();
  }

  final supabase = Supabase.instance.client;

  RxString firstName = ''.obs;
  RxString secondName = ''.obs;
  RxString emailV = ''.obs;
  RxString id = ''.obs;
  RxString password = ''.obs;

  RxString firstNameerror = ''.obs;
  RxString secondNameerror = ''.obs;
  RxString emailerror = ''.obs;
  RxString iderror = ''.obs;
  RxString passworderror = ''.obs;

  RxBool validForm = false.obs;

  //Login
  RxString username = ''.obs;
  RxString userPassword = ''.obs;

  RxString usernameError = ''.obs;
  RxString userPasswordError = ''.obs;

  RxBool validLogInForm = false.obs;

  RxBool userLogged = false.obs;

//Login

  validateLogUsername(String value) {
    username.value = '';

    usernameError.value = '';
    if (value.isEmpty) {
      usernameError.value = 'Your username is required';
    } else {
      username.value = value;

      usernameError.value = '';
    }
  }

  validateLogpassword(String value) {
    userPassword.value = '';
    userPasswordError.value = '';

    if (value.isEmpty) {
      userPasswordError.value = 'Your username is required';
    } else {
      userPassword.value = value;

      userPasswordError.value = '';
    }
  }

  //Signup

  validateFirstname(String name) {
    firstName.value = '';
    firstNameerror.value = '';

    if (name.isEmpty) {
      firstNameerror.value = 'Your name is required.';
    } else {
      if (name.length < 2) {
        firstNameerror.value = 'Your name is too short.';
      } else {
        firstName.value = name;
        firstNameerror.value = '';
      }
    }
  }

  validateSecondname(String name) {
    secondName.value = '';
    secondNameerror.value = '';

    if (name.isEmpty) {
      secondNameerror.value = 'Your name is required.';
    } else {
      if (name.length < 2) {
        secondNameerror.value = 'Your name is too short.';
      } else {
        secondName.value = name;
        secondNameerror.value = '';
      }
    }
  }

  validateEmail(String email) {
    emailV.value = '';
    emailerror.value = '';
    if (email.isEmail) {
      emailV.value = email;
      emailerror.value = '';
    } else {
      emailerror.value = 'Not a valid email';
    }
  }

  validateid(String value) {
    id.value = '';
    iderror.value = '';
    if (value.isEmpty) {
      iderror.value = 'Your ID is required.';
    } else {
      if (value.length < 4) {
        iderror.value = 'Your ID is too short.';
      } else {
        id.value = value;
        iderror.value = '';
      }
    }
  }

  validatepassword(String value) {
    password.value = '';
    passworderror.value = '';
    if (value.isEmpty) {
      passworderror.value = 'Your password is required.';
    } else {
      if (value.length < 6) {
        passworderror.value = 'Your password should be atleast 6 characters.';
      } else {
        password.value = value;
        passworderror.value = '';
      }
    }
  }

  validateSignUpForm() {
    if (firstName.value.length > 2 && secondName.value.length > 2 && emailV.value.length > 2 && id.value.length > 2 && password.value.length > 2) {
      validForm.value = true;
    } else {
      validForm.value = false;
    }
  }

  validateLogInForm() {
    if (username.value.length > 2 && userPassword.value.length > 2) {
      validLogInForm.value = true;
    } else {
      validLogInForm.value = false;
    }
  }

  checkLogged() {
    final User? user = supabase.auth.currentUser;

    if (user == null) {
      userLogged.value = false;
    } else {
      userLogged.value = true;
    }
  }

  createNewUserSupabase() async {
    try {
      final supabase = Supabase.instance.client;
      final AuthResponse res = await supabase.auth.signUp(
        email: emailV.value,
        password: password.value,
        data: {
          'username': firstName.value
        },
      );
      final User? user = res.user;

      if (res.user != null) {
        //Create user

        await supabase.from('users').insert({
          'user': user!.id,
          'email': emailV.value,
          'userId': id.value,
          'firstName': firstName.value,
          'secondName': secondName.value,
        });
        await supabase.from('cars').insert({
          'userId': user.id,
          'userCars': null,
        });

        await supabase.auth.signInWithPassword(
          email: emailV.value,
          password: password.value,
        );
      }

      Get.to(DashControllerView());
      Get.snackbar(
        'Success',
        'Your account has been created.',
        backgroundColor: Colors.greenAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'We could not create your account at the moment. \n $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  loginUser() async {
    try {
      final supabase = Supabase.instance.client;
      await supabase.auth.signInWithPassword(
        email: username.value,
        password: userPassword.value,
      );
      Get.to(DashControllerView());
      Get.snackbar(
        'Success',
        'Welcome.',
        backgroundColor: Colors.greenAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'We could not log you in at the moment. \n $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  logOutUser() async {
    await supabase.auth.signOut();
  }
}
