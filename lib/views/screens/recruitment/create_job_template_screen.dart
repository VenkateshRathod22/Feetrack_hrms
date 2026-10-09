import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/braches_controller.dart';
import 'package:vlr/controllers/recruitment_controller.dart';
import 'package:vlr/data/models/response/job_template_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class CreateJobTemplateScreen extends StatefulWidget {
  final bool hideAppBar;
  final JobTemplateModel? template;

  const CreateJobTemplateScreen({
    super.key,
    this.hideAppBar = false,
    this.template,
  });

  @override
  State<CreateJobTemplateScreen> createState() => _CreateJobTemplateScreenState();
}

class _CreateJobTemplateScreenState extends State<CreateJobTemplateScreen> {
  int _currentStep = 0;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();

  // Step 1 Controllers & State
  String? selectedBranchId;
  late final TextEditingController jobTitleController;
  String selectedEmploymentType = "Full Time";
  bool isNightShift = false;
  String selectedWorkLocationType = "Work From Office";
  late final TextEditingController jobCityController;
  String selectedDistance = "10 km";
  String selectedPayType = "Fixed Only";
  late final TextEditingController minSalaryController;
  late final TextEditingController maxSalaryController;
  late final TextEditingController vacanciesController;
  late final TextEditingController referralBudgetController;
  List<String> selectedPerks = [];
  bool isJoiningFeeRequired = false;

  final List<String> employmentTypes = [
    "Full Time",
    "Part Time",
    "Both (Full-Time And Part-Time)"
  ];

  final List<String> locationTypes = [
    "Work From Office",
    "Work From Home",
    "Field Job"
  ];

  final List<String> distances = [
    "10 km",
    "25 km",
    "Entire City",
    "Pan India"
  ];

  final List<String> payTypes = [
    "Fixed Only",
    "Fixed + Incentive",
    "Incentive Only"
  ];

  final List<String> availablePerks = [
    "Flexible Working Hours",
    "Weekly Payout",
    "Joining Bonus",
    "Health Insurance",
    "Free Meals",
    "Performance Bonus",
    "Travel Allowance"
  ];

  // Step 2 Controllers & State
  String selectedMinimumEducation = "Graduate";
  String selectedEnglishLevel = "Basic English";
  String selectedExperience = "Any";
  String selectedGenderPreference = "Any";
  late final TextEditingController jobDescriptionController;

  final List<String> educationLevels = [
    "10th or Below 10th",
    "12th Pass",
    "Diploma",
    "ITI",
    "Graduate",
    "Post Graduate"
  ];

  final List<String> englishLevels = [
    "No English",
    "Basic English",
    "Good English"
  ];

  final List<String> experienceOptions = [
    "Any",
    "Experienced Only",
    "Fresher Only"
  ];

  final List<String> genderOptions = [
    "Any",
    "Male",
    "Female"
  ];

  // Step 3 Controllers & State
  bool isWalkInInterview = false;
  String selectedCommunicationPreference = "Yes, to myself";

  final List<String> communicationOptions = [
    "Yes, to myself",
    "Yes, to other recruiter",
    "No, I will contact candidates first"
  ];

  // Step 4 State
  String selectedPlan = "Free Plan";
  int? selectedPlanId;

  // App Blue Theme Colors
  static  Color appBluePrimary = primaryColor; // 0xFF021A45
  static const Color appBlueAccent = Color(0xFF0052D9); // Vibrant Blue
  static const Color appBlueLight = Color(0xFFEFF6FF); // Light blue tint
  static const Color appBlueBorder = Color(0xFFBFDBFE); // Soft blue border
  static const Color cardBorderColor = Color(0xFFE2E8F0); // Light slate border

