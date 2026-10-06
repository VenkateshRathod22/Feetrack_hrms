class AppliedJobModel {
  final int? id;
  final int? postId;
  final String? referralId;
  final String? referralCode;
  final String? applyUserId;
  final String? designation;
  final String? address;
  final String? resume;
  final String? resumeUrl;
  final String? educationLevel;
  final String? status;
  final String? remark;
  final String? createdAt;
  final String? updatedAt;
  final String? experienceYears;
  final String? englishProficiency;
  final dynamic age;
  final String? gender;
  final dynamic screeningAnswers;
  final AppliedJobPostModel? jobPost;
  final AppliedJobApplicantModel? applicant;
  final dynamic referral;

  AppliedJobModel({
    this.id,
    this.postId,
    this.referralId,
    this.referralCode,
    this.applyUserId,
    this.designation,
    this.address,
    this.resume,
    this.resumeUrl,
    this.educationLevel,
    this.status,
    this.remark,
    this.createdAt,
    this.updatedAt,
    this.experienceYears,
    this.englishProficiency,
    this.age,
    this.gender,
    this.screeningAnswers,
    this.jobPost,
    this.applicant,
    this.referral,
  });

  // Convenience helper getters
  String get displayJobTitle => jobPost?.jobTitle ?? designation ?? "Job Position";
  String get displayJobCode => jobPost?.jobCode ?? "";
  String get displayApplicantName => applicant?.name ?? "Applicant";
  String get displayApplicantEmail => applicant?.email ?? "";
  String get displayApplicantMobile => applicant?.mobile ?? "";
  String? get displayApplicantImage => applicant?.profileImageUrl;
  String get displayCity => jobPost?.jobCity ?? address ?? "";
  String get displayEmploymentType => jobPost?.employmentType ?? "";
  String get displayBranchName => jobPost?.branch?.name ?? "";
  String get displaySalary {
    if (jobPost?.salaryMin != null && jobPost?.salaryMax != null) {
      return "₹${jobPost!.salaryMin} - ₹${jobPost!.salaryMax}";
    } else if (jobPost?.salaryMin != null) {
      return "₹${jobPost!.salaryMin}";
    } else if (jobPost?.salary != null) {
      return "${jobPost!.salary}";
    }
    return "Not Disclosed";
  }

  factory AppliedJobModel.fromJson(Map<String, dynamic> json) => AppliedJobModel(
        id: json["id"] is int ? json["id"] : int.tryParse(json["id"]?.toString() ?? ""),
        postId: json["post_id"] is int ? json["post_id"] : int.tryParse(json["post_id"]?.toString() ?? ""),
        referralId: json["referral_id"]?.toString(),
        referralCode: json["referral_code"]?.toString(),
        applyUserId: json["apply_user_id"]?.toString(),
        designation: json["designation"]?.toString(),
        address: json["address"]?.toString(),
        resume: json["resume"]?.toString(),
        resumeUrl: json["resume_url"]?.toString(),
        educationLevel: json["education_level"]?.toString(),
        status: json["status"]?.toString(),
        remark: json["remark"]?.toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        experienceYears: json["experience_years"]?.toString(),
        englishProficiency: json["english_proficiency"]?.toString(),
        age: json["age"],
        gender: json["gender"]?.toString(),
        screeningAnswers: json["screening_answers"],
        jobPost: json["job_post"] != null && json["job_post"] is Map<String, dynamic>
            ? AppliedJobPostModel.fromJson(json["job_post"])
            : null,
        applicant: json["applicant"] != null && json["applicant"] is Map<String, dynamic>
            ? AppliedJobApplicantModel.fromJson(json["applicant"])
            : null,
        referral: json["referral"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "referral_id": referralId,
        "referral_code": referralCode,
        "apply_user_id": applyUserId,
        "designation": designation,
        "address": address,
        "resume": resume,
        "resume_url": resumeUrl,
        "education_level": educationLevel,
        "status": status,
        "remark": remark,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "experience_years": experienceYears,
        "english_proficiency": englishProficiency,
        "age": age,
        "gender": gender,
        "screening_answers": screeningAnswers,
        "job_post": jobPost?.toJson(),
        "applicant": applicant?.toJson(),
        "referral": referral,
      };
}

class AppliedJobPostModel {
  final int? id;
  final String? partnerId;
  final String? createdBy;
  final String? jobTitle;
  final String? jobCode;
  final int? departmentId;
  final int? branchId;
  final String? employmentType;
  final String? experience;
  final String? salary;
  final String? jobCity;
  final String? distance;
  final int? vacanciesCount;
  final String? referralBudget;
  final String? referralAmount;
  final String? banner;
  final String? applicationDeadline;
  final String? jobDescription;
  final String? skills;
  final String? status;
  final String? salaryType;
  final String? salaryMin;
  final String? salaryMax;
  final String? jobType;
  final bool? isWorkFromHome;
  final bool? joiningFeeRequired;
  final String? minimumEducation;
  final String? englishLevel;
  final String? genderPreference;
  final AppliedJobBranchModel? branch;

  AppliedJobPostModel({
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
    this.salaryType,
    this.salaryMin,
    this.salaryMax,
    this.jobType,
    this.isWorkFromHome,
    this.joiningFeeRequired,
    this.minimumEducation,
    this.englishLevel,
    this.genderPreference,
    this.branch,
  });

  factory AppliedJobPostModel.fromJson(Map<String, dynamic> json) => AppliedJobPostModel(
        id: json["id"] is int ? json["id"] : int.tryParse(json["id"]?.toString() ?? ""),
        partnerId: json["partner_id"]?.toString(),
        createdBy: json["created_by"]?.toString(),
        jobTitle: json["job_title"]?.toString(),
        jobCode: json["job_code"]?.toString(),
        departmentId: json["department_id"] is int
            ? json["department_id"]
            : int.tryParse(json["department_id"]?.toString() ?? ""),
        branchId: json["branch_id"] is int
            ? json["branch_id"]
            : int.tryParse(json["branch_id"]?.toString() ?? ""),
        employmentType: json["employment_type"]?.toString(),
        experience: json["experience"]?.toString(),
        salary: json["salary"]?.toString(),
        jobCity: json["job_city"]?.toString(),
        distance: json["distance"]?.toString(),
        vacanciesCount: json["vacancies_count"] is int
            ? json["vacancies_count"]
            : int.tryParse(json["vacancies_count"]?.toString() ?? ""),
        referralBudget: json["referral_budget"]?.toString(),
        referralAmount: json["referral_amount"]?.toString(),
        banner: json["banner"]?.toString(),
        applicationDeadline: json["application_deadline"]?.toString(),
        jobDescription: json["job_description"]?.toString(),
        skills: json["skills"]?.toString(),
        status: json["status"]?.toString(),
        salaryType: json["salary_type"]?.toString(),
        salaryMin: json["salary_min"]?.toString(),
        salaryMax: json["salary_max"]?.toString(),
        jobType: json["job_type"]?.toString(),
        isWorkFromHome: json["is_work_from_home"] is bool
            ? json["is_work_from_home"]
            : (json["is_work_from_home"] == 1 || json["is_work_from_home"] == "1"),
        joiningFeeRequired: json["joining_fee_required"] is bool
            ? json["joining_fee_required"]
            : (json["joining_fee_required"] == 1 || json["joining_fee_required"] == "1"),
        minimumEducation: json["minimum_education"]?.toString(),
        englishLevel: json["english_level"]?.toString(),
        genderPreference: json["gender_preference"]?.toString(),
        branch: json["branch"] != null && json["branch"] is Map<String, dynamic>
            ? AppliedJobBranchModel.fromJson(json["branch"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner_id": partnerId,
        "created_by": createdBy,
        "job_title": jobTitle,
        "job_code": jobCode,
        "department_id": departmentId,
        "branch_id": branchId,
        "employment_type": employmentType,
        "experience": experience,
        "salary": salary,
        "job_city": jobCity,
        "distance": distance,
        "vacancies_count": vacanciesCount,
        "referral_budget": referralBudget,
        "referral_amount": referralAmount,
        "banner": banner,
        "application_deadline": applicationDeadline,
        "job_description": jobDescription,
        "skills": skills,
        "status": status,
        "salary_type": salaryType,
        "salary_min": salaryMin,
        "salary_max": salaryMax,
        "job_type": jobType,
        "is_work_from_home": isWorkFromHome,
        "joining_fee_required": joiningFeeRequired,
        "minimum_education": minimumEducation,
        "english_level": englishLevel,
        "gender_preference": genderPreference,
        "branch": branch?.toJson(),
      };
}

class AppliedJobBranchModel {
  final int? id;
  final String? partnerId;
  final String? name;
  final String? address;
  final String? status;

  AppliedJobBranchModel({
    this.id,
    this.partnerId,
    this.name,
    this.address,
    this.status,
  });

  factory AppliedJobBranchModel.fromJson(Map<String, dynamic> json) => AppliedJobBranchModel(
        id: json["id"] is int ? json["id"] : int.tryParse(json["id"]?.toString() ?? ""),
        partnerId: json["partner_id"]?.toString(),
        name: json["name"]?.toString(),
        address: json["address"]?.toString(),
        status: json["status"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner_id": partnerId,
        "name": name,
        "address": address,
        "status": status,
      };
}

class AppliedJobApplicantModel {
  final String? id;
  final String? employeeCode;
  final String? name;
  final String? email;
  final String? mobile;
  final String? role;
  final String? status;
  final String? workingMode;
  final String? employmentType;
  final String? walletBalance;
  final String? profileImage;
  final String? profileImageUrl;

  AppliedJobApplicantModel({
    this.id,
    this.employeeCode,
    this.name,
    this.email,
    this.mobile,
    this.role,
    this.status,
    this.workingMode,
    this.employmentType,
    this.walletBalance,
    this.profileImage,
    this.profileImageUrl,
  });

  factory AppliedJobApplicantModel.fromJson(Map<String, dynamic> json) => AppliedJobApplicantModel(
        id: json["id"]?.toString(),
        employeeCode: json["employee_code"]?.toString(),
        name: json["name"]?.toString(),
        email: json["email"]?.toString(),
        mobile: json["mobile"]?.toString(),
        role: json["role"]?.toString(),
        status: json["status"]?.toString(),
        workingMode: json["working_mode"]?.toString(),
        employmentType: json["employment_type"]?.toString(),
        walletBalance: json["wallet_balance"]?.toString(),
        profileImage: json["profile_image"]?.toString(),
        profileImageUrl: json["profile_image_url"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_code": employeeCode,
        "name": name,
        "email": email,
        "mobile": mobile,
        "role": role,
        "status": status,
        "working_mode": workingMode,
        "employment_type": employmentType,
        "wallet_balance": walletBalance,
        "profile_image": profileImage,
        "profile_image_url": profileImageUrl,
      };
}
