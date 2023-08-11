import 'package:expressway/textInput_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:photo_view/photo_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controller/auth_controller.dart';
import 'dashController.dart';

class DashControllerView extends StatelessWidget {
  DashControllerView({super.key});
  final TextInputWidget textInputWidget = Get.put(TextInputWidget());
  final AuthController authController = Get.put(AuthController());
  final DashController dashController = Get.put(DashController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final User? user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 226, 226, 226),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to be performed when the button is pressed
          Get.dialog(
            Center(
              child: IntrinsicHeight(
                child: Card(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
                    width: 150,
                    child: Column(
                      children: [
                        textInputWidget.customElevatedButtonGreen(() async {
                          await dashController.getUserCars();
                          Get.dialog(
                            Center(
                              child: IntrinsicHeight(
                                child: Card(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
                                    color: Colors.white,
                                    width: 400,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Your Cars',
                                          style: GoogleFonts.roboto(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Obx(() {
                                          if (dashController.myCars.isEmpty) {
                                            return Text(
                                              'Your Cars',
                                              style: GoogleFonts.roboto(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            );
                                          } else {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Car Name',
                                                        style: GoogleFonts.roboto(
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        'Car Owner Id',
                                                        style: GoogleFonts.roboto(
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        'Status',
                                                        style: GoogleFonts.roboto(
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                for (Map profile in dashController.myCars)
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          profile['carPlate'],
                                                          style: GoogleFonts.roboto(
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.w300,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          profile['carOwnerId'],
                                                          style: GoogleFonts.roboto(
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.w300,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'Approved',
                                                          style: GoogleFonts.roboto(fontSize: 14.0, fontWeight: FontWeight.w300, color: Colors.greenAccent),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              ],
                                            );
                                          }
                                        })
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }, 'My Cars'),
                        const SizedBox(
                          height: 20,
                        ),
                        textInputWidget.customElevatedButtonGreen(() {
                          Get.dialog(
                            Center(
                              child: IntrinsicHeight(
                                child: Card(
                                  child: Container(
                                    color: Colors.white,
                                    margin: const EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
                                    width: 300,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Register Car',
                                          style: GoogleFonts.roboto(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: 250,
                                          child: textInputWidget.basicInput('Car Number Plate', 'KVC 123', 'carPlate', Icons.car_repair),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: 250,
                                          child: textInputWidget.basicInput('Car Owner ID', '345', 'carOwnerId', Icons.car_repair),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        textInputWidget.customElevatedButtonGreen(() async {
                                          bool valid = dashController.validateNewCarReg();

                                          if (!valid) {
                                            Get.snackbar(
                                              'Error',
                                              'Your form is not valid',
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                            );
                                          } else {
                                            await dashController.registerNewCar();
                                          }
                                        }, 'Register Car'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }, 'Register Cars'),
                        const SizedBox(
                          height: 20,
                        ),
                        textInputWidget.customElevatedButtonGreen(() async {
                          await authController.logOutUser();
                        }, 'Logout'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        backgroundColor: HexColor('00BFA6'), // Button background color
        elevation: 10, // Button elevation
        child: Text(
          'Menu', // Text displayed on the button
          style: GoogleFonts.roboto(
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            Expanded(
              child: PhotoView(
                enableRotation: true,
                backgroundDecoration: const BoxDecoration(color: Colors.white),
                imageProvider: const AssetImage("expressWayHd.jpg"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Hello!, ${user!.userMetadata!['username'].toString()} ',
                    style: GoogleFonts.roboto(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Choose Your Destination',
                    style: GoogleFonts.roboto(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: textInputWidget.basicDropDown('From', 'fromDrop')),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(child: textInputWidget.basicDropDown('To', 'toDrop')),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    if (dashController.myCars.isEmpty) {
                      return Text(
                        'You have no cars',
                        style: GoogleFonts.roboto(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    } else {
                      return SizedBox(
                        width: 500,
                        child: textInputWidget.basicDropDown('My Cars', 'myCar'),
                      );
                    }
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  textInputWidget.customElevatedButtonGreen(() async {
                    await dashController.createTicket();
                  }, 'Generate Pass'),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
