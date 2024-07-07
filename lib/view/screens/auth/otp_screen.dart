import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/screens/auth/details.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? _otpCode;

  Future<void> _verifyOtp(String otp) async {
    try {
      final Dio dio = Dio();
      final response = await dio.post(
        AppConstants.otp,
        data: {'phone': widget.phoneNumber, 'otp': otp},
      );
   if (response.statusCode == 200) {
        showCustomSnackBar('OTP verified successfully', isError: false);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ContactDetails(phoneNumber: widget.phoneNumber)));
      }else{
        showCustomSnackBar('Failed to verify OTP', );
      }
    } catch (e) {
      showCustomSnackBar('An error occurred: ${e.toString()}', );
    }
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            children: [
              const Text(
                "Verify your mobile number",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  height: 0.99,
                ),
                textAlign: TextAlign.center,
              ), const SizedBox(height: 20,),
              const Text(
                'We have sent you a 4 digit code.',
                style: TextStyle(fontSize: 12),
              ),
              const Text(
                'Please enter it here to verify your number',
                style: TextStyle(fontSize: 12),
              ),
             const SizedBox(height: 20,),
              PinCodeTextField(
                maxLength: 4,
                autofocus: true,
                wrapAlignment: WrapAlignment.center,
                pinBoxWidth: 61,
                pinBoxHeight: 56,
                pinBoxRadius: screenWidth * 0.03,
                pinTextStyle: TextStyle(fontSize: screenWidth * 0.05),
                pinBoxColor: ColorResources.kGrayLogo,
                defaultBorderColor: ColorResources.kGrayLogo,
                pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                onDone: (pin) {
                  setState(() {
                    _otpCode = pin;
                  });
                },
              ), const SizedBox(height: 240,),
              CustomButton(
                btnTxt: 'Continue',
                backgroundColor: ColorResources.kOrangeColor,
                onTap: () {
                  if (_otpCode != null) {
                    _verifyOtp(_otpCode!);
                  } else {
                    showCustomSnackBar('Please enter the OTP', );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}