import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/data/model/response/user_log_data.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/auth/widget/social_login_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;
  String? countryCode;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // Initialize values from providers
    final ConfigModel configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    authProvider.setIsLoading = false;
    authProvider.setIsPhoneVerificationButttonLoading = false;
    UserLogData? userData = authProvider.getUserData();

    if (userData != null) {
      if (configModel.emailVerification!) {
        _emailController!.text = userData.email ?? '';
      } else if (userData.phoneNumber != null) {
        _emailController!.text = userData.phoneNumber!;
      }
      countryCode = userData.countryCode;
      _passwordController!.text = userData.password ?? '';
    }

    countryCode ??=
        CountryCode.fromCountryCode(configModel.countryCode!).dialCode;
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    final socialStatus = configModel.socialLoginStatus;

    return Scaffold(
      backgroundColor: ColorResources.kWhite,
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(100), child: WebAppBar())
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Center(
              child: Container(
                width: width > 700 ? 700 : width,
                padding: width > 700
                    ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
                    : null,
                decoration: width > 700
                    ? BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).shadowColor,
                              blurRadius: 5,
                              spreadRadius: 1)
                        ],
                      )
                    : null,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Form(
                    key: _formKeyLogin,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            getTranslated('login', context)!,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 35),

                        // Email or Phone Number input
                        configModel.emailVerification!
                            ? CustomTextField(
                                hintText: getTranslated('demo_gmail', context),
                                isShowBorder: true,
                                focusNode: _emailNumberFocus,
                                nextFocus: _passwordFocus,
                                controller: _emailController,
                                inputType: TextInputType.emailAddress,
                              )
                            : Container(
                              height: 50,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: ColorResources.kGrayLogo,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      Images.qatar,
                                      width: 24,
                                    ),SizedBox(width: 5,),
                                    const Text(
                                      '+974',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      ' |',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: ColorResources.kfavouriteColor
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Mobile number',
                                          hintStyle: TextStyle(
                                            fontSize: 13,
                                            color:
                                                ColorResources.kTextgreyColor,
                                          ),
                                        ),
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        if (authProvider.loginErrorMessage!.isNotEmpty)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  radius: 5),
                       
                            ],
                          ),

                        const SizedBox(height: 400),

                        // Login Button
                        !authProvider.isLoading &&
                                !authProvider
                                    .isPhoneNumberVerificationButtonLoading
                            ? CustomButton(
                                btnTxt: getTranslated('continue', context),
                                backgroundColor: ColorResources.kOrangeColor,
                                onTap: (){
                                  
                                },
                              

                            )
                            : Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                ),
                              ),SizedBox(height: 10,),
                              SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
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
      style: TextStyle( color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,),
                 
                ),
              ),
            ),

                        const SizedBox(height: 20),

                        // Create an account link
                        InkWell(
                          onTap: () => RouterHelper.getCreateAccountRoute(),
                          child:const Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeSmall),
                            
                          ),
                        ),

                    
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}
