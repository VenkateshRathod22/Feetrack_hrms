import 'package:vlr/data/models/user_model.dart';

class LeadModel {
  String? id;
  String? partnerId;
  String? customerName;
  String? customerMobile;
  String? email;
  String? businessName;
  String? businessAmount;
  String? productInterest;
  dynamic assignedTo; // Can be String ID or UserModel
  String? status;
  String? notes;
  String? createdAt;
  String? updatedAt;

  LeadModel({
    this.id,
    this.partnerId,
    this.customerName,
    this.customerMobile,
    this.email,
    this.businessName,
    this.businessAmount,
    this.productInterest,
    this.assignedTo,
    this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  LeadModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    partnerId = json['partner_id']?.toString();
    customerName = json['customer_name']?.toString();
    customerMobile = json['customer_mobile']?.toString();
    email = json['email']?.toString();
    businessName = json['company_name']?.toString() ?? json['business_name']?.toString();
    businessAmount = json['business_amount']?.toString();
    productInterest = json['product_interest']?.toString();
    
    if (json['assigned_to'] != null) {
      if (json['assigned_to'] is Map) {
        assignedTo = UserModel.fromJson(json['assigned_to']);
      } else {
        assignedTo = json['assigned_to'].toString();
      }
    }
    
    status = json['status']?.toString();
    notes = json['notes']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['partner_id'] = partnerId;
    data['customer_name'] = customerName;
    data['customer_mobile'] = customerMobile;
    data['email'] = email;
    data['company_name'] = businessName;
    data['business_amount'] = businessAmount;
    data['product_interest'] = productInterest;
    
    if (assignedTo != null) {
      if (assignedTo is UserModel) {
        data['assigned_to'] = (assignedTo as UserModel).toJson();
      } else {
        data['assigned_to'] = assignedTo;
      }
    }

    data['status'] = status;
    data['notes'] = notes;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  @override
  String toString() => customerName ?? "Unknown Lead";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeadModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