  @override
  void initState() {
    super.initState();

    final t = widget.template;
    jobTitleController = TextEditingController(text: t?.title ?? "");
    jobCityController = TextEditingController(text: t?.jobCity ?? "");
    minSalaryController = TextEditingController(text: t?.defaultSalaryMin ?? "");
    maxSalaryController = TextEditingController(text: t?.defaultSalaryMax ?? "");
    vacanciesController = TextEditingController(text: "1");
    referralBudgetController = TextEditingController(text: "0");

    if (t != null) {
      if (t.jobType != null && t.jobType!.isNotEmpty) {
        if (locationTypes.contains(t.jobType)) {
          selectedWorkLocationType = t.jobType!;
        } else if (employmentTypes.contains(t.jobType)) {
          selectedEmploymentType = t.jobType!;
        } else if (t.jobType!.toLowerCase().contains("full")) {
          selectedEmploymentType = "Full Time";
        } else if (t.jobType!.toLowerCase().contains("part")) {
          selectedEmploymentType = "Part Time";
        }
      }

      if (t.distance != null && t.distance!.isNotEmpty) {
        if (distances.contains(t.distance)) {
          selectedDistance = t.distance!;
        }
      }

      if (t.salaryType != null && t.salaryType!.isNotEmpty) {
        final match = payTypes.firstWhereOrNull(
          (e) => e.toLowerCase() == t.salaryType!.toLowerCase(),
        );
        if (match != null) selectedPayType = match;
      }

      if (t.minimumEducation != null && t.minimumEducation!.isNotEmpty) {
        final match = educationLevels.firstWhereOrNull(
          (e) => e.toLowerCase() == t.minimumEducation!.toLowerCase(),
        );
        if (match != null) selectedMinimumEducation = match;
      }

      if (t.englishLevel != null && t.englishLevel!.isNotEmpty) {
        final match = englishLevels.firstWhereOrNull(
          (e) => e.toLowerCase() == t.englishLevel!.toLowerCase(),
        );
        if (match != null) selectedEnglishLevel = match;
      }

      if (t.genderPreference != null && t.genderPreference!.isNotEmpty) {
        final match = genderOptions.firstWhereOrNull(
          (e) => e.toLowerCase() == t.genderPreference!.toLowerCase(),
        );
        if (match != null) selectedGenderPreference = match;
      }

      if (t.joiningFeeRequired != null) {
        isJoiningFeeRequired = t.joiningFeeRequired!;
      }

      if (t.additionalPerks != null && t.additionalPerks!.isNotEmpty) {
        selectedPerks = t.additionalPerks!.map((e) => e.toString()).toList();
      }

      String desc = _stripHtml(t.description ?? "");
      String overview = _stripHtml(t.overview ?? "");
      List<String> descParts = [];
      if (overview.isNotEmpty) descParts.add(overview);
      if (desc.isNotEmpty && desc != overview) descParts.add(desc);
      jobDescriptionController = TextEditingController(text: descParts.join("\n\n"));
    } else {
      jobDescriptionController = TextEditingController();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BrachesController>().getBranchesList();
      Get.find<RecruitmentController>().getJobPlans();
    });
  }

  String _stripHtml(String html) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return html.replaceAll(exp, '').trim();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    jobTitleController.dispose();
    jobCityController.dispose();
    minSalaryController.dispose();
    maxSalaryController.dispose();
    vacanciesController.dispose();
    referralBudgetController.dispose();
    jobDescriptionController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  double get estimatedRewardPerHire {
    double budget = double.tryParse(referralBudgetController.text) ?? 0;
    int vacancies = int.tryParse(vacanciesController.text) ?? 1;
    if (vacancies <= 0) vacancies = 1;
    return budget / vacancies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: widget.hideAppBar
          ? null
          : AppBar(
              backgroundColor: white,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Column(
                children: [
                  CustomText(
                    "Post a New Job",
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: appBluePrimary,
                        ),
                  ),
                  sizedBoxHeight(height: 2),
                  CustomText(
                    "Step ${_currentStep + 1} of 4",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: appBlueAccent,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              leading: Container(
                margin: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: appBlueLight,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon:  Icon(Icons.arrow_back_rounded, color: appBluePrimary, size: 20),
                  onPressed: () {
                    if (_currentStep > 0) {
                      setState(() => _currentStep--);
                      _scrollToTop();
                    } else {
                      pop(context);
                    }
                  },
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  color: cardBorderColor,
                  height: 1.0,
                ),
              ),
            ),
      body: GetBuilder<RecruitmentController>(builder: (recruitmentController) {
        return SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildModernStepper(),
              sizedBoxHeight(height: 20),
              if (_currentStep == 0) _buildStep1JobDetails(),
              if (_currentStep == 1) _buildStep2Requirements(),
              if (_currentStep == 2) _buildStep3Interviewer(),
              if (_currentStep == 3) _buildStep4Publish(recruitmentController),
              sizedBoxHeight(height: 30),
            ],
          ),
        );
      }),
    );
  }

  // Modern App Blue Stepper
  Widget _buildModernStepper() {
    final List<Map<String, dynamic>> stepInfo = [
      {"title": "Job Details", "icon": Icons.work_outline_rounded},
      {"title": "Requirements", "icon": Icons.fact_check_outlined},
      {"title": "Interviewer", "icon": Icons.contacts_outlined},
      {"title": "Publish", "icon": Icons.rocket_launch_outlined},
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: appBluePrimary.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: List.generate(stepInfo.length, (index) {
          bool isDone = index < _currentStep;
          bool isActive = index == _currentStep;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (index < _currentStep) {
                  setState(() => _currentStep = index);
                  _scrollToTop();
                }
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      // Left connecting line
                      if (index != 0)
                        Expanded(
                          child: Container(
                            height: 3.h,
                            decoration: BoxDecoration(
                              color: index <= _currentStep ? appBlueAccent : const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),

                      // Circle Badge
                      Container(
                        width: 32.r,
                        height: 32.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isActive
                              ?  LinearGradient(
                                  colors: [appBluePrimary, appBlueAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: isDone
                              ? appBlueLight
                              : (!isActive ? white : null),
                          border: Border.all(
                            color: isDone
                                ? appBlueAccent
                                : (isActive ? appBlueAccent : const Color(0xFFCBD5E1)),
                            width: isActive ? 2.5 : 1.5,
                          ),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: appBlueAccent.withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Center(
                          child: isDone
                              ? Icon(Icons.check_rounded, size: 18.r, color: appBlueAccent)
                              : Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isActive ? Colors.white : greyDart3,
                                  ),
                                ),
                        ),
                      ),

                      // Right connecting line
                      if (index != stepInfo.length - 1)
                        Expanded(
                          child: Container(
                            height: 3.h,
                            decoration: BoxDecoration(
                              color: index < _currentStep ? appBlueAccent : const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),
                    ],
                  ),
                  sizedBoxHeight(height: 7),
                  Text(
                    stepInfo[index]["title"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: isActive ? FontWeight.w700 : (isDone ? FontWeight.w600 : FontWeight.w500),
                      color: isActive ? appBlueAccent : (isDone ? appBluePrimary : greyText),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // STEP 1: Job Details
  Widget _buildStep1JobDetails() {
    return Form(
      key: _formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            title: "Job Details",
            subtitle: "Provide essential role specifications to reach the most qualified talent.",
            icon: Icons.work_rounded,
          ),
          sizedBoxHeight(height: 16),

          _buildSectionCard(
            title: "Basic Role Info",
            icon: Icons.badge_outlined,
            children: [
              // Branch Selection
              GetBuilder<BrachesController>(builder: (branchCtrl) {
                return _buildDropdown(
                  "Branch",
                  selectedBranchId,
                  branchCtrl.branchList
                      .map((b) => DropdownMenuItem(
                            value: b.id.toString(),
                            child: Text(b.name ?? "Branch"),
                          ))
                      .toList(),
                  (val) => setState(() => selectedBranchId = val),
                  isRequired: true,
                  hintText: "Select Branch (Default: Main Branch)",
                );
              }),
              sizedBoxHeight(height: 16),

              // Job Title
              AppTextFieldWithHeading(
                heading: "Job Title / Designation",
                hindText: "e.g. Senior Accountant, Flutter Developer",
                controller: jobTitleController,
                isRequired: true,
                bgColor: white,
                borderColor: cardBorderColor,
                preFixWidget: Icon(Icons.work_outline_rounded, color: appBlueAccent, size: 20),
                validator: (v) => (v == null || v.trim().isEmpty) ? "Job title is required" : null,
              ),
              sizedBoxHeight(height: 16),

              // Type of Job
              _buildLabelWithAsterisk("Type of Job"),
              sizedBoxHeight(height: 8),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: employmentTypes.map((type) {
                  bool isSelected = selectedEmploymentType == type;
                  return _buildCustomChoiceChip(
                    label: type,
                    isSelected: isSelected,
                    onTap: () => setState(() => selectedEmploymentType = type),
                  );
                }).toList(),
              ),
              sizedBoxHeight(height: 16),

              // Night shift container toggle
              GestureDetector(
                onTap: () => setState(() => isNightShift = !isNightShift),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isNightShift ? appBlueLight : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: isNightShift ? appBlueBorder : cardBorderColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: isNightShift ? appBlueAccent : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.nights_stay_rounded,
                          size: 16.r,
                          color: isNightShift ? Colors.white : greyDart2,
                        ),
                      ),
                      sizedBoxWidth(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              "Night Shift Job",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: isNightShift ? appBluePrimary : blackText1,
                              ),
                            ),
                            CustomText(
                              "Candidates will be working during night/rotational hours",
                              style: TextStyle(fontSize: 11.sp, color: greyText),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: isNightShift,
                        activeThumbColor: appBlueAccent,
                        activeTrackColor: appBlueBorder,
                        onChanged: (val) => setState(() => isNightShift = val),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 16),

          // Location Section Card
          _buildSectionCard(
            title: "Work Location",
            icon: Icons.location_on_outlined,
            children: [
              _buildLabelWithAsterisk("Work Location Type"),
              sizedBoxHeight(height: 8),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: locationTypes.map((loc) {
                  bool isSelected = selectedWorkLocationType == loc;
                  return _buildCustomChoiceChip(
                    label: loc,
                    isSelected: isSelected,
                    onTap: () => setState(() => selectedWorkLocationType = loc),
                  );
                }).toList(),
              ),
              sizedBoxHeight(height: 16),

              AppTextFieldWithHeading(
                heading: "Job City / Location",
                hindText: "e.g. Mumbai, Delhi, Bengaluru",
                controller: jobCityController,
                bgColor: white,
                borderColor: cardBorderColor,
                preFixWidget: Icon(Icons.location_city_rounded, color: appBlueAccent, size: 20),
              ),
              sizedBoxHeight(height: 16),

              _buildLabel("Hiring Radius / Distance"),
              sizedBoxHeight(height: 8),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: distances.map((dist) {
                  bool isSelected = selectedDistance == dist;
                  return _buildCustomChoiceChip(
                    label: dist,
                    isSelected: isSelected,
                    onTap: () => setState(() => selectedDistance = dist),
                  );
                }).toList(),
              ),
            ],
          ),
          sizedBoxHeight(height: 16),

          // Compensation Section Card
          _buildSectionCard(
            title: "Compensation & Openings",
            icon: Icons.payments_outlined,
            children: [
              _buildLabelWithAsterisk("Pay Structure"),
              sizedBoxHeight(height: 8),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: payTypes.map((pay) {
                  bool isSelected = selectedPayType == pay;
                  return _buildCustomChoiceChip(
                    label: pay,
                    isSelected: isSelected,
                    onTap: () => setState(() => selectedPayType = pay),
                  );
                }).toList(),
              ),
              sizedBoxHeight(height: 16),

              Row(
                children: [
                  Expanded(
                    child: AppTextFieldWithHeading(
                      heading: "Min Salary (₹)",
                      hindText: "15,000",
                      controller: minSalaryController,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                      bgColor: white,
                      borderColor: cardBorderColor,
                      prefixText: "₹ ",
                      validator: (v) => (v == null || v.trim().isEmpty) ? "Required" : null,
                    ),
                  ),
                  sizedBoxWidth(width: 12),
                  Expanded(
                    child: AppTextFieldWithHeading(
                      heading: "Max Salary (₹)",
                      hindText: "30,000",
                      controller: maxSalaryController,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                      bgColor: white,
                      borderColor: cardBorderColor,
                      prefixText: "₹ ",
                      validator: (v) => (v == null || v.trim().isEmpty) ? "Required" : null,
                    ),
                  ),
                ],
              ),
              sizedBoxHeight(height: 16),

              Row(
                children: [
                  Expanded(
                    child: AppTextFieldWithHeading(
                      heading: "Number of Openings",
                      hindText: "1",
                      controller: vacanciesController,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                      bgColor: white,
                      borderColor: cardBorderColor,
                      onChanged: (_) => setState(() {}),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return "Required";
                        int? num = int.tryParse(v);
                        if (num == null || num < 1) return "Min 1";
                        return null;
                      },
                    ),
                  ),
                  sizedBoxWidth(width: 12),
                  Expanded(
                    child: AppTextFieldWithHeading(
                      heading: "Referral Budget (₹)",
                      hindText: "0",
                      controller: referralBudgetController,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                      bgColor: white,
                      borderColor: cardBorderColor,
                      prefixText: "₹ ",
                      onChanged: (_) => setState(() {}),
                      validator: (v) => (v == null || v.trim().isEmpty) ? "Required" : null,
                    ),
                  ),
                ],
              ),
              sizedBoxHeight(height: 12),

              // Highlighted Calculation Banner
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: appBlueBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: const BoxDecoration(
                        color: appBlueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.stars_rounded, size: 18, color: Colors.white),
                    ),
                    sizedBoxWidth(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            "Referral Reward per Hire",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: appBluePrimary.withValues(alpha: 0.8),
                            ),
                          ),
                          CustomText(
                            "₹${estimatedRewardPerHire.toStringAsFixed(2)} / hire",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              color: appBlueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 16),

          // Additional Perks Card
          _buildSectionCard(
            title: "Perks & Joining Terms",
            icon: Icons.card_giftcard_outlined,
            children: [
              _buildLabel("Do you offer any additional perks?"),
              sizedBoxHeight(height: 8),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: availablePerks.map((perk) {
                  bool isSelected = selectedPerks.contains(perk);
                  return FilterChip(
                    label: Text(perk),
                    avatar: Icon(
                      isSelected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                      size: 16.r,
                      color: isSelected ? appBlueAccent : greyDart3,
                    ),
                    selected: isSelected,
                    selectedColor: appBlueLight,
                    backgroundColor: white,
                    labelStyle: TextStyle(
                      color: isSelected ? appBlueAccent : blackText1,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      side: BorderSide(
                        color: isSelected ? appBlueAccent : cardBorderColor,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedPerks.add(perk);
                        } else {
                          selectedPerks.remove(perk);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              sizedBoxHeight(height: 18),

              _buildLabelWithAsterisk("Is any joining fee or security deposit required?"),
              sizedBoxHeight(height: 8),
              Row(
                children: [
                  _buildChoiceButton("Yes", isJoiningFeeRequired, () => setState(() => isJoiningFeeRequired = true)),
                  sizedBoxWidth(width: 12),
                  _buildChoiceButton("No", !isJoiningFeeRequired, () => setState(() => isJoiningFeeRequired = false)),
                ],
              ),
            ],
          ),
          sizedBoxHeight(height: 24),

          _buildNextButton(
            label: "Continue to Requirements",
            onTap: () {
              if (_formKey1.currentState!.validate()) {
                setState(() => _currentStep = 1);
                _scrollToTop();
              } else {
                showToast(message: "Please fill all required fields", toastType: ToastType.warning);
              }
            },
          ),
        ],
      ),
    );
  }

  // STEP 2: Basic Requirements
  Widget _buildStep2Requirements() {
    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            title: "Candidate Requirements",
            subtitle: "Specify required education, skills, and qualifications to filter right applicants.",
            icon: Icons.fact_check_rounded,
          ),
          sizedBoxHeight(height: 16),

          _buildSectionCard(
            title: "Eligibility Criteria",
            icon: Icons.school_outlined,
            children: [
              // Minimum Education
              _buildLabelWithAsterisk("Minimum Education Required"),
              sizedBoxHeight(height: 8),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: educationLevels.map((edu) {
                  bool isSelected = selectedMinimumEducation == edu;
                  return _buildCustomChoiceChip(
                    label: edu,
                    isSelected: isSelected,
                    onTap: () => setState(() => selectedMinimumEducation = edu),
                  );
                }).toList(),
              ),
              sizedBoxHeight(height: 16),

              // English level
              _buildLabelWithAsterisk("English Proficiency"),
              sizedBoxHeight(height: 8),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: englishLevels.map((eng) {
                  bool isSelected = selectedEnglishLevel == eng;
                  return _buildCustomChoiceChip(
                    label: eng,
                    isSelected: isSelected,
                    onTap: () => setState(() => selectedEnglishLevel = eng),
                  );
                }).toList(),
              ),
              sizedBoxHeight(height: 16),

              // Total Experience required
              _buildLabelWithAsterisk("Required Experience"),
              sizedBoxHeight(height: 8),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: experienceOptions.map((exp) {
                  bool isSelected = selectedExperience == exp;
                  return _buildCustomChoiceChip(
                    label: exp,
                    isSelected: isSelected,
                    onTap: () => setState(() => selectedExperience = exp),
                  );
                }).toList(),
              ),
              sizedBoxHeight(height: 16),

              // Gender Preference
              _buildLabel("Gender Preference"),
              sizedBoxHeight(height: 8),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: genderOptions.map((gender) {
                  bool isSelected = selectedGenderPreference == gender;
                  return _buildCustomChoiceChip(
                    label: gender,
                    isSelected: isSelected,
                    onTap: () => setState(() => selectedGenderPreference = gender),
                  );
                }).toList(),
              ),
            ],
          ),
          sizedBoxHeight(height: 16),

          // Job Description Card
          _buildSectionCard(
            title: "Job Description & Responsibilities",
            icon: Icons.description_outlined,
            children: [
              AppTextFieldWithHeading(
                heading: "Job Description",
                hindText: "Enter comprehensive job duties, responsibilities, prerequisites and benefits...",
                controller: jobDescriptionController,
                maxLines: 6,
                bgColor: white,
                borderColor: cardBorderColor,
              ),
            ],
          ),
          sizedBoxHeight(height: 24),

          _buildNavigationButtons(
            onBack: () {
              setState(() => _currentStep = 0);
              _scrollToTop();
            },
            onNext: () {
              if (_formKey2.currentState!.validate()) {
                setState(() => _currentStep = 2);
                _scrollToTop();
              }
            },
            nextLabel: "Continue to Interviewer",
          ),
        ],
      ),
    );
  }

  // STEP 3: Interviewer
  Widget _buildStep3Interviewer() {
    return Form(
      key: _formKey3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            title: "Interview & Communication",
            subtitle: "Define interview mode and how candidates should connect after applying.",
            icon: Icons.contacts_rounded,
          ),
          sizedBoxHeight(height: 16),

          _buildSectionCard(
            title: "Interview Format",
            icon: Icons.meeting_room_outlined,
            children: [
              _buildLabelWithAsterisk("Is this a walk-in interview?"),
              sizedBoxHeight(height: 8),
              Row(
                children: [
                  _buildChoiceButton("Yes (Walk-in)", isWalkInInterview, () => setState(() => isWalkInInterview = true)),
                  sizedBoxWidth(width: 12),
                  _buildChoiceButton("No (Scheduled)", !isWalkInInterview, () => setState(() => isWalkInInterview = false)),
                ],
              ),
            ],
          ),
          sizedBoxHeight(height: 16),

          _buildSectionCard(
            title: "Candidate Contact Preferences",
            icon: Icons.phone_in_talk_outlined,
            children: [
              CustomText(
                "Do you want candidates to contact you via Call / WhatsApp after applying? *",
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: blackText1),
              ),
              sizedBoxHeight(height: 12),

              Column(
                children: communicationOptions.map((opt) {
                  bool isSelected = selectedCommunicationPreference == opt;
                  return GestureDetector(
                    onTap: () => setState(() => selectedCommunicationPreference = opt),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isSelected ? appBlueLight : white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected ? appBlueAccent : cardBorderColor,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                            color: isSelected ? appBlueAccent : greyDart3,
                            size: 20.r,
                          ),
                          sizedBoxWidth(width: 12),
                          Expanded(
                            child: Text(
                              opt,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? appBluePrimary : blackText1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          sizedBoxHeight(height: 24),

          _buildNavigationButtons(
            onBack: () {
              setState(() => _currentStep = 1);
              _scrollToTop();
            },
            onNext: () {
              setState(() => _currentStep = 3);
              _scrollToTop();
            },
            nextLabel: "Continue to Select Plan",
          ),
        ],
      ),
    );
  }

  // STEP 4: Select Plan & Publish
  Widget _buildStep4Publish(RecruitmentController recruitmentController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          title: "Select Plan & Publish",
          subtitle: "Choose an optimal visibility plan to maximize qualified candidate reach.",
          icon: Icons.rocket_launch_rounded,
        ),
        sizedBoxHeight(height: 16),

        if (recruitmentController.isJobPlansLoading)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: const Center(
              child: CircularProgressIndicator(color: appBlueAccent),
            ),
          )
        else if (recruitmentController.jobPlanList.isEmpty)
          Container(
            padding: EdgeInsets.all(24.r),
            width: double.infinity,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: cardBorderColor),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.inventory_2_outlined, size: 40.r, color: greyText),
                  sizedBoxHeight(height: 8),
                  Text(
                    "No job plans available at the moment.",
                    style: TextStyle(fontSize: 14.sp, color: greyText, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: recruitmentController.jobPlanList.map((plan) {
              bool isSelected = (selectedPlanId != null && selectedPlanId == plan.id) ||
                  (selectedPlanId == null && selectedPlan == plan.name);

              List<String> features = [];
              if (plan.validityDays != null) {
                features.add("${plan.validityDays} Days Active Visibility");
              }
              if (plan.jobLimit == null) {
                features.add("Unlimited Job Postings");
              } else {
                features.add("${plan.jobLimit} Jobs Post Limit");
              }
              features.add("Instant Candidate Alert Notifications");
              features.add("Direct WhatsApp & Call Connect");

              return Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: _buildModernPlanCard(
                  title: plan.name ?? "Standard Plan",
                  price: "₹${plan.price ?? 0}",
                  features: features,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      selectedPlanId = plan.id;
                      selectedPlan = plan.name ?? "";
                    });
                  },
                  isRecommended: plan.name?.toLowerCase().contains("recommended") == true ||
                      plan.name?.toLowerCase().contains("premium") == true ||
                      plan.name?.toLowerCase().contains("unlimited") == true ||
                      plan.price != null && (double.tryParse(plan.price.toString()) ?? 0) > 0,
                ),
              );
            }).toList(),
          ),

        sizedBoxHeight(height: 24),

        _buildNavigationButtons(
          onBack: () {
            setState(() => _currentStep = 2);
            _scrollToTop();
          },
          onNext: () => _submitJobPost(recruitmentController),
          nextLabel: "Publish Job Now",
          isPublish: true,
          isLoading: recruitmentController.isLoading,
        ),
      ],
    );
  }

  // Modern SaaS Style Plan Card
  Widget _buildModernPlanCard({
    required String title,
    required String price,
    required List<String> features,
    required bool isSelected,
    required VoidCallback onTap,
    bool isRecommended = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected ? appBlueAccent : cardBorderColor,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected ? appBlueAccent.withValues(alpha: 0.12) : appBluePrimary.withValues(alpha: 0.04),
                  blurRadius: isSelected ? 12 : 8,
                  offset: const Offset(0, 3),
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
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: appBluePrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? appBlueAccent : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? appBlueAccent : const Color(0xFFCBD5E1),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 14.r,
                        color: isSelected ? Colors.white : Colors.transparent,
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w900,
                        color: appBlueAccent,
                        letterSpacing: -0.5,
                      ),
                    ),
                    sizedBoxWidth(width: 6),
                    Text(
                      "/ posting",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: greyText,
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 14),
                Container(
                  height: 1,
                  color: cardBorderColor,
                ),
                sizedBoxHeight(height: 12),
                Column(
                  children: features.map((f) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(3.r),
                            decoration: const BoxDecoration(
                              color: appBlueLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              size: 14,
                              color: appBlueAccent,
                            ),
                          ),
                          sizedBoxWidth(width: 10),
                          Expanded(
                            child: Text(
                              f,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: blackText1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          if (isRecommended)
            Positioned(
              top: -10.h,
              right: 18.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 12, color: Colors.white),
                    sizedBoxWidth(width: 4),
                    Text(
                      "RECOMMENDED",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _submitJobPost(RecruitmentController controller) {
    if (jobTitleController.text.trim().isEmpty) {
      showToast(message: "Job Title is required", toastType: ToastType.error);
      setState(() => _currentStep = 0);
      return;
    }

    final Map<String, dynamic> bodyMap = {
      "job_title": jobTitleController.text.trim(),
      "employment_type": selectedEmploymentType,
      "job_type": selectedWorkLocationType,
      "is_work_from_home": selectedWorkLocationType == "Work From Home" ? "1" : "0",
      "job_city": jobCityController.text.trim(),
      "distance": selectedDistance,
      "salary_type": selectedPayType,
      "salary_min": minSalaryController.text.trim(),
      "salary_max": maxSalaryController.text.trim(),
      "vacancies_count": vacanciesController.text.trim().isEmpty ? "1" : vacanciesController.text.trim(),
      "referral_budget": referralBudgetController.text.trim().isEmpty ? "0" : referralBudgetController.text.trim(),
      "joining_fee_required": isJoiningFeeRequired ? "1" : "0",
      "minimum_education": selectedMinimumEducation,
      "english_level": selectedEnglishLevel,
      "gender_preference": selectedGenderPreference,
      "job_description": jobDescriptionController.text.trim(),
      "plan": selectedPlan,
    };

    if (selectedPlanId != null) {
      bodyMap["plan_id"] = selectedPlanId.toString();
    }

    if (selectedBranchId != null && selectedBranchId!.isNotEmpty) {
      bodyMap["branch_id"] = selectedBranchId;
    }

    if (selectedPerks.isNotEmpty) {
      for (int i = 0; i < selectedPerks.length; i++) {
        bodyMap["additional_perks[$i]"] = selectedPerks[i];
      }
    }

    bodyMap["interview_information[0][is_walk_in]"] = isWalkInInterview ? "1" : "0";
    bodyMap["interview_information[0][communication_preference]"] = selectedCommunicationPreference;

    final FormData formData = FormData(bodyMap);

    controller.createJobPost(formData).then((res) {
      if (res.isSuccess) {
        showToast(message: res.message, toastType: ToastType.success);
        if (mounted) pop(context);
      } else {
        showToast(message: res.message, toastType: ToastType.error);
      }
    });
  }

  // Reusable Helper UI Widgets
  Widget _buildStepHeader({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: cardBorderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: appBlueLight,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: appBlueBorder),
            ),
            child: Icon(icon, color: appBlueAccent, size: 22.r),
          ),
          sizedBoxWidth(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: appBluePrimary,
                  ),
                ),
                sizedBoxHeight(height: 3),
                CustomText(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: greyText,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: appBluePrimary.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: appBlueAccent, size: 18.r),
              sizedBoxWidth(width: 8),
              CustomText(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: appBluePrimary,
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 12),
          Container(
            height: 1,
            color: cardBorderColor,
          ),
          sizedBoxHeight(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: blackText1,
      ),
    );
  }

  Widget _buildLabelWithAsterisk(String text) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: blackText1,
          ),
        ),
        Text(" *", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red)),
      ],
    );
  }

  Widget _buildCustomChoiceChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: isSelected ? appBlueLight : white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? appBlueAccent : cardBorderColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: appBlueAccent.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? appBlueAccent : blackText1,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceButton(String text, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 11.h),
          decoration: BoxDecoration(
            color: isSelected ? appBlueLight : white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isSelected ? appBlueAccent : cardBorderColor,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? appBlueAccent : blackText1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient:  LinearGradient(
          colors: [appBluePrimary, appBlueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: appBlueAccent.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              sizedBoxWidth(width: 8),
              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons({
    required VoidCallback onBack,
    required VoidCallback onNext,
    required String nextLabel,
    bool isPublish = false,
    bool isLoading = false,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 50.h,
            child: OutlinedButton.icon(
              onPressed: onBack,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFCBD5E1)),
                backgroundColor: white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              icon:  Icon(Icons.arrow_back_rounded, size: 16, color: appBluePrimary),
              label: CustomText(
                "Back",
                style: TextStyle(
                  color: appBluePrimary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        sizedBoxWidth(width: 12),
        Expanded(
          flex: 2,
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                colors: isPublish
                    ? [const Color(0xFF0E9A41), const Color(0xFF16A34A)]
                    : [appBluePrimary, appBlueAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isPublish ? const Color(0xFF16A34A) : appBlueAccent).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: isLoading ? null : onNext,
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isPublish) ...[
                              Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 18),
                              sizedBoxWidth(width: 8),
                            ],
                            CustomText(
                              nextLabel,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                            if (!isPublish) ...[
                              sizedBoxWidth(width: 8),
                              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                            ],
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<DropdownMenuItem<String>> items,
    Function(String?) onChanged, {
    bool isRequired = false,
    String? hintText,
  }) {
    String? validatedValue;
    if (value != null && items.any((item) => item.value == value)) {
      validatedValue = value;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isRequired) _buildLabelWithAsterisk(label) else _buildLabel(label),
        SizedBox(height: 7.w),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: validatedValue,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: appBlueAccent),
          hint: hintText != null
              ? Text(
                  hintText,
                  style: TextStyle(fontSize: 12.sp, color: greyText),
                )
              : null,
          style: TextStyle(fontSize: 13.sp, color: blackText1, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            filled: true,
            fillColor: white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: cardBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: cardBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: appBlueAccent, width: 1.5),
            ),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
