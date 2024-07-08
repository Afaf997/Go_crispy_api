import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/styles.dart';

void showCustomErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: ColorResources.kWhite,
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Error', style: rubikMedium.copyWith(color: Colors.red)),
          ],
        ),
        content: Text(errorMessage, style: rubikRegular),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK', style: rubikMedium.copyWith(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
