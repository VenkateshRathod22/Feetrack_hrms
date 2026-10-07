import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/lead/lead_create/lead_create_screen.dart';
import 'package:vlr/views/screens/lead/lead_create/leads_screen.dart';

class LeadTabarScreen extends StatelessWidget {
  const LeadTabarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundLight,
        appBar: AppBar(
          elevation: 2,
          centerTitle: true,
          backgroundColor: white,
          title: CustomText(
            "Leads Management",
            style: Helper(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                ),
          ),
          bottom: TabBar(
            labelColor: primaryColor,
            unselectedLabelColor: grey,
            indicatorColor: primaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: Helper(context).textTheme.titleSmall?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
            unselectedLabelStyle: Helper(context).textTheme.titleSmall?.copyWith(
                  fontSize: 14.sp,
                ),
            tabs: const [
              Tab(text: "All Leads"),
              Tab(text: "Add Lead"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LeadsScreen(isTab: true),
            LeadCreateScreen(isTab: true),
          ],
        ),
      ),
    );
  }
}
