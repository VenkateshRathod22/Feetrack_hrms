import 'dart:developer';
import 'package:get/get.dart';
import 'package:vlr/data/models/advance_payment_model.dart';
import 'package:vlr/data/repositories/advance_payment_repo.dart';
import 'package:vlr/data/models/response/response_model.dart';

class AdvancePaymentController extends GetxController implements GetxService {
  final AdvancePaymentRepo advancePaymentRepo;
  AdvancePaymentController({required this.advancePaymentRepo});

  bool isLoading = false;
  List<AdvancePaymentModel> advancePaymentsList = [];

  Future<ResponseModel> fetchAdvancePayments() async {
    log('----------- fetchAdvancePayments Called ----------');
    isLoading = true;
    update();

    ResponseModel responseModel;
    try {
      Response response = await advancePaymentRepo.getAdvancePayments();

      if (response.body['status'] == "success") {
        advancePaymentsList = [];
        response.body['data'].forEach((v) {
          advancePaymentsList.add(AdvancePaymentModel.fromJson(v));
        });
        responseModel = ResponseModel(true, response.body['message'] ?? "Advance payments fetched successfully");
      } else {
        responseModel = ResponseModel(false, response.body['message'] ?? "Error fetching advance payments");
      }
    } catch (e) {
      log('ERROR AT fetchAdvancePayments(): $e');
      responseModel = ResponseModel(false, "Error fetching advance payments: $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> createAdvancePayment({
    required double amount,
    required int month,
    required int year,
    required String reason,
  }) async {
    log('----------- createAdvancePayment Called ----------');
    isLoading = true;
    update();

    ResponseModel responseModel;
    try {
      Map<String, dynamic> body = {
        "amount": amount,
        "month": month,
        "year": year,
        "reason": reason,
      };

      Response response = await advancePaymentRepo.addAdvancePayment(data: FormData(body));

      if (response.body['status'] == "success") {
        fetchAdvancePayments(); // Refresh list after adding
        responseModel = ResponseModel(true, response.body['message'] ?? "Advance payment requested successfully");
      } else {
        responseModel = ResponseModel(false, response.body['message'] ?? "Error creating advance payment request");
      }
    } catch (e) {
      log('ERROR AT createAdvancePayment(): $e');
      responseModel = ResponseModel(false, "Error creating advance payment request: $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }
}
