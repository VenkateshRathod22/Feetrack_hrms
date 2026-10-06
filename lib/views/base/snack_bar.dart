
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../main.dart';

showSnackBar({required String content, SnackBarAction? snackBarAction}){
  snackBarKey.currentState!
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(milliseconds: 5000),
        margin:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 30.h),
        action: snackBarAction,
      ),
    );
}