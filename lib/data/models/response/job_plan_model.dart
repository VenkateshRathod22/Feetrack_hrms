class JobPlanModel {
  int? id;
  String? name;
  num? price;
  int? jobLimit;
  int? validityDays;

  JobPlanModel({
    this.id,
    this.name,
    this.price,
    this.jobLimit,
    this.validityDays,
  });

  factory JobPlanModel.fromJson(Map<String, dynamic> json) {
    return JobPlanModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString(),
      price: json['price'] is num ? json['price'] : num.tryParse(json['price']?.toString() ?? ''),
      jobLimit: json['job_limit'] is int ? json['job_limit'] : int.tryParse(json['job_limit']?.toString() ?? ''),
      validityDays: json['validity_days'] is int ? json['validity_days'] : int.tryParse(json['validity_days']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'job_limit': jobLimit,
      'validity_days': validityDays,
    };
  }
}
