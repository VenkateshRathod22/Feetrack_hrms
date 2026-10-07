class PayslipConfigModel {
  String? companyName;
  String? companyAddress;
  String? authorizedSignatory;
  String? termsConditions;
  String? logo;
  String? logoPath;
  String? signature;
  String? signaturePath;

  PayslipConfigModel({
    this.companyName,
    this.companyAddress,
    this.authorizedSignatory,
    this.termsConditions,
    this.logo,
    this.logoPath,
    this.signature,
    this.signaturePath,
  });

  PayslipConfigModel.fromJson(Map<String, dynamic> json) {
    companyName = json['company_name'];
    companyAddress = json['company_address'];
    authorizedSignatory = json['authorized_signatory'];
    termsConditions = json['terms_conditions'];
    logo = json['logo'];
    logoPath = json['logo_path'];
    signature = json['signature'];
    signaturePath = json['signature_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_name'] = companyName;
    data['company_address'] = companyAddress;
    data['authorized_signatory'] = authorizedSignatory;
    data['terms_conditions'] = termsConditions;
    data['logo'] = logo;
    data['logo_path'] = logoPath;
    data['signature'] = signature;
    data['signature_path'] = signaturePath;
    return data;
  }
}
