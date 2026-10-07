import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vlr/services/theme.dart';

enum ButtonType { primary, secondary, tertiary }

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.title,
    this.child,
    this.type = ButtonType.primary,
    required this.onTap,
    this.disabledColor,
    this.color,
    this.height = 45,
    this.isLoading = false,
    this.radius = 6,
    this.elevation = 0,
    this.fontSize = 16,
    this.textStyle,
    this.borderColor,
  })  : assert(title == null || child == null,
            'Cannot provide both a title and a child\n'),
        super(key: key);

  const CustomButton.tertiary(
      {Key? key,
      this.title,
      this.child,
      this.type = ButtonType.tertiary,
      required this.onTap,
      this.disabledColor,
      this.color,
      this.height = 45,
      this.isLoading = false,
      this.radius = 6,
      this.elevation = 0,
      this.fontSize,
      this.textStyle,
      this.borderColor})
      : assert(title == null || child == null,
            'Cannot provide both a title and a child\n'),
        super(key: key);

  ///Button Title text
  final String? title;

  ///Button Title text
  final Widget? child;

  ///Button Type i.e. Primary or Secondary or Ternary
  final ButtonType type;

  ///Button isLoading if provided true will disable click on button and circular progress indicator will be visible
  final bool isLoading;

  ///Button buttonDisabled Color
  final Color? disabledColor;

  ///Button Color
  final Color? color;
  final Color? borderColor;

  ///Button Height
  final double? height;

  ///Button Radius
  final double radius;

  ///Button onTap()
  final Function()? onTap;

  final double elevation;

  final double? fontSize;

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final _borderColor = borderColor ?? primaryColor;
    if (type == ButtonType.primary) {
      return MaterialButton(
        onPressed: isLoading ? null : onTap,
        height: height?.h,
        minWidth: 80.w,
        elevation: elevation,
        focusElevation: 0,
        highlightElevation: 0,
        disabledElevation: 0,
        hoverElevation: 0,
        color: color ?? Theme.of(context).primaryColor,
        disabledColor: disabledColor ?? Theme.of(context).disabledColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(color: _borderColor)),
        child: Center(
          child: Builder(
            builder: (context) {
              if (isLoading) {
                return CircularProgressIndicator(
                  color: color ?? Colors.white,
                  strokeWidth: 2,
                );
              }

              return child ??
                  Padding(
                    padding:
                         EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                    child: Text(
                      title!,
                      textAlign: TextAlign.center,
                      style: textStyle ??
                          GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: fontSize?.sp,
                          ),
                    ),
                  );
            },
          ),
        ),
      );
    } else if (type == ButtonType.secondary) {
      return MaterialButton(
        onPressed: isLoading ? null : onTap,
        height: height?.h,
        minWidth: 80.w,
        elevation: elevation,
        focusElevation: 0,
        highlightElevation: 0,
        disabledElevation: 0,
        hoverElevation: 0,
        color: color ?? Colors.transparent,
        disabledColor: disabledColor ?? Theme.of(context).disabledColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: _borderColor),
        ),
        child: Center(
          child: Builder(
            builder: (context) {
              if (isLoading) {
                return CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 2,
                );
              }

              return child ??
                  Padding(
                    padding:
                         EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                    child: Text(
                      title!,
                      textAlign: TextAlign.center,
                      style: textStyle ??
                          GoogleFonts.montserrat(
                            color: Theme.of(context).primaryColor,
                            fontSize: fontSize?.sp,
                          ),
                    ),
                  );
            },
          ),
        ),
      );
    } else {
      return TextButton(
        onPressed: isLoading ? null : onTap,
        child: Builder(
          builder: (context) {
            if (isLoading) {
              return CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
                strokeWidth: 2,
              );
            }
            if (child != null) {
              return child!;
            }
            return Padding(
              padding:  EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                title!,
                textAlign: TextAlign.center,
                style: textStyle ??
                    Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: fontSize?.sp,
                        ),
              ),
            );
          },
        ),
      );
    }
  }
}
