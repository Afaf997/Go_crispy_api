// import 'package:flutter/material.dart';
// import 'package:flutter_restaurant/data/model/response/config_model.dart';
// import 'package:flutter_restaurant/data/model/response/signup_model.dart';
// import 'package:flutter_restaurant/helper/app_mode.dart';
// import 'package:flutter_restaurant/helper/email_checker.dart';
// import 'package:flutter_restaurant/helper/responsive_helper.dart';
// import 'package:flutter_restaurant/localization/language_constrants.dart';
// import 'package:flutter_restaurant/provider/auth_provider.dart';
// import 'package:flutter_restaurant/provider/splash_provider.dart';
// import 'package:flutter_restaurant/utill/app_constants.dart';
// import 'package:flutter_restaurant/utill/color_resources.dart';
// import 'package:flutter_restaurant/utill/dimensions.dart';
// import 'package:flutter_restaurant/utill/images.dart';
// import 'package:flutter_restaurant/helper/router_helper.dart';
// import 'package:flutter_restaurant/utill/styles.dart';
// import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
// import 'package:flutter_restaurant/view/base/custom_button.dart';
// import 'package:flutter_restaurant/view/base/custom_directionality.dart';
// import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
// import 'package:flutter_restaurant/view/base/web_app_bar.dart';
// // import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:provider/provider.dart';

// class VerificationScreen extends StatefulWidget {
//   final String emailAddress;
//   final bool fromSignUp;
//   final String? session;

//   const VerificationScreen({Key? key, required this.emailAddress, this.fromSignUp = false, this.session}) : super(key: key);

//   @override
//   State<VerificationScreen> createState() => _VerificationScreenState();
// }

// class _VerificationScreenState extends State<VerificationScreen> {

//   @override
//   void initState() {
//     final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
//     authProvider.startVerifyTimer();
//     super.initState();
//   }
  
//   @override
//   Widget build(BuildContext context) {

//     final double width = MediaQuery.of(context).size.width;
//     final isPhone = EmailChecker.isNotValid(widget.emailAddress);

//     final ConfigModel config = Provider.of<SplashProvider>(context, listen: false).configModel!;
//     final bool isFirebaseOTP =  config.customerVerification!.status! && config.customerVerification?.type ==  'firebase';

//     return Scaffold(
//       appBar: (ResponsiveHelper.isDesktop(context)
//           ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
//           : CustomAppBar(context: context, title: getTranslated(isPhone ? 'verify_phone' : 'verify_email', context))) as PreferredSizeWidget?,

//       body: SafeArea(child: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Center(child: SizedBox(width: Dimensions.webScreenWidth, child: Consumer<AuthProvider>(
//           builder: (context, authProvider, child) => Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 55),

//               config.emailVerification!? Image.asset(
//                 Images.emailWithBackground,
//                 width: 142,
//                 height: 142,
//               ) : Icon(Icons.phone_android_outlined,size: 50,color: Theme.of(context).primaryColor),
//               const SizedBox(height: 40),

//               Padding(padding: const EdgeInsets.symmetric(horizontal: 50), child: Center(child: Text(
//                 '${getTranslated('please_enter_6_digit_code', context)}\n ${widget.emailAddress}',
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
//               ))),

//               if(AppMode.demo == AppConstants.appMode && !isFirebaseOTP)
//                 Padding(
//                   padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//                   child: Text(getTranslated('for_demo_purpose_use', context)!, style: rubikMedium.copyWith(
//                     color: Theme.of(context).disabledColor,
//                   )),
//                 ),
              
//               // Padding(
//               //   padding:  EdgeInsets.symmetric(horizontal: width > 850 ? 300 : Dimensions.paddingSizeDefault, vertical: 35),
//               //   child: PinCodeTextField(
//               //     length: 6,
//               //     appContext: context,
//               //     obscureText: false,
//               //     keyboardType: TextInputType.number,
//               //     animationType: AnimationType.fade,
//               //     pinTheme: PinTheme(
//               //       shape: PinCodeFieldShape.box,
//               //       fieldHeight: 63,
//               //       fieldWidth: 55,
//               //       borderWidth: 1,
//               //       borderRadius: BorderRadius.circular(10),
//               //       selectedColor: Theme.of(context).primaryColor.withOpacity(0.4),
//               //       selectedFillColor: Colors.white,
//               //       inactiveFillColor: ColorResources.getSearchBg(context),
//               //       inactiveColor: Theme.of(context).secondaryHeaderColor,
//               //       activeColor: Theme.of(context).primaryColor,
//               //       activeFillColor: ColorResources.getSearchBg(context),
//               //     ),
//               //     animationDuration: const Duration(milliseconds: 300),
//               //     backgroundColor: Colors.transparent,
//               //     enableActiveFill: true,
//               //     onChanged: authProvider.updateVerificationCode,
//               //     beforeTextPaste: (text) {
//               //       return true;
//               //     },
//               //   ),
//               // ),



