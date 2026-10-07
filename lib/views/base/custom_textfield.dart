import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@Deprecated("Do Not Use this Widget, instead use TextField from Flutter")
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.onChange,
    this.color,
    this.keyBoardType,
    this.hindText,
    required this.onTap,
    this.borderRadius,
    this.hintColor,
    required this.validate,
    this.maxLengh,
    required this.controller,
    this.suffixIcon,
    this.inputFrmtrs,
    this.obscure,
    this.prefixWidget,
  }) : super(key: key);
  final TextEditingController controller;
  final Function onChange;
  final Color? color;
  final List<TextInputFormatter>? inputFrmtrs;
  final Widget? suffixIcon;
  final Widget? prefixWidget;
  final Color? hintColor;
  final bool? obscure;
  final TextInputType? keyBoardType;
  final String? hindText;
  final Function() onTap;
  final double? borderRadius;
  final String? Function(String?)? validate;
  final int? maxLengh;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: TextFormField(
        obscureText: obscure ?? false,
        controller: controller,
        onChanged: (value) {
          onChange(value);
        },
        inputFormatters: inputFrmtrs ?? [],
        textAlign: TextAlign.left,
        expands: false,
        keyboardType: keyBoardType ?? TextInputType.text,
        onTap: () {
          onTap();
        },
        validator: (value) {
          return validate!(value);
        },
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: obscure != null ? 1 : maxLengh,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding:  EdgeInsets.only(
              right: 5.r,
            ),
            child: suffixIcon,
          ),
          prefix: Padding(
            padding:  EdgeInsets.only(
              right: 5.r,
            ),
            child: prefixWidget,
          ),
          prefixIconConstraints:  BoxConstraints(
            maxHeight: 25.h,
            maxWidth: 25.w,
          ),
          suffixIconConstraints:  BoxConstraints(
            maxHeight: 25.h,
            maxWidth: 25.w,
          ),
          hintText: hindText,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).hintColor,
              ),
          contentPadding:  EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          fillColor: Colors.grey.shade100,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
