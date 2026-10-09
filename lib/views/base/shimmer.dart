import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vlr/services/theme.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? child
        : Shimmer.fromColors(
      baseColor: shimmerBase,
      highlightColor: shimmerHighlight,
      child: child,
    );
  }
}
