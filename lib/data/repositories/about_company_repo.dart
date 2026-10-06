import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class AboutCompanyRepo {
  final ApiClient apiClient;

  AboutCompanyRepo({required this.apiClient});

  Future<Response> getCompanyDocuments({String? search}) async {
    return await apiClient.getData(
      AppConstants.companyDocuments,
      "getCompanyDocuments",
      query: search != null ? {"search": search} : null,
    );
  }

  Future<Response> getProcessNotes({String? search}) async {
    return await apiClient.getData(
      AppConstants.processNotes,
      "getProcessNotes",
      query: search != null ? {"search": search} : null,
    );
  }
}
