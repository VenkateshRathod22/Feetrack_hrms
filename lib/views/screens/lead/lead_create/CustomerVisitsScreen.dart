import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/lead_controller.dart';
import 'package:vlr/data/models/response/customer_visit_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/lead/lead_create/create_customer_visit_screen.dart';
import 'package:vlr/views/screens/lead/lead_create/lead_create_screen.dart';
import 'package:vlr/views/widget/button/appbar_back_button.dart';

class Customervisitsscreen extends StatefulWidget {
  const Customervisitsscreen({super.key});

  @override
  State<Customervisitsscreen> createState() => _CustomervisitsscreenState();
}

class _CustomervisitsscreenState extends State<Customervisitsscreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LeadController>().getCustomerVisits();
    });
  }

  String _formatVisitDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    try {
      // Try parsing ISO format first (e.g., 2026-09-24T13:17:00.000000Z)
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (e) {
      try {
        // Try parsing the human-readable format returned by some endpoints (e.g., Sep 17, 2026)
        DateTime dt = DateFormat("MMM dd, yyyy").parse(dateStr.contains(',') ? dateStr : dateStr.replaceAll('  ', ' '));
        return DateFormat('dd MMM yyyy').format(dt);
      } catch (e2) {
        return dateStr; // Return as is if all parsing fails
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText(
          "Customer Visits",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        leading: const AppBarBackButton(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: () {
          navigate(context: context, page: const CreateCustomerVisitScreen());
        },
        icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white),
        label: CustomText("Schedule Visit", style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
      ),
      body: GetBuilder<LeadController>(builder: (controller) {
        if (controller.isLoading && controller.customerVisitList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.customerVisitList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_off_rounded, size: 64.sp, color: greyLight2),
                sizedBoxHeight(height: 16),
                CustomText("No customer visits found", style: TextStyle(color: greyText)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.getCustomerVisits();
          },
          child: ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: controller.customerVisitList.length,
            separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
            itemBuilder: (context, index) {
              final visit = controller.customerVisitList[index];
              return _buildVisitCard(context, visit);
            },
          ),
        );
      }),
    );
  }

  Widget _buildVisitCard(BuildContext context, CustomerVisitModel visit) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.05),
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
                      visit.lead?.customerName ?? "Unknown Lead",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp, color: blackText1),
                    ),
                    CustomText(
                      visit.lead?.businessName ?? "No Company",
                      style: TextStyle(fontSize: 12.sp, color: primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildStatusBadge(visit.status),
                  sizedBoxHeight(height: 4),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          navigate(context: context, page: CreateCustomerVisitScreen(visit: visit));
                        },
                        icon: Icon(Icons.edit_note_rounded, color: primaryColor, size: 22.sp),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      sizedBoxWidth(width: 8),
                      IconButton(
                        onPressed: () => _confirmDelete(context, visit),
                        icon: Icon(Icons.delete_outline_rounded, color: red, size: 20.sp),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          sizedBoxHeight(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 14.sp, color: greyText),
              sizedBoxWidth(width: 8),
              CustomText(
                _formatVisitDate(visit.visitDate),
                style: TextStyle(fontSize: 13.sp, color: blackText2),
              ),
            ],
          ),
          sizedBoxHeight(height: 8),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 14.sp, color: greyText),
              sizedBoxWidth(width: 8),
              Expanded(
                child: CustomText(
                  visit.location ?? "No location set",
                  style: TextStyle(fontSize: 13.sp, color: greyDart2),
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 12),
          const Divider(),
          sizedBoxHeight(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, size: 14.sp, color: greyText),
              sizedBoxWidth(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Purpose: ${visit.purpose ?? "N/A"}",
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: blackText3),
                    ),
                    if (visit.notes != null && visit.notes!.isNotEmpty)
                      CustomText(
                        visit.notes!,
                        style: TextStyle(fontSize: 11.sp, color: greyText),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 12),
          Row(
            children: [
              Icon(Icons.person_pin_rounded, size: 14.sp, color: greyText),
              sizedBoxWidth(width: 4),
              CustomText(
                "Visited By: ${visit.employee?.name ?? "N/A"}",
                style: TextStyle(fontSize: 11.sp, color: greyDart2, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color color = Colors.blue;
    if (status?.toLowerCase() == 'completed') color = Colors.green;
    if (status?.toLowerCase() == 'scheduled') color = Colors.orange;
    if (status?.toLowerCase() == 'cancelled') color = Colors.red;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        capitalize(status),
        style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _confirmDelete(BuildContext context, CustomerVisitModel visit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const CustomText("Delete Visit"),
        content: CustomText("Are you sure you want to delete the visit for '${visit.lead?.customerName}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomText("Cancel", style: TextStyle(color: grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<LeadController>().deleteCustomerVisit(visit.id!);
            },
            child: const CustomText("Delete", style: TextStyle(color: red)),
          ),
        ],
      ),
    );
  }
}
