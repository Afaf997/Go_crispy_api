// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_restaurant/data/model/response/config_model.dart';
// import 'package:flutter_restaurant/data/model/response/social_login_model.dart';
// import 'package:flutter_restaurant/helper/responsive_helper.dart';
// import 'package:flutter_restaurant/localization/language_constrants.dart';
// import 'package:flutter_restaurant/provider/auth_provider.dart';
// import 'package:flutter_restaurant/provider/splash_provider.dart';
// import 'package:flutter_restaurant/utill/app_constants.dart';
// import 'package:flutter_restaurant/utill/dimensions.dart';
// import 'package:flutter_restaurant/utill/images.dart';
// import 'package:flutter_restaurant/helper/router_helper.dart';
// import 'package:flutter_restaurant/utill/styles.dart';
// import 'package:provider/provider.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';


// class SocialLoginWidget extends StatefulWidget {
//   const SocialLoginWidget({Key? key}) : super(key: key);

//   @override
//   State<SocialLoginWidget> createState() => _SocialLoginWidgetState();
// }

// class _SocialLoginWidgetState extends State<SocialLoginWidget> {
//   SocialLoginModel socialLogin = SocialLoginModel();

//   void route(
//       bool isRoute,
//       String? token,
//       String errorMessage,
//       ) async {
//     if (isRoute) {
//       if(token != null){
//         RouterHelper.getDashboardRoute('home',action: RouteAction.pushNamedAndRemoveUntil);
//       }
//       else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage),
//             backgroundColor: Colors.red));
//       }

//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage),
//           backgroundColor: Colors.red));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ConfigModel? configModel = Provider.of<SplashProvider>(context,listen: false).configModel;
//     return Consumer<AuthProvider>(
//       builder: (context, authProvider, _) {
//         return Column(children: [

//           Center(child: Text('${getTranslated('sign_in_with', context)}', style: poppinsRegular.copyWith(
//               color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6),
//               fontSize: Dimensions.fontSizeSmall))),
//           const SizedBox(height: Dimensions.paddingSizeDefault),

//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [

//            if(configModel!.socialLoginStatus!.isGoogle!)
//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
//                child: InkWell(
//                   onTap: () async {
//                     try{
//                       GoogleSignInAuthentication  auth = await authProvider.googleLogin();
//                       GoogleSignInAccount googleAccount = authProvider.googleAccount!;

//                       authProvider.socialLogin(SocialLoginModel(
//                         email: googleAccount.email, token: auth.idToken, uniqueId: googleAccount.id, medium: 'google',
//                       ), route);


//                     }catch(er){
//                       debugPrint('access token error is : $er');
//                     }
//                   },
//                   child: Container(
//                     height: ResponsiveHelper.isDesktop(context)
//                         ? 50 : 40,
//                     width: ResponsiveHelper.isDesktop(context)
//                         ? 130 :ResponsiveHelper.isTab(context)
//                         ? 110 : 40,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.1),
//                       borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
//                     ),
//                     child:   Image.asset(
//                       Images.google,
//                       height: ResponsiveHelper.isDesktop(context)
//                           ? 30 :ResponsiveHelper.isTab(context)
//                           ? 25 : 20,
//                       width: ResponsiveHelper.isDesktop(context)
//                           ? 30 : ResponsiveHelper.isTab(context)
//                           ? 25 : 20,
//                     ),
//                   ),
//                 ),
//              ),


//             if(configModel.socialLoginStatus!.isFacebook!)
//               InkWell(
//                 onTap: () async{
//                 LoginResult result = await FacebookAuth.instance.login();

//                 if (result.status == LoginStatus.success) {
//                  Map userData = await FacebookAuth.instance.getUserData();


//                  authProvider.socialLogin(
//                    SocialLoginModel(
//                      email: userData['email'],
//                      token: result.accessToken!.token,
//                      uniqueId: result.accessToken!.userId,
//                      medium: 'facebook',
//                    ), route,
//                  );
//                 }
//               },
//               child: Container(
//                 height: ResponsiveHelper.isDesktop(context)?50 :ResponsiveHelper.isTab(context)? 40:40,
//                 width: ResponsiveHelper.isDesktop(context)? 130 :ResponsiveHelper.isTab(context)? 110: 40,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.1),
//                   borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
//                 ),
//                 child:   Image.asset(
//                   Images.facebook,
//                   height: ResponsiveHelper.isDesktop(context)
//                       ? 30 : ResponsiveHelper.isTab(context)
//                       ? 25 : 20,
//                   width: ResponsiveHelper.isDesktop(context)
//                       ? 30 :ResponsiveHelper.isTab(context)
//                       ? 25 : 20,
//                 ),
//               ),
//             ),

//            if(!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS && configModel.appleLogin != null &&  configModel.appleLogin!.status!) Padding(
//               padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
//               child: InkWell(
//                 onTap: () async {
//                   final credential = await SignInWithApple.getAppleIDCredential(scopes: [
//                     AppleIDAuthorizationScopes.email,
//                     AppleIDAuthorizationScopes.fullName,
//                   ],
//                     webAuthenticationOptions: WebAuthenticationOptions(
//                       clientId: '${configModel.appleLogin?.clientId}',
//                       redirectUri: Uri.parse(AppConstants.baseUrl),
//                     ),
//                   );
//                   authProvider.socialLogin(SocialLoginModel(
//                     email: credential.email, token: credential.authorizationCode, uniqueId: credential.authorizationCode, medium: 'apple',
//                   ), route);
//                 },
//                 child: Container(
//                   height: 40,
//                   width: 40,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.1),
//                     borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
//                   ),
//                   child: Image.asset(Images.appleLogo, height: 25),
//                 ),
//               ),
//             ),
//           ]),
//           const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
//         ]);
//       }
//     );
//   }
// }
