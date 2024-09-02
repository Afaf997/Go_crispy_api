import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/view/base/show_custom_error.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/screens/branch/branch_list_screen.dart';

class ContactDetails extends StatefulWidget {
  final String phoneNumber;

  ContactDetails({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _firstNameFocusNode.addListener(() => _formKey.currentState!.validate());
    _lastNameFocusNode.addListener(() => _formKey.currentState!.validate());
    _emailFocusNode.addListener(() => _formKey.currentState!.validate());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

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
        await _saveToken(token);
        // showCustomSnackBar('Registration successful',);
        showCustomNotification(context, 'Registration successful',
            type: NotificationType.success);
        print("here1");
        Get.context!.go('/branch-list?isOtp=true');
        // await Navigator.pushAndRemoveUntil(
        //     Get.context!,
        //     MaterialPageRoute(
        //         builder: (context) => const BranchListScreen(
        //               useNavigator: true,
        //               isOtp: true,
        //             )),
        //     ModalRoute.withName('/'));
      } else if (response.statusCode == 403) {
        showCustomErrorDialog(context,
            'The email is already used. Please use a different email.');
      } else {
        showCustomErrorDialog(context, 'Registration failed');
      }
    } catch (e) {
      showCustomErrorDialog(context,
          'An error occurred\nThe email is already used. Please use a different email.');
    }
  }

  Future<void> _saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
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
                hintText: 'Enter your first name',
                focusNode: _firstNameFocusNode,
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
                hintText: 'Enter your last name',
                focusNode: _lastNameFocusNode,
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
                hintText: 'Enter your email',
                focusNode: _emailFocusNode,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 120.0),
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
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;

  const CustomTextField({
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.validator,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
            color: ColorResources.korgGrey,
            fontSize: 12), // Reduced hint text size
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