//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(getTranslated('did_not_receive_the_code', context)!, style: rubikMedium.copyWith(
//                     color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.6),
//                   )),
//                   const SizedBox(width: Dimensions.paddingSizeSmall),


//                   authProvider.resendButtonLoading ? const CircularProgressIndicator() : TextButton(
//                       onPressed: authProvider.currentTime! > 0 ? null :  () async {
//                         if (widget.fromSignUp) {
//                           await authProvider.sendVerificationCode(config, SignUpModel(phone: widget.emailAddress, email: widget.emailAddress));

//                         } else {
//                           if(isFirebaseOTP) {
//                             authProvider.firebaseVerifyPhoneNumber(widget.emailAddress.trim(), isForgetPassword: true);
//                           }else{
//                             await authProvider.forgetPassword(config: config, phoneOrEmail:  widget.emailAddress).then((value) {
//                               authProvider.startVerifyTimer();

//                               if (value!.isSuccess) {
//                                 showCustomSnackBar(getTranslated('resend_code_successful', context), isError: false);
//                               } else {
//                                 showCustomSnackBar(value.message!);
//                               }
//                             });
//                           }
//                         }

//                       },
//                       child: Builder(
//                           builder: (context) {
//                             int? days, hours, minutes, seconds;

//                             Duration duration = Duration(seconds: authProvider.currentTime ?? 0);
//                             days = duration.inDays;
//                             hours = duration.inHours - days * 24;
//                             minutes = duration.inMinutes - (24 * days * 60) - (hours * 60);
//                             seconds = duration.inSeconds - (24 * days * 60 * 60) - (hours * 60 * 60) - (minutes * 60);

//                             return CustomDirectionality(
//                               child: Text((authProvider.currentTime != null && authProvider.currentTime! > 0)
//                                   ? '${getTranslated('resend', context)} (${minutes > 0 ? '${minutes}m :' : ''}${seconds}s)'
//                                   : getTranslated('resend_it', context)!, textAlign: TextAlign.end,
//                                   style: rubikMedium.copyWith(
//                                     color: authProvider.currentTime != null && authProvider.currentTime! > 0 ?
//                                     Theme.of(context).disabledColor : Theme.of(context).primaryColor.withOpacity(.6),
//                                   )),
//                             );
//                           }
//                       )),
//                 ],
//               ) ,
//               const SizedBox(height: 48),

//               authProvider.isEnableVerificationCode && !authProvider.resendButtonLoading ?
//               !authProvider.isPhoneNumberVerificationButtonLoading ? Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
//                 child: CustomButton(
//                   btnTxt: getTranslated('verify', context),
//                   onTap: () {
//                     if (widget.fromSignUp) {
//                       if(config.customerVerification!.status! && config.customerVerification!.type == 'phone') {
//                         authProvider.verifyPhone(widget.emailAddress.trim()).then((value) {
//                           if(value.isSuccess){
//                             RouterHelper.getMainRoute(action: RouteAction.pushReplacement);
//                           }
//                         });
//                       }else if(config.customerVerification!.status! && config.customerVerification!.type == 'email') {
//                         authProvider.verifyEmail(widget.emailAddress).then((value){
//                           if(value.isSuccess){
//                             RouterHelper.getMainRoute(action: RouteAction.pushReplacement);
//                           }

//                         });

//                       } else if(isFirebaseOTP) {
//                         authProvider.firebaseOtpLogin(
//                           phoneNumber: widget.emailAddress,
//                           session: '${widget.session}',
//                           : authProvider.verificationCode,
//                         );

//                       }
//                     } else {

//                       if(isFirebaseOTP) {
//                         authProvider.firebaseOtpLogin(
//                           phoneNumber: widget.emailAddress,
//                           session: '${widget.session}',
//                           otp: authProvider.verificationCode,
//                           isForgetPassword: true,
//                         );
//                       }else{
//                         authProvider.verifyToken(widget.emailAddress).then((value) {
//                           if(value.isSuccess) {
//                             RouterHelper.getNewPassRoute(widget.emailAddress, authProvider.verificationCode);
//                           }else {
//                             showCustomSnackBar(value.message!);
//                           }
//                         });
//                       }
//                     }
//                   },
//                 ),
//               ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
//                   : const SizedBox.shrink(),

//               const SizedBox(height: Dimensions.paddingSizeLarge),
//             ],
//           ),
//         ))),
//       )),
//     );
//   }
// }
