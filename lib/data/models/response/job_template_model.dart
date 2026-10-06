class JobTemplateModel {
  int? id;
  String? title;
  String? category;
  String? overview;
  String? description;
  String? responsibilities;
  dynamic skills;
  String? defaultSalaryMin;
  String? defaultSalaryMax;
  String? salaryType;
  String? jobType;
  String? distance;
  String? jobCity;
  String? minimumEducation;
  String? englishLevel;
  dynamic minExperienceYears;
  dynamic maxExperienceYears;
  String? genderPreference;
  bool? joiningFeeRequired;
  List<dynamic>? additionalPerks;
  List<dynamic>? interviewInformation;
  List<ScreeningQuestionModel>? defaultScreeningQuestions;
  bool? isActive;
  String? createdBy;
  String? createdAt;
  String? updatedAt;

  JobTemplateModel({
    this.id,
    this.title,
    this.category,
    this.overview,
    this.description,
    this.responsibilities,
    this.skills,
    this.defaultSalaryMin,
    this.defaultSalaryMax,
    this.salaryType,
    this.jobType,
    this.distance,
    this.jobCity,
    this.minimumEducation,
    this.englishLevel,
    this.minExperienceYears,
    this.maxExperienceYears,
    this.genderPreference,
    this.joiningFeeRequired,
    this.additionalPerks,
    this.interviewInformation,
    this.defaultScreeningQuestions,
    this.isActive,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory JobTemplateModel.fromJson(Map<String, dynamic> json) {
    List<ScreeningQuestionModel> questions = [];
    if (json['dynamic_fields'] != null && json['dynamic_fields'] is List) {
      questions = (json['dynamic_fields'] as List)
          .map((v) => ScreeningQuestionModel.fromJson(v))
          .toList();
    } else if (json['default_screening_questions'] != null &&
        json['default_screening_questions'] is List) {
      questions = (json['default_screening_questions'] as List)
          .map((v) => ScreeningQuestionModel.fromJson(v))
          .toList();
    }

    return JobTemplateModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      title: json['title']?.toString(),
      category: json['category']?.toString(),
      overview: json['overview']?.toString(),
      description: json['description']?.toString(),
      responsibilities: json['responsibilities']?.toString(),
      skills: json['skills'],
      defaultSalaryMin: json['default_salary_min']?.toString(),
      defaultSalaryMax: json['default_salary_max']?.toString(),
      salaryType: json['salary_type']?.toString(),
      jobType: json['job_type']?.toString(),
      distance: json['distance']?.toString(),
      jobCity: json['job_city']?.toString(),
      minimumEducation: json['minimum_education']?.toString(),
      englishLevel: json['english_level']?.toString(),
      minExperienceYears: json['min_experience_years'],
      maxExperienceYears: json['max_experience_years'],
      genderPreference: json['gender_preference']?.toString(),
      joiningFeeRequired: json['joining_fee_required'] is bool
          ? json['joining_fee_required']
          : (json['joining_fee_required'] == 1 || json['joining_fee_required'] == '1' || json['joining_fee_required'] == 'true'),
      additionalPerks: json['additional_perks'] is List ? json['additional_perks'] : [],
      interviewInformation: json['interview_information'] is List ? json['interview_information'] : [],
      defaultScreeningQuestions: questions,
      isActive: json['is_active'] is bool
          ? json['is_active']
          : (json['is_active'] == 1 || json['is_active'] == '1' || json['is_active'] == 'true'),
      createdBy: json['created_by']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'overview': overview,
      'description': description,
      'responsibilities': responsibilities,
      'skills': skills,
      'default_salary_min': defaultSalaryMin,
      'default_salary_max': defaultSalaryMax,
      'salary_type': salaryType,
      'job_type': jobType,
      'distance': distance,
      'job_city': jobCity,
      'minimum_education': minimumEducation,
      'english_level': englishLevel,
      'min_experience_years': minExperienceYears,
      'max_experience_years': maxExperienceYears,
      'gender_preference': genderPreference,
      'joining_fee_required': joiningFeeRequired,
      'additional_perks': additionalPerks,
      'interview_information': interviewInformation,
      'default_screening_questions':
          defaultScreeningQuestions?.map((v) => v.toJson()).toList(),
      'is_active': isActive,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class ScreeningQuestionModel {
  String? id;
  String? question;
  String? type;
  int? required;
  dynamic options;
  String? conditionalParent;
  String? conditionalValue;

  ScreeningQuestionModel({
    this.id,
    this.question,
    this.type,
    this.required,
    this.options,
    this.conditionalParent,
    this.conditionalValue,
  });

  factory ScreeningQuestionModel.fromJson(Map<String, dynamic> json) {
    int reqVal = 0;
    if (json['required'] is bool) {
      reqVal = json['required'] == true ? 1 : 0;
    } else if (json['required'] is int) {
      reqVal = json['required'];
    } else if (json['required'] != null) {
      reqVal = int.tryParse(json['required'].toString()) ?? 0;
    }

    return ScreeningQuestionModel(
      id: json['id']?.toString(),
      question: json['question']?.toString(),
      type: json['type']?.toString(),
      required: reqVal,
      options: json['options'],
      conditionalParent: json['conditional_parent']?.toString(),
      conditionalValue: json['conditional_value']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'type': type,
      'required': required,
      'options': options,
      'conditional_parent': conditionalParent,
      'conditional_value': conditionalValue,
    };
  }
}
