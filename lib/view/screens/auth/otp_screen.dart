import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/show_custom_error.dart';
import 'package:flutter_restaurant/view/screens/auth/details.dart';
import 'package:flutter_restaurant/view/screens/branch/branch_list_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? _otpCode;
  final TextEditingController _otpController = TextEditingController();

  Future<void> _verifyOtp(String otp) async {
    try {
      final Dio dio = Dio();
      final response = await dio.post(
        AppConstants.otp,
        data: {'phone': widget.phoneNumber, 'otp': otp},
      );
      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['status_code'] == 0) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ContactDetails(phoneNumber: widget.phoneNumber)));
        } else if (responseData['status_code'] == 1) {
          final token = responseData['token'];
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('token');
          await prefs.setString('token', token);

          Get.context!.pushReplacement('/branch-list?isOtp=true');
        } else {
          showCustomErrorDialog(context, 'Failed to verify OTP');
        }
      } else {
        showCustomErrorDialog(context, 'Failed to verify OTP');
      }
    } catch (e) {
      String errorMessage = 'An error occurred';
      if (e is DioError) {
        if (e.response != null && e.response?.data != null) {
          errorMessage = e.response?.data['message'] ?? 'An error occurred';
        }
      }
      print(e.toString());
      showCustomErrorDialog(context, errorMessage);
    }
  }

  @override
  void initState() {
    super.initState();

    // Clear OTP when the controller text is empty
    _otpController.addListener(() {
      if (_otpController.text.isEmpty) {
        setState(() {
          _otpCode = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorResources.kWhite,
      appBar: AppBar(
        backgroundColor: ColorResources.kWhite,
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              children: [
                 Text(
                    getTranslated('verify_phone', context),
                  style:const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    height: 0.99,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'We have sent you a 4 digit code',
                  style: TextStyle(fontSize: 12),
                ),
                const Text(
                  'Please enter it here to verify your number',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 150),
                PinCodeTextField(
                  controller: _otpController,
                  maxLength: 4,
                  autofocus: true,
                  wrapAlignment: WrapAlignment.center,
                  pinBoxWidth: 61,
                  pinBoxHeight: 56,
                  pinBoxRadius: screenWidth * 0.03,
                  pinTextStyle: TextStyle(fontSize: screenWidth * 0.05),
                  pinBoxColor: ColorResources.kGrayLogo,
                  defaultBorderColor: ColorResources.kGrayLogo,
                  pinBoxDecoration:
                      ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                  onDone: (pin) {
                    setState(() {
                      _otpCode = pin;
                    });
                    // Verify OTP immediately after entering
                    _verifyOtp(pin);
                  },
                ),
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}
