class JobPostHistoryModel {
  int? id;
  String? partnerId;
  String? createdBy;
  String? jobTitle;
  String? jobCode;
  dynamic departmentId;
  dynamic branchId;
  String? employmentType;
  String? experience;
  String? salary;
  String? jobCity;
  String? distance;
  int? vacanciesCount;
  String? referralBudget;
  String? referralAmount;
  String? banner;
  String? applicationDeadline;
  String? jobDescription;
  String? skills;
  String? status;
  String? walletDeducted;
  String? onlinePayable;
  String? transactionId;
  String? createdAt;
  String? updatedAt;
  bool? isWorkFromHome;
  String? salaryMin;
  String? salaryMax;
  String? salaryType;
  List<String>? additionalPerks;
  bool? joiningFeeRequired;
  String? minimumEducation;
  String? englishLevel;
  String? genderPreference;
  InterviewInformationModel? interviewInformation;
  String? expiresAt;
  String? publishedAt;
  String? jobType;
  int? applicationsCount;

  JobPostHistoryModel({
    this.id,
    this.partnerId,
    this.createdBy,
    this.jobTitle,
    this.jobCode,
    this.departmentId,
    this.branchId,
    this.employmentType,
    this.experience,
    this.salary,
    this.jobCity,
    this.distance,
    this.vacanciesCount,
    this.referralBudget,
    this.referralAmount,
    this.banner,
    this.applicationDeadline,
    this.jobDescription,
    this.skills,
    this.status,
    this.walletDeducted,
    this.onlinePayable,
    this.transactionId,
    this.createdAt,
    this.updatedAt,
    this.isWorkFromHome,
    this.salaryMin,
    this.salaryMax,
    this.salaryType,
    this.additionalPerks,
    this.joiningFeeRequired,
    this.minimumEducation,
    this.englishLevel,
    this.genderPreference,
    this.interviewInformation,
    this.expiresAt,
    this.publishedAt,
    this.jobType,
    this.applicationsCount,
  });

  factory JobPostHistoryModel.fromJson(Map<String, dynamic> json) {
    return JobPostHistoryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      partnerId: json['partner_id']?.toString(),
      createdBy: json['created_by']?.toString(),
      jobTitle: json['job_title']?.toString(),
      jobCode: json['job_code']?.toString(),
      departmentId: json['department_id'],
      branchId: json['branch_id'],
      employmentType: json['employment_type']?.toString(),
      experience: json['experience']?.toString(),
      salary: json['salary']?.toString(),
      jobCity: json['job_city']?.toString(),
      distance: json['distance']?.toString(),
      vacanciesCount: json['vacancies_count'] is int
          ? json['vacancies_count']
          : int.tryParse(json['vacancies_count']?.toString() ?? ''),
      referralBudget: json['referral_budget']?.toString(),
      referralAmount: json['referral_amount']?.toString(),
      banner: json['banner']?.toString(),
      applicationDeadline: json['application_deadline']?.toString(),
      jobDescription: json['job_description']?.toString(),
      skills: json['skills']?.toString(),
      status: json['status']?.toString(),
      walletDeducted: json['wallet_deducted']?.toString(),
      onlinePayable: json['online_payable']?.toString(),
      transactionId: json['transaction_id']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      isWorkFromHome: json['is_work_from_home'] is bool
          ? json['is_work_from_home']
          : (json['is_work_from_home'] == 1 || json['is_work_from_home'] == '1' || json['is_work_from_home'] == 'true'),
      salaryMin: json['salary_min']?.toString(),
      salaryMax: json['salary_max']?.toString(),
      salaryType: json['salary_type']?.toString(),
      additionalPerks: json['additional_perks'] != null && json['additional_perks'] is List
          ? List<String>.from(json['additional_perks'].map((x) => x.toString()))
          : [],
      joiningFeeRequired: json['joining_fee_required'] is bool
          ? json['joining_fee_required']
          : (json['joining_fee_required'] == 1 || json['joining_fee_required'] == '1' || json['joining_fee_required'] == 'true'),
      minimumEducation: json['minimum_education']?.toString(),
      englishLevel: json['english_level']?.toString(),
      genderPreference: json['gender_preference']?.toString(),
      interviewInformation: json['interview_information'] != null && json['interview_information'] is Map
          ? InterviewInformationModel.fromJson(Map<String, dynamic>.from(json['interview_information']))
          : null,
      expiresAt: json['expires_at']?.toString(),
      publishedAt: json['published_at']?.toString(),
      jobType: json['job_type']?.toString(),
      applicationsCount: json['applications_count'] is int
          ? json['applications_count']
          : int.tryParse(json['applications_count']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partner_id': partnerId,
      'created_by': createdBy,
      'job_title': jobTitle,
      'job_code': jobCode,
      'department_id': departmentId,
      'branch_id': branchId,
      'employment_type': employmentType,
      'experience': experience,
      'salary': salary,
      'job_city': jobCity,
      'distance': distance,
      'vacancies_count': vacanciesCount,
      'referral_budget': referralBudget,
      'referral_amount': referralAmount,
      'banner': banner,
      'application_deadline': applicationDeadline,
      'job_description': jobDescription,
      'skills': skills,
      'status': status,
      'wallet_deducted': walletDeducted,
      'online_payable': onlinePayable,
      'transaction_id': transactionId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_work_from_home': isWorkFromHome,
      'salary_min': salaryMin,
      'salary_max': salaryMax,
      'salary_type': salaryType,
      'additional_perks': additionalPerks,
      'joining_fee_required': joiningFeeRequired,
      'minimum_education': minimumEducation,
      'english_level': englishLevel,
      'gender_preference': genderPreference,
      'interview_information': interviewInformation?.toJson(),
      'expires_at': expiresAt,
      'published_at': publishedAt,
      'job_type': jobType,
      'applications_count': applicationsCount,
    };
  }
}

class InterviewInformationModel {
  bool? isWalkIn;
  String? contactPreference;

  InterviewInformationModel({
    this.isWalkIn,
    this.contactPreference,
  });

  factory InterviewInformationModel.fromJson(Map<String, dynamic> json) {
    return InterviewInformationModel(
      isWalkIn: json['is_walk_in'] is bool
          ? json['is_walk_in']
          : (json['is_walk_in'] == 1 || json['is_walk_in'] == '1' || json['is_walk_in'] == 'true'),
      contactPreference: json['contact_preference']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_walk_in': isWalkIn,
      'contact_preference': contactPreference,
    };
  }
}
