import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_restaurant/utill/images.dart';

Widget buildLocateContainer(BuildContext context) {
  return GestureDetector(
    onTap: () {
      GoRouter.of(context).go('/branch-list'); 
    },
    child: Center(
      child: Image.asset(
        Images.locate,
      ),
    ),
  );
}

