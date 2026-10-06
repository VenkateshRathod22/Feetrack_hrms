import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vlr/data/models/payslip_config_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/payslip_config_repo.dart';

class PayslipConfigController extends GetxController implements GetxService {
  final PayslipConfigRepo payslipConfigRepo;

  PayslipConfigController({required this.payslipConfigRepo});

  bool isLoading = false;
  PayslipConfigModel? payslipConfig;

  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyAddressController = TextEditingController();
  final TextEditingController authorizedSignatoryController = TextEditingController();
  final TextEditingController termsConditionsController = TextEditingController();

  XFile? logoFile;
  XFile? signatureFile;

  Future<ResponseModel> getPayslipConfig() async {
    isLoading = true;
    update();

    try {
      Response response = await payslipConfigRepo.getPayslipConfig();

      if (response.body != null && response.body['status'] == "success") {
        payslipConfig = PayslipConfigModel.fromJson(response.body['data']);
        setEditData(payslipConfig!);
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Payslip config fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch payslip config");
      }
    } catch (e) {
      log("ERROR AT getPayslipConfig: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> updatePayslipConfig() async {
    isLoading = true;
    update();

    try {
      Map<String, String> body = {
        "company_name": companyNameController.text,
        "company_address": companyAddressController.text,
        "authorized_signatory": authorizedSignatoryController.text,
        "terms_conditions": termsConditionsController.text,
      };

      FormData formData = FormData(body);

      if (logoFile != null) {
        formData.files.add(MapEntry(
          "payslip_logo",
          MultipartFile(File(logoFile!.path), filename: logoFile!.name),
        ));
      }

      if (signatureFile != null) {
        formData.files.add(MapEntry(
          "payslip_signature",
          MultipartFile(File(signatureFile!.path), filename: signatureFile!.name),
        ));
      }

      Response response = await payslipConfigRepo.updatePayslipConfig(formData);

      if (response.body != null && response.body['status'] == "success") {
        payslipConfig = PayslipConfigModel.fromJson(response.body['data']);
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Payslip configuration saved successfully.");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to save payslip configuration");
      }
    } catch (e) {
      log("ERROR AT updatePayslipConfig: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void setEditData(PayslipConfigModel model) {
    companyNameController.text = model.companyName ?? "";
    companyAddressController.text = model.companyAddress ?? "";
    authorizedSignatoryController.text = model.authorizedSignatory ?? "";
    termsConditionsController.text = model.termsConditions ?? "";
    logoFile = null;
    signatureFile = null;
    update();
  }

  Future<void> pickLogo() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      logoFile = image;
      update();
    }
  }

  Future<void> pickSignature() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      signatureFile = image;
      update();
    }
  }

  @override
  void onClose() {
    companyNameController.dispose();
    companyAddressController.dispose();
    authorizedSignatoryController.dispose();
    termsConditionsController.dispose();
    super.onClose();
  }
}
