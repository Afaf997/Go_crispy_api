import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/js.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorResources.kWhite,
      appBar: (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(100), child: WebAppBar())
              : CustomAppBar(
                  context: context,
                  title: getTranslated('help_and_support', context)))
          as PreferredSizeWidget?,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTranslated("for_any_queries", context),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              TextButton(
                  onPressed: () {
                    _dialNumber("+97440298888");
                  },
                  child: const Text(
                    "+974 40298888",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue),
                  ))

              // ConstrainedBox(
              //   constraints: BoxConstraints(
              //       minHeight:
              //           !ResponsiveHelper.isDesktop(context) && height < 600
              //               ? height
              //               : height - 400),
              //   child: Center(
              //     child: Padding(
              //       padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              //       child: Container(
              //         width: width > 700 ? 700 : width,
              //         padding: width > 700
              //             ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
              //             : null,
              //         decoration: width > 700
              //             ? BoxDecoration(
              //                 color: Theme.of(context).canvasColor,
              //                 borderRadius: BorderRadius.circular(10),
              //                 boxShadow: [
              //                   BoxShadow(
              //                       color: Theme.of(context).shadowColor,
              //                       blurRadius: 5,
              //                       spreadRadius: 1)
              //                 ],
              //               )
              //             : null,
              //       ),
              //     ),
              //   ),
              // ),
              // if (ResponsiveHelper.isDesktop(context)) const FooterView(),
            ],
          ),
        ),
      ),
    );
  }

  // Function to open the dialer with a given phone number
  Future<void> _dialNumber(String number) async {
    final Uri dialUri = Uri(
      scheme: 'tel',
      path: number,
    );
    try {
      if (await canLaunchUrl(dialUri)) {
        await launchUrl(dialUri);
      } else {
        throw 'Could not launch $number';
      }
    } catch (e) {
      print(e);
    }
  }
}
