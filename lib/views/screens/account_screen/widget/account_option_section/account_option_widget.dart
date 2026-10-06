import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/account_screen/widget/account_option_section/account_option_model.dart';

class AccountOptionWidget extends StatelessWidget {
  final AccountOptionModel accountOptionModel;
  final bool isSubItem;
  const AccountOptionWidget(
      {super.key, required this.accountOptionModel, this.isSubItem = false});

  @override
  Widget build(BuildContext context) {
    if (accountOptionModel.subItems != null &&
        accountOptionModel.subItems!.isNotEmpty) {
      return Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          minTileHeight: 48.h,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
          leading: SvgPicture.asset(
            accountOptionModel.icon,
            height: 20.h,
            width: 20.w,
            fit: BoxFit.cover,
          ),
          title: CustomText(
            accountOptionModel.title,
            style: Helper(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14, color: blackText1),
          ),
          children: accountOptionModel.subItems!
              .map((subItem) => Column(
                    children: [
                      Divider(
                        color: greyLight1,
                        indent: 32.w,
                        endIndent: 16.w,
                        height: 1,
                        thickness: 1,
                      ),
                      AccountOptionWidget(
                        accountOptionModel: subItem,
                        isSubItem: true,
                      ),
                    ],
                  ))
              .toList(),
        ),
      );
    }

    return GestureDetector(
      onTap: accountOptionModel.onTap,
      child: Container(
        height: isSubItem ? 40.h : 48.h,
        padding: EdgeInsets.symmetric(horizontal: isSubItem ? 32.w : 16.w),
        color: Colors.transparent, // Ensures the whole area is clickable
        child: Row(
          children: [
            SvgPicture.asset(
              accountOptionModel.icon,
              height: isSubItem ? 18.h : 20.h,
              width: isSubItem ? 18.w : 20.w,
              fit: BoxFit.cover,
            ),
            sizedBoxWidth(width: 12.w),
            Expanded(
              child: CustomText(
                accountOptionModel.title,
                style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: isSubItem ? 13 : 14, color: blackText1),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: isSubItem ? 12 : 16,
              color: greyLight5,
            )
          ],
        ),
      ),
    );
  }
}
