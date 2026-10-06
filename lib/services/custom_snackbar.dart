import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScaffoldSnackBar {
  ScaffoldSnackBar(this._context);
  final BuildContext _context;

  /// The scaffold of current context.
  factory ScaffoldSnackBar.of(BuildContext context) {
    return ScaffoldSnackBar(context);
  }

  /// Helper method to show a SnackBar.
  void show(String message) {
    ScaffoldMessenger.of(_context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: Theme.of(_context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          // backgroundColor: Theme.of(_context).primaryColor.withOpacity(.8),
          elevation: 0,
          padding:  EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
          behavior: SnackBarBehavior.fixed,
        ),
      );
  }
}
