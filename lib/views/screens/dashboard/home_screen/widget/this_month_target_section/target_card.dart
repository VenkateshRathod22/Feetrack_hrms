import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/this_month_target_section/half_circle_progress.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/this_month_target_section/monthly_target_model.dart';

class TargetCard extends StatelessWidget {
  final MonthlyTargetModel target;

  const TargetCard({
    super.key,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
        horizontal: 8.w,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: greyLight2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: target.color,
                    width: 1,
                  ),
                ),
                child: Icon(
                  target.icon,
                  color: target.color,
                  size: 10.sp,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      target.title,
                      // maxLines: 2,
                      style: Helper(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    "Target",
                    style: Helper(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: greyDart2, fontSize: 8.sp),
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    target.target,
                    style: Helper(context).textTheme.titleLarge?.copyWith(
                          color: target.color,
                          fontSize: 12.sp,
                        ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 100.w,
                      height: 60.h,
                      child: HalfCircleProgress(
                        percent: target.percent,
                        progressColor: target.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: greyLight3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  CustomText(
                    "Achived",
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 10.sp,
                        ),
                  ),
                  sizedBoxHeight(height: 4.h),
                  CustomText(
                    target.achived,
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          color: Colors.green,
                          fontSize: 12.sp,
                        ),
                  ),
                ],
              ),
              Column(
                children: [
                  CustomText(
                    "Pending",
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 10.sp,
                        ),
                  ),
                  sizedBoxHeight(height: 4.h),
                  CustomText(
                    target.achived,
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          color: red1,
                          fontSize: 12.sp,
                        ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:vlr/services/constants.dart';
// import 'package:vlr/services/custom_text.dart';
// import 'package:vlr/services/theme.dart';
// import 'package:vlr/views/screens/dashboard/home_screen/widget/this_month_target_section/half_circle_progress.dart';
// import 'package:vlr/views/screens/dashboard/home_screen/widget/this_month_target_section/monthly_target_model.dart';

// class TargetCard extends StatelessWidget {
//   final MonthlyTargetModel target;

//   const TargetCard({
//     super.key,
//     required this.target,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12.h),
//       padding: EdgeInsets.symmetric(
//         vertical: 16.h,
//         horizontal: 12.w,
//       ),
//       decoration: BoxDecoration(
//         border: Border.all(color: greyLight2),
//         borderRadius: BorderRadius.circular(20.r),
//       ),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(6.r),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: target.color,
//                     width: 2,
//                   ),
//                 ),
//                 child: Icon(
//                   target.icon,
//                   color: target.color,
//                   size: 22.sp,
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                       target.title,
//                       style: Helper(context).textTheme.titleMedium,
//                     ),
//                     SizedBox(height: 12.h),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             CustomText(
//                               "Target",
//                               style: Helper(context)
//                                   .textTheme
//                                   .bodyMedium
//                                   ?.copyWith(color: greyDart2),
//                             ),
//                             SizedBox(height: 8.h),
//                             CustomText(
//                               target.target,
//                               style: Helper(context)
//                                   .textTheme
//                                   .titleLarge
//                                   ?.copyWith(
//                                     color: target.color,
//                                     fontSize: 20.sp,
//                                   ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           width: 140.w,
//                           height: 100.h,
//                           child: HalfCircleProgress(
//                             percent: target.percent,
//                             progressColor: target.color,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Divider(
//             color: greyLight3,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 children: [
//                   CustomText(
//                     "Achived",
//                     style: Helper(context).textTheme.bodyLarge?.copyWith(
//                           fontSize: 14.sp,
//                         ),
//                   ),
//                   sizedBoxHeight(height: 4.h),
//                   CustomText(
//                     target.achived,
//                     style: Helper(context).textTheme.titleMedium?.copyWith(
//                           color: Colors.green,
//                           fontSize: 16.sp,
//                         ),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   CustomText(
//                     "Pending",
//                     style: Helper(context).textTheme.bodyLarge?.copyWith(
//                           fontSize: 14.sp,
//                         ),
//                   ),
//                   sizedBoxHeight(height: 4.h),
//                   CustomText(
//                     target.achived,
//                     style: Helper(context).textTheme.titleMedium?.copyWith(
//                           color: red1,
//                           fontSize: 16.sp,
//                         ),
//                   ),
//                 ],
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

