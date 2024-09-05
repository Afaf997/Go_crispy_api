import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final AddressModel addressModel;
  final int index;
  const DeleteConfirmationDialog({Key? key, required this.addressModel, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorResources.kWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 300,
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          const SizedBox(height: 20),
         const CircleAvatar(
            radius: 30,
            backgroundColor: ColorResources.kOrangeColor,
            child: const Icon(Icons.contact_support, size: 50),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: FittedBox(
              child: Text(getTranslated('want_to_delete', context)!, style: rubikRegular, textAlign: TextAlign.center, maxLines: 1),
            ),
          ),

          Divider(height: 0, color: ColorResources.getHintColor(context)),

           Row(children: [

            Expanded(child: InkWell(
              onTap: () {
                showDialog(context: context, barrierDismissible: false, builder: (context) =>const Center(
                  child:  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(ColorResources.kOrangeColor),
                  ),
                ));
                Provider.of<LocationProvider>(context, listen: false).deleteUserAddressByID(addressModel.id, index, (bool isSuccessful, String message) {
                  context.pop();
                  // showCustomSnackBar(message, isError: !isSuccessful);
                  context.pop();
                });
              },
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                alignment: Alignment.center,
                decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                child: Text(getTranslated('yes', context)!, style: rubikBold.copyWith(color: ColorResources.kOrangeColor,)),
              ),
            )),

            Expanded(child: InkWell(
              onTap: () => context.pop(),
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                alignment: Alignment.center,
                decoration:const BoxDecoration(
                  color: ColorResources.kOrangeColor,
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10)),
                ),
                child: Text(getTranslated('no', context)!, style: rubikBold.copyWith(color: Colors.white)),
              ),
            )),

          ])
        ]),
      ),
    );
  }
}
