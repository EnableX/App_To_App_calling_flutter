

import 'package:enxcalling/controllers/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/default_button.dart';
import '../utils/utils.dart';


class RegistrationScreen extends StatelessWidget{
  static String routeName = "/registration_screen";

  final RegistrationController _registrationController = Get.put(RegistrationController());
  final _formKey = GlobalKey<FormState>();

  RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Register Device',
        ),
      ),
      body:Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment. center,
            children: <Widget>[
              TextFormField(
                controller: _registrationController.nameTextController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  filled: true,
                  hintText: 'Enter Name',

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  ),
                ),

                validator: (value) =>
                value!.trim().isEmpty ? 'Name required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _registrationController.mobileTextController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  filled: true,
                  hintText: 'Enter Mobile number',

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  ),
                ),

                validator: (value) =>
                value!.trim().isEmpty ? 'Mobile number required' : null,
              ),
              const SizedBox(height: 16),

              DefaultButton(

                  text: 'Register',
                  press: () async {

    bool isPermissionGranted =
    await handlePermissionsForCall(context);
    if (isPermissionGranted) {

      if (_formKey.currentState!.validate()) {

        _registrationController.apiRegister();
      }

    } else {
    Get.snackbar(
    "Failed", "Microphone Permission Required for Video Call.",
    backgroundColor: Colors.white,
    colorText: Color(0xFF1A1E78),
    snackPosition: SnackPosition.BOTTOM);
    }

                  }, )
            ],
          ),
        ),
      ),
    );
  }
}