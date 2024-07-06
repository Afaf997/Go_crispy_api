import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/repository/auth_repo.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/screens/branch/branch_list_screen.dart';

class ContactDetails extends StatefulWidget {
  final String phoneNumber;
   ContactDetails({
    Key? key,
    required this.phoneNumber, this.authRepo,
  }) : super(key: key);
   final AuthRepo? authRepo;

  @override
  _ContactDetailsState createState() => _ContactDetailsState();
   
}

class _ContactDetailsState extends State<ContactDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final Dio dio = Dio();
      final response = await dio.post(
        AppConstants.registrationApi,
        data: {
          'f_name': _firstNameController.text.trim(),
          'l_name': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': widget.phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        String token = response.data["token"];
        await _updateAuthToken(token);
        showCustomSnackBar('Registration successful', isError: false);
         Navigator.push(context, MaterialPageRoute(builder: (context) =>const BranchListScreen()));
        // Navigate to the next screen or perform other actions
      } else {
        showCustomSnackBar('Registration failed', );
      }
    } catch (e) {
      showCustomSnackBar('An error occurred: ${e.toString()}', );
    }
  }

  Future<void> _updateAuthToken(String token) async {

    widget.authRepo?.saveUserToken(token);
    await widget.authRepo?.updateToken();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorResources.kWhite,
      appBar: AppBar(
        backgroundColor: ColorResources.kWhite,
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Enter your details",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              const ReusableLabelText(text: 'First Name'),
              const SizedBox(height: 15.0),
              CustomTextField(
                
                controller: _firstNameController,
                labelText: 'Enter your First Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              const ReusableLabelText(text: 'Last Name'),
              const SizedBox(height: 15.0),
              CustomTextField(
                controller: _lastNameController,
                labelText: 'Enter your last name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              const ReusableLabelText(text: 'Email'),
              const SizedBox(height: 15.0),
              CustomTextField(
                controller: _emailController,
                labelText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 100.0),
              CustomButton(
                btnTxt: 'Continue',
                backgroundColor: ColorResources.kOrangeColor,
                onTap: _registerUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableLabelText extends StatelessWidget {
  final String text;

  const ReusableLabelText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.labelText,
    required this.controller,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: ColorResources.korgGrey, fontSize: 14),
        fillColor: ColorResources.kGrayLogo,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}