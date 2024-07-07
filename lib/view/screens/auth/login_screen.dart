import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/auth/otp_screen.dart';
import 'package:flutter_restaurant/view/screens/branch/branch_list_screen.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  String? _countryCode;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    _countryCode = CountryCode.fromCountryCode(configModel!.countryCode!).dialCode;
  }

  Future<void> _verifyPhoneNumber(String phone) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final Dio dio = Dio();
      final response = await dio.post(
        AppConstants.phoneApi,
        data: {'phone': phone},
      );

      if (response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(phoneNumber: phone)));
      } else {
        showCustomSnackBar('Failed to verify phone number');
      }
    } catch (e) {
      showCustomSnackBar('An error occurred: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final socialStatus = configModel.socialLoginStatus;

    return Scaffold(
      backgroundColor: ColorResources.kWhite,
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Center(
              
              child: Container(
                width: width > 700 ? 700 : width,
                padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                decoration: width > 700
                    ? BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                      )
                    : null,
                child: Form(
                  key: _formKeyLogin,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          getTranslated('login_and_sign', context)!,
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 35),

                      // Phone Number input
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          filled: true,
                          fillColor: ColorResources.kGrayLogo,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Enter your phone number',
                          hintStyle:const TextStyle(
                            fontSize: 13,
                            color: ColorResources.kTextgreyColor,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  Images.qatar,
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _countryCode ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: ColorResources.kTextgreyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.phone,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 300),

                      !_isLoading
                          ? CustomButton(
                              btnTxt: getTranslated('continue', context),
                              backgroundColor: ColorResources.kOrangeColor,
                              onTap: () async {
                                if (_formKeyLogin.currentState!.validate()) {
                                  final String phoneNumber = '${_phoneController.text.trim()}';
                                  await _verifyPhoneNumber(phoneNumber);
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                              ),
                            ),
                      const SizedBox(height: 20), 

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen(pageIndex: 0,)));
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(color: Colors.black, width: 1),
                          ),
                          child: const Text(
                            'Continue as guest',
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'By clicking "continue" you agree with',
                        style: TextStyle(
                          color: ColorResources.korgGrey,
                          fontSize: 12,
                        ),
                      ),
                      const Text(
                        'our terms and conditions',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),

                      const SizedBox(height: 20), 
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
