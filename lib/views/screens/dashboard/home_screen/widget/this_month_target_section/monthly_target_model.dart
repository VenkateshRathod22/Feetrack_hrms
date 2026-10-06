import 'package:flutter/material.dart';
import 'package:vlr/services/theme.dart';

class MonthlyTargetModel {
  final String title;
  final String target;
  final double percent;
  final IconData icon;
  final Color color;
  final String achived;
  final String pending;

  const MonthlyTargetModel({
    required this.title,
    required this.target,
    required this.percent,
    required this.icon,
    required this.color,
    required this.achived,
    required this.pending,
  });
}

final List<MonthlyTargetModel> monthlyTargets = [
  MonthlyTargetModel(
      title: "Merchant Onboarding (Nos.)",
      target: "150",
      percent: 0.62,
      icon: Icons.group,
      color: tertiaryColor,
      achived: "93",
      pending: "57"),
  MonthlyTargetModel(
      title: "Collection Amount",
      target: "₹1,50,000",
      percent: 0.78,
      icon: Icons.currency_rupee,
      color: deepPurple,
      achived: "93",
      pending: "57"),
];
