import 'package:vlr/data/models/response/lead_model.dart';
import 'package:vlr/data/models/user_model.dart';

class CustomerVisitModel {
  String? id;
  String? partnerId;
  String? leadId;
  String? employeeId;
  String? visitDate;
  String? gpsLocation;
  String? location;
  String? purpose;
  String? notes;
  String? status;
  String? photoPath;
  String? followUpDate;
  int? managerApproved;
  String? createdAt;
  String? updatedAt;
  LeadModel? lead;
  UserModel? employee;

  CustomerVisitModel({
    this.id,
    this.partnerId,
    this.leadId,
    this.employeeId,
    this.visitDate,
    this.gpsLocation,
    this.location,
    this.purpose,
    this.notes,
    this.status,
    this.photoPath,
    this.followUpDate,
    this.managerApproved,
    this.createdAt,
    this.updatedAt,
    this.lead,
    this.employee,
  });

  factory CustomerVisitModel.fromJson(Map<String, dynamic> json) {
    return CustomerVisitModel(
      id: json['id']?.toString(),
      partnerId: json['partner_id']?.toString(),
      leadId: json['lead_id']?.toString(),
      employeeId: json['employee_id']?.toString(),
      visitDate: json['visit_date']?.toString(),
      gpsLocation: json['gps_location']?.toString(),
      location: json['location']?.toString(),
      purpose: json['purpose']?.toString(),
      notes: json['notes']?.toString(),
      status: json['status']?.toString(),
      photoPath: json['photo_path']?.toString(),
      followUpDate: json['follow_up_date']?.toString(),
      managerApproved: json['manager_approved'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      lead: json['lead'] != null ? LeadModel.fromJson(json['lead']) : null,
      employee: json['employee'] != null ? UserModel.fromJson(json['employee']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['partner_id'] = partnerId;
    data['lead_id'] = leadId;
    data['employee_id'] = employeeId;
    data['visit_date'] = visitDate;
    data['gps_location'] = gpsLocation;
    data['location'] = location;
    data['purpose'] = purpose;
    data['notes'] = notes;
    data['status'] = status;
    data['photo_path'] = photoPath;
    data['follow_up_date'] = followUpDate;
    data['manager_approved'] = managerApproved;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (lead != null) {
      data['lead'] = lead!.toJson();
    }
    if (employee != null) {
      data['employee'] = employee!.toJson();
    }
    return data;
  }
}
