import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/recruitment_controller.dart';
import 'package:vlr/data/models/response/job_template_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/recruitment/create_job_template_screen.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class JobTemplatesScreen extends StatefulWidget {
  final bool hideAppBar;
  const JobTemplatesScreen({super.key, this.hideAppBar = false});

  @override
  State<JobTemplatesScreen> createState() => _JobTemplatesScreenState();
}

class _JobTemplatesScreenState extends State<JobTemplatesScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<RecruitmentController>().getJobTemplates();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String _stripHtml(String? htmlString) {
    if (htmlString == null || htmlString.isEmpty) return "";
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').trim();
  }

  List<JobTemplateModel> _getFilteredTemplates(List<JobTemplateModel> templates) {
    return templates.where((template) {
      bool matchesCategory = selectedCategory == "All" ||
          (template.category != null &&
              template.category!.toLowerCase() == selectedCategory.toLowerCase());

      String query = searchController.text.trim().toLowerCase();
      bool matchesSearch = query.isEmpty ||
          (template.title != null && template.title!.toLowerCase().contains(query)) ||
          (template.category != null && template.category!.toLowerCase().contains(query)) ||
          (template.overview != null && template.overview!.toLowerCase().contains(query)) ||
          (template.description != null && template.description!.toLowerCase().contains(query));

      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<String> _extractCategories(List<JobTemplateModel> templates) {
    Set<String> categories = {"All"};
    for (var template in templates) {
      if (template.category != null && template.category!.isNotEmpty) {
        categories.add(template.category!);
      }
    }
    return categories.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: widget.hideAppBar
          ? null
          : AppBar(
              backgroundColor: white,
              elevation: 0.5,
              title: CustomText(
                "Job Templates",
                style: Helper(context).textTheme.titleMedium?.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: blackText1,
                    ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: black),
                onPressed: () => pop(context),
              ),
            ),
      body: GetBuilder<RecruitmentController>(builder: (controller) {
        final filteredList = _getFilteredTemplates(controller.jobTemplateList);
        final categories = _extractCategories(controller.jobTemplateList);

        return RefreshIndicator(
          onRefresh: () async {
            await controller.getJobTemplates();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                AppTextFieldWithHeading(
                  controller: searchController,
                  heading: "Search Templates",
                  hindText: "Search by title, category, or skills...",
                  preFixWidget: Icon(Icons.search, color: greyText),
                  onChanged: (val) {
                    setState(() {});
                  },
                ),
                sizedBoxHeight(height: 12),

                // Category Filter Chips
                if (categories.length > 1) ...[
                  SizedBox(
                    height: 38.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => sizedBoxWidth(width: 8.w),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = selectedCategory == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: secondaryColor.withValues(alpha: 0.15),
                          backgroundColor: white,
                          labelStyle: TextStyle(
                            color: isSelected ? secondaryColor : blackText1,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            side: BorderSide(
                              color: isSelected ? secondaryColor : greyLight2,
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => selectedCategory = cat);
                            }
                          },
                        );
                      },
                    ),
                  ),
                  sizedBoxHeight(height: 16),
                ],

                // Content View
                if (controller.isJobTemplatesLoading && controller.jobTemplateList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 80.h),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else if (filteredList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 80.h),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.description_outlined, size: 50.r, color: greyText),
                          sizedBoxHeight(height: 12),
                          CustomText(
                            "No job templates found",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: greyDart2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 16),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return _buildJobTemplateCard(context, item);
                    },
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildJobTemplateCard(BuildContext context, JobTemplateModel item) {
    final String cleanOverview = _stripHtml(item.overview);
    final String cleanDescription = _stripHtml(item.description);

    String minSalaryFormatted = item.defaultSalaryMin != null
        ? PriceConverter.convertRound(item.defaultSalaryMin!)
        : "N/A";
    String maxSalaryFormatted = item.defaultSalaryMax != null
        ? PriceConverter.convertRound(item.defaultSalaryMax!)
        : "N/A";

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Status Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      item.title ?? "Untitled Template",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: blackText1,
                      ),
                    ),
                    if (item.category != null && item.category!.isNotEmpty) ...[
                      sizedBoxHeight(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: secondaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: CustomText(
                          item.category!,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              sizedBoxWidth(width: 8),
              if (item.isActive == true)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: CustomText(
                    "Active",
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          sizedBoxHeight(height: 12),

          // Job Meta Info (Job Type, Salary)
          Row(
            children: [
              if (item.jobType != null && item.jobType!.isNotEmpty) ...[
                Icon(Icons.work_outline_rounded, size: 16.sp, color: primaryColor),
                sizedBoxWidth(width: 4),
                CustomText(
                  item.jobType!,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: blackText1),
                ),
                sizedBoxWidth(width: 16),
              ],
              Icon(Icons.currency_rupee_rounded, size: 16.sp, color: Colors.green),
              sizedBoxWidth(width: 2),
              Expanded(
                child: CustomText(
                  "$minSalaryFormatted - $maxSalaryFormatted",
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.green[800]),
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 12),

          // Overview or Description
          if (cleanOverview.isNotEmpty) ...[
            CustomText(
              cleanOverview,
              style: TextStyle(fontSize: 12.sp, color: greyText, height: 1.4),
              maxLines: 2,
            ),
            sizedBoxHeight(height: 8),
          ] else if (cleanDescription.isNotEmpty) ...[
            CustomText(
              cleanDescription,
              style: TextStyle(fontSize: 12.sp, color: greyText, height: 1.4),
              maxLines: 3,
            ),
            sizedBoxHeight(height: 8),
          ],

          // Screening Questions Section
          if (item.defaultScreeningQuestions != null && item.defaultScreeningQuestions!.isNotEmpty) ...[
            const Divider(),
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.only(bottom: 8.h),
                title: Row(
                  children: [
                    Icon(Icons.quiz_outlined, size: 16.sp, color: secondaryColor),
                    sizedBoxWidth(width: 6),
                    CustomText(
                      "Screening Questions (${item.defaultScreeningQuestions!.length})",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
                children: item.defaultScreeningQuestions!.map((q) {
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: backgroundLight,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: greyLight2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomText(
                                "• ${q.question ?? 'N/A'}",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: blackText1,
                                ),
                              ),
                            ),
                            if (q.required == 1)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: CustomText(
                                  "Required",
                                  style: TextStyle(fontSize: 9.sp, color: Colors.red, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        sizedBoxHeight(height: 4),
                        Row(
                          children: [
                            CustomText(
                              "Type: ${capitalize(q.type ?? 'text')}",
                              style: TextStyle(fontSize: 11.sp, color: greyText),
                            ),
                            if (q.options != null && q.options!.isNotEmpty) ...[
                              sizedBoxWidth(width: 12),
                              Expanded(
                                child: CustomText(
                                  "Options: ${q.options}",
                                  style: TextStyle(fontSize: 11.sp, color: greyDart2),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          sizedBoxHeight(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (item.id != null) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  JobTemplateModel? detail = await Get.find<RecruitmentController>()
                      .getJobTemplateDetails(item.id!);

                  if (context.mounted) Navigator.pop(context);

                  JobTemplateModel finalTemplate = detail ?? item;

                  if (context.mounted) {
                    navigate(
                      context: context,
                      page: CreateJobTemplateScreen(template: finalTemplate),
                    );
                  }
                } else {
                  navigate(
                    context: context,
                    page: CreateJobTemplateScreen(template: item),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              icon: Icon(Icons.post_add_rounded, size: 18.sp, color: white),
              label: CustomText(
                "Use Template to Post Job",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
