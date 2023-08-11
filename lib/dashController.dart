import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashController extends GetxController {
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await getUserCars();
  }

  RxString carNumberPlate = ''.obs;
  RxString carOwnerId = ''.obs;

  RxString carNumberPlateError = ''.obs;
  RxString carOwnerIdError = ''.obs;

  final supabase = Supabase.instance.client;

  validatecarNumber(String value) {
    carNumberPlate.value = '';
    carNumberPlateError.value = '';
    if (value.isEmpty) {
      carNumberPlateError.value = 'Your number plate is required.';
    } else {
      if (value.length < 2) {
        carNumberPlateError.value = 'The number plate is too short.';
      } else {
        carNumberPlate.value = value;
        carNumberPlateError.value = '';
      }
    }
  }

  validateOnerId(String value) {
    carOwnerId.value = '';
    carOwnerIdError.value = '';
    if (value.isEmpty) {
      carOwnerIdError.value = 'Your ID is required.';
    } else {
      if (value.length < 3) {
        carOwnerIdError.value = 'The ID number is too short.';
      } else {
        carOwnerId.value = value;
      }
    }
  }

  bool validateNewCarReg() {
    if (carOwnerId.value.length > 2 && carNumberPlate.value.length >= 3) {
      return true;
    } else {
      return false;
    }
  }

  registerNewCar() async {
    final User? user = supabase.auth.currentUser;
    try {
      List cars = [];

      final data = await supabase.from('cars').select('userCars').match({
        'userId': user!.id,
      });

      if (data[0]['userCars'] != null) {
        cars = jsonDecode(data[0]['userCars']);
      }
      cars.add({
        'carPlate': carNumberPlate.value,
        'carOwnerId': carOwnerId.value
      });

      var carsencoded = jsonEncode(cars);

      await supabase.from('cars').update({
        'userCars': carsencoded,
      }).match({
        'userId': user.id,
      });
      carNumberPlate.value = '';
      carOwnerId.value = '';
      Get.back();
      Get.snackbar(
        'Success',
        'Your car has been registered.',
        backgroundColor: Colors.greenAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Your car could not be registered.',
        backgroundColor: Colors.greenAccent,
        colorText: Colors.white,
      );
    }
  }

  //Get cars

  RxList myCars = [].obs;

  getUserCars() async {
    final User? user = supabase.auth.currentUser;

    final data = await supabase.from('cars').select('userCars').match({
      'userId': user!.id,
    });
    var cars = jsonDecode(data[0]['userCars']);
    myCars.value = cars;
  }

  //Register route
  RxString from = "".obs;
  RxString to = "".obs;
  RxString car = "".obs;

  createTicket() async {
    if (from.isEmpty && to.isEmpty && car.isEmpty) {
      Get.snackbar(
        'Error',
        'Some of the fields are not complete.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      if (from.value == to.value) {
        Get.snackbar(
          'Error',
          'The destinations cannot be the same.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        int fare = getPayment(from.value, to.value);
        if (fare == -1) {
          Get.snackbar(
            'Error',
            'The route is not currently supported.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          Get.dialog(Center(
            child: IntrinsicHeight(
              child: Card(
                child: Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
                  width: 300,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pay Your Toll Fees',
                        style: GoogleFonts.roboto(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Your will recieve your receipt with a QR code.',
                        style: GoogleFonts.roboto(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'From: ${from.value} To:${to.value}',
                        style: GoogleFonts.roboto(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Car: ${car.value}',
                        style: GoogleFonts.roboto(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Fare: $fare',
                        style: GoogleFonts.roboto(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      customElevatedButtonGreen(() {}, 'Lipa na Mpesa')
                    ],
                  ),
                ),
              ),
            ),
          ));
        }
      }
    }
  }

  Widget customElevatedButtonGreen(
    onPressed,
    String buttonString,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(HexColor('00BFA6')),
        elevation: MaterialStateProperty.all<double>(10),
        padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      child: Text(
        buttonString,
        style: GoogleFonts.roboto(
          fontSize: 13.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

//routes fares
  Map<String, Map<String, int>> fareChart = {
    "Mlolongo": {
      "SGR": 180,
      "Eastern Bypass": 180,
      "Southern Bypass": 240,
      "Capital Center": 300,
      "Museum Hill": 360,
      "Nairobi Westlands": 360,
    },
    "Syokimau": {
      "SGR": 120,
      "Eastern Bypass": 180,
      "Souther Bypass": 240,
      "Capital Center": 240,
      "Museum Hill": 300,
      "Nairobi Westlands": 360,
    },
    "SGR": {
      "Eastern Bypass": 120,
      "Southern Bypass": 180,
      "Capital Center": 240,
      "Museum Hill": 300,
      "Nairobi Westlands": 300,
    },
    "JKIA": {
      "Eastern Bypass": 120,
      "Southern Bypass": 180,
      "Capital Center": 180,
      "Museum Hill": 240,
      "Nairobi Westlands": 300,
    },
    "Eastern Bypass": {
      "Mlolongo": 180,
      "Syokimau": 180,
      "JKIA": 120,
      "Southern Bypass": 120,
      "Capital Center": 180,
      "Museum Hill": 240,
      "Nairobi Westlands": 300,
    },
    "Southern Bypass": {
      "Mlolongo": 240,
      "Syokimau": 240,
      "JKIA": 180,
      "Eastern Bypass": 120,
      "Capital Center": 120,
      "Museum Hill": 180,
      "Nairobi Westlands": 240,
    },
    "Capital Center": {
      "Mlolongo": 300,
      "Syokimau": 240,
      "JKIA": 180,
      "Eastern Bypass": 180,
      "Southern Bypass": 120,
      "Museum Hill": 120,
      "Nairobi Westlands": 180,
      "Haile Selassie": 180,
    },
    "Haile Selassie": {
      "Mlolongo": 300,
      "Syokimau": 300,
      "JKIA": 240,
      "Eastern Bypass": 180,
      "Southern Bypass": 120,
      "Capital Center": 120,
      "Museum Hill": 120,
      "Nairobi Westlands": 180,
    },
    "Museum Hill": {
      "Mlolongo": 360,
      "Syokimau": 300,
      "JKIA": 240,
      "Eastern Bypass": 240,
      "Southern Bypass": 180,
      "Capital Center": 120,
      "Haile Selassie": 120,
    },
    "The Mall": {
      "Mlolongo": 360,
      "Syokimau": 360,
      "JKIA": 300,
      "Eastern Bypass": 240,
      "Southern Bypass": 180,
      "Capital Center": 180,
      "Haile Selassie": 120,
      "Museum Hill": 120,
    },
    "Nairobi Westlands": {
      "Mlolongo": 360,
      "Syokimau": 360,
      "JKIA": 300,
      "Eastern Bypass": 300,
      "Southern Bypass": 240,
      "Capital Center": 180,
      "Haile Selassie": 180,
      "Museum Hill": 120,
    },
  };

  int getPayment(String fromLocation, String toLocation) {
    if (fareChart.containsKey(fromLocation) && fareChart[fromLocation]!.containsKey(toLocation)) {
      return fareChart[fromLocation]![toLocation]!;
    } else {
      return -1; // Indicate an error
    }
  }
}
