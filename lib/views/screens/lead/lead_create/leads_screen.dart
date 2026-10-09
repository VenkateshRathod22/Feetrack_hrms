import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/lead_controller.dart';
import 'package:vlr/data/models/response/lead_model.dart';
import 'package:vlr/data/models/user_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/views/screens/lead/lead_create/lead_create_screen.dart';

class LeadsScreen extends StatefulWidget {
  final bool isTab;
  const LeadsScreen({super.key, this.isTab = false});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LeadController>().getLeads();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = GetBuilder<LeadController>(builder: (leadController) {
      if (leadController.isLoading && leadController.leadsList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (leadController.leadsList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_late_outlined, size: 60.sp, color: grey),
              sizedBoxHeight(height: 16.h),
              CustomText(
                "No leads found",
                style: Helper(context).textTheme.bodyMedium?.copyWith(color: grey),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await leadController.getLeads();
        },
        child: ListView.separated(
          padding: AppConstants.screenPadding,
          itemCount: leadController.leadsList.length,
          separatorBuilder: (context, index) => sizedBoxHeight(height: 12.h),
          itemBuilder: (context, index) {
            LeadModel lead = leadController.leadsList[index];
            return _LeadCard(lead: lead);
          },
        ),
      );
    });

    if (widget.isTab) {
      return content;
    }

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: white,
        title: CustomText(
          "Assigned Leads",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 16.sp,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              navigate(context: context, page: const LeadCreateScreen());
            },
            icon:  Icon(Icons.add_circle_outline, color: primaryColor),
          ),
        ],
      ),
      body: content,
    );
  }
}

class _LeadCard extends StatelessWidget {
  final LeadModel lead;
  const _LeadCard({required this.lead});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (lead.status?.toLowerCase()) {
      case 'new':
        statusColor = primaryColor;
        break;
      case 'first call':
        statusColor = yellow;
        break;
      case 'interested':
        statusColor = organ;
        break;
      case 'meeting scheduled':
        statusColor = purple;
        break;
      case 'customer visit':
        statusColor = tertiaryColor;
        break;
      case 'quotation':
        statusColor = goldColor;
        break;
      case 'negotiation':
        statusColor = punchIn;
        break;
      case 'won':
        statusColor = green;
        break;
      case 'lost':
        statusColor = red;
        break;
      default:
        statusColor = grey;
    }

    String assignedToName = "Unassigned";
    if (lead.assignedTo != null) {
      if (lead.assignedTo is UserModel) {
        assignedToName = (lead.assignedTo as UserModel).name ?? "Unknown";
      } else {
        assignedToName = lead.assignedTo.toString();
      }
    }

    return GestureDetector(
      onTap: () {
        navigate(context: context, page: LeadCreateScreen(lead: lead));
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        lead.customerName ?? "Unknown Customer",
                        style: Helper(context).textTheme.titleSmall?.copyWith(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (lead.businessName != null && lead.businessName!.isNotEmpty)
                        CustomText(
                          lead.businessName!,
                          style: Helper(context).textTheme.bodySmall?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                              ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: CustomText(
                    capitalize(lead.status ?? "New"),
                    style: Helper(context).textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            sizedBoxHeight(height: 8.h),
            Row(
              children: [
                Icon(Icons.phone_android, size: 14.sp, color: grey),
                sizedBoxWidth(width: 4.w),
                CustomText(
                  lead.customerMobile ?? "--",
                  style: Helper(context).textTheme.bodySmall?.copyWith(color: greyText),
                ),
                const Spacer(),
                if (lead.businessAmount != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: CustomText(
                      PriceConverter.convertToNumberFormat(num.tryParse(lead.businessAmount!) ?? 0),
                      style: Helper(context).textTheme.labelSmall?.copyWith(
                            color: green,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                          ),
                    ),
                  ),
              ],
            ),
            sizedBoxHeight(height: 12.h),
            const Divider(),
            sizedBoxHeight(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Assigned To",
                      style: Helper(context).textTheme.bodySmall?.copyWith(color: grey, fontSize: 10.sp),
                    ),
                    CustomText(
                      assignedToName,
                      style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      "Date",
                      style: Helper(context).textTheme.bodySmall?.copyWith(color: grey, fontSize: 10.sp),
                    ),
                    CustomText(
                      lead.createdAt != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(lead.createdAt!)) : "--",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
                    ),
                  ],
                ),
              ],
            ),
            if (lead.notes != null && lead.notes!.isNotEmpty) ...[
              sizedBoxHeight(height: 8.h),
              CustomText(
                "Notes:",
                style: Helper(context).textTheme.bodySmall?.copyWith(color: grey, fontSize: 10.sp),
              ),
              CustomText(
                lead.notes!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Helper(context).textTheme.bodySmall?.copyWith(fontSize: 11.sp),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
