// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';

// class HalfCircleProgress extends StatelessWidget {
//   final double percent;
//   final Color progressColor;

//   const HalfCircleProgress({
//     super.key,
//     required this.percent,
//     required this.progressColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRect(
//       child: Align(
//         alignment: Alignment.topCenter,
//         heightFactor: 0.55,
//         child: Stack(
//           children: [
//             SfRadialGauge(
//               axes: [
//                 RadialAxis(
//                   startAngle: 180,
//                   endAngle: 0,
//                   minimum: 0,
//                   maximum: 100,
//                   showTicks: false,
//                   showLabels: false,
//                   canScaleToFit: true,
//                   radiusFactor: 0.95,
//                   axisLineStyle: const AxisLineStyle(
//                     thickness: 12,
//                     thicknessUnit: GaugeSizeUnit.logicalPixel,
//                     color: Color(0xFFE5E7EB),
//                   ),
//                   pointers: [
//                     RangePointer(
//                       value: percent * 100,
//                       width: 12,
//                       sizeUnit: GaugeSizeUnit.logicalPixel,
//                       color: progressColor,
//                       cornerStyle: CornerStyle.bothCurve,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Positioned(
//               bottom: 20.w,
//               left: 50.h,
//               child: Text(
//                 "${(percent * 100).toInt()}%",
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold,
//                   color: progressColor,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HalfCircleProgress extends StatelessWidget {
  final double percent;
  final Color progressColor;

  const HalfCircleProgress({
    super.key,
    required this.percent,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: Alignment.topCenter,
        heightFactor: 0.55,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: 0,
            end: (percent * 100).clamp(0.0, 100.0),
          ),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SfRadialGauge(
                  axes: [
                    RadialAxis(
                      startAngle: 180,
                      endAngle: 0,
                      minimum: 0,
                      maximum: 100,
                      showTicks: false,
                      showLabels: false,
                      canScaleToFit: true,
                      radiusFactor: 0.95,
                      axisLineStyle: const AxisLineStyle(
                        thickness: 8,
                        thicknessUnit: GaugeSizeUnit.logicalPixel,
                        color: Color(0xFFE5E7EB),
                      ),
                      pointers: [
                        RangePointer(
                          value: value,
                          width: 8,
                          sizeUnit: GaugeSizeUnit.logicalPixel,
                          color: progressColor,
                          cornerStyle: CornerStyle.bothCurve,
                          animationDuration: 5000,
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 12.h,
                  child: Text(
                    "${value.toInt()}%",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: progressColor,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
