import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  const SignOutConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 300,
        child: Consumer<AuthProvider>(builder: (context, auth, child) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 30,
              backgroundColor: ColorResources.kOrangeColor,
              child: const Icon(
                Icons.contact_support,
                size: 50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Text(getTranslated('want_to_sign_out', context)!,
                  style: rubikBold, textAlign: TextAlign.center),
            ),
            Container(
              height: 0.5,
              color: ColorResources.kOrangeColor,
            ),
            !auth.isLoading
                ? Row(children: [
                    Expanded(
                        child: InkWell(
                      onTap: () async {
                        Provider.of<AuthProvider>(context, listen: false)
                            .clearSharedData(context)
                            .then((condition) {
                          if (ResponsiveHelper.isWeb()) {
                            RouterHelper.getLoginRoute(
                                action: RouteAction.pushNamedAndRemoveUntil);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const LoginScreen()));
                          } else {
                            if (condition) {
                              print("condition");
                              Get.context?.pushReplacement("/login");
                            }

                            //  context.pop();
                            // RouterHelper.getLoginRoute(
                            //     action: RouteAction.pushNamedAndRemoveUntil);
                            // WidgetsBinding.instance.addPostFrameCallback((_) {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const LoginScreen()),
                            //  ModalRoute.withName('/')
                            // );
                            // });
                            // await  Navigator.pushAndRemoveUntil(context,
                            //       MaterialPageRoute(
                            //     builder: (context) {
                            //       return const LoginScreen();
                            //     },
                            //   ), ModalRoute.withName('/'));
                          }
                        });
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10))),
                        child: Text(getTranslated('yes', context)!,
                            style: rubikBold.copyWith(
                              color: ColorResources.kOrangeColor,
                            )),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () => context.pop(),
                      child: Container(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: ColorResources.kOrangeColor,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Text(getTranslated('no', context)!,
                            style: rubikBold.copyWith(color: Colors.white)),
                      ),
                    )),
                  ])
                : const Padding(
                    padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: CircularProgressIndicator(
                      color: ColorResources.kOrangeColor,
                    ),
                  ),
          ]);
        }),
      ),
    );
  }
}
