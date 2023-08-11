import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'controller/auth_controller.dart';
import 'dashController.dart';

class TextInputWidget extends GetxController {
  final AuthController authController = Get.put(AuthController());
  final DashController dashController = Get.put(DashController());
  Widget basicInput(
    String lable,
    String hint,
    String inputID,
    IconData icon,
  ) {
    return Obx(() {
      return TextField(
        style: GoogleFonts.roboto(
          fontSize: 13.0,
          fontWeight: FontWeight.w400,
        ),
        obscureText: inputID == '' || inputID == '' || inputID == '' ? true : false,
        obscuringCharacter: '*',
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: HexColor('#071D34'),
            ),
          ),
          errorText: inputID == 'firstNameReg'
              ? authController.firstNameerror.value.length > 2
                  ? authController.firstNameerror.value
                  : null
              : inputID == 'secondNameReg'
                  ? authController.secondNameerror.value.length > 2
                      ? authController.secondNameerror.value
                      : null
                  : inputID == 'userRegMail'
                      ? authController.emailerror.value.length > 2
                          ? authController.emailerror.value
                          : null
                      : inputID == 'newId'
                          ? authController.iderror.value.length > 2
                              ? authController.iderror.value
                              : null
                          : inputID == 'newPass'
                              ? authController.passworderror.value.length > 2
                                  ? authController.passworderror.value
                                  : null
                              : inputID == 'userLoginemail'
                                  ? authController.userPasswordError.value.length > 2
                                      ? authController.userPasswordError.value
                                      : null
                                  : inputID == 'userPass'
                                      ? authController.userPasswordError.value.length > 2
                                          ? authController.userPasswordError.value
                                          : null
                                      : inputID == 'carPlate'
                                          ? dashController.carNumberPlateError.value.length > 2
                                              ? dashController.carNumberPlateError.value
                                              : null
                                          : inputID == 'carOwnerId'
                                              ? dashController.carOwnerIdError.value.length > 2
                                                  ? dashController.carOwnerIdError.value
                                                  : null
                                              : null,
          prefixIcon: Icon(
            icon,
            size: 17.0,
            color: HexColor('#071D34'),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: HexColor('00BFA6'),
            ),
          ),
          labelText: lable,
          hintText: hint,
          hintStyle: GoogleFonts.roboto(
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          labelStyle: GoogleFonts.roboto(
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
            color: HexColor('#071D34'),
          ),
        ),
        onChanged: (value) {
          if (inputID == 'firstNameReg') {
            authController.validateFirstname(value);
          } else {
            if (inputID == 'secondNameReg') {
              authController.validateSecondname(value);
            } else {
              if (inputID == 'userRegMail') {
                authController.validateEmail(value);
              } else {
                if (inputID == 'newId') {
                  authController.validateid(value);
                } else {
                  if (inputID == 'newPass') {
                    authController.validatepassword(value);
                  } else {
                    if (inputID == 'userLoginemail') {
                      authController.validateLogUsername(value);
                    } else {
                      if (inputID == 'userPass') {
                        authController.validateLogpassword(value);
                      } else {
                        if (inputID == 'carPlate') {
                          dashController.validatecarNumber(value);
                        } else {
                          if (inputID == 'carOwnerId') {
                            dashController.validateOnerId(value);
                          } else {}
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        },
      );
    });
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

  Widget sentenceWithLinkText(String sentence, String linktext, ontap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          sentence,
          style: GoogleFonts.roboto(
            fontSize: 11.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          width: 5.5,
        ),
        InkWell(
          onTap: ontap,
          splashColor: Colors.transparent,
          child: Text(
            linktext,
            style: GoogleFonts.roboto(fontSize: 11.0, fontWeight: FontWeight.w400, color: Colors.lightBlueAccent),
          ),
        ),
      ],
    );
  }

  Widget basicDropDown(String hint, String dropID) {
    return GetX<DashController>(builder: (controller) {
      return DropdownButton<String>(
        underline: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 0.5)),
        ),
        elevation: 10,
        isExpanded: true,
        dropdownColor: Colors.white,
        style: GoogleFonts.roboto(
          fontSize: 13.0,
          fontWeight: FontWeight.w400,
          color: HexColor('#071D34'),
        ),
        value: dropID == 'fromDrop'
            ? controller.from.value == ""
                ? null
                : controller.from.value
            : dropID == 'toDrop'
                ? controller.to.value == ""
                    ? null
                    : controller.to.value
                : dropID == 'myCar'
                    ? controller.car.value == ""
                        ? null
                        : controller.car.value
                    : null,
        hint: Text(
          hint,
          style: const TextStyle(
            color: Color.fromARGB(255, 114, 113, 113),
          ),
        ),
        onChanged: (newValue) {
          if (dropID == 'fromDrop') {
            dashController.from.value = newValue!;
          } else {
            if (dropID == 'toDrop') {
              dashController.to.value = newValue!;
            } else {
              if (dropID == 'myCar') {
                dashController.car.value = newValue!;
              }
            }
          }
        },
        items: dropDown(dropID).map((String value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    });
  }

  List<String> dropDown(String dropId) {
    if (dropId == 'myCar') {
      List<String> cars = [];
      for (var element in dashController.myCars) {
        cars.add(element['carPlate'].toString());
      }
      return cars;
    } else {
      return [
        "Mlolongo",
        "Syokimau",
        "SGR",
        "JKIA",
        "Eastern Bypass",
        "Southern Bypass",
        "Capital Center",
        "Haile Selassie",
        "Museum Hill",
        "The Mall",
        "Nairobi Westlands",
      ];
    }
  }
}
