import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class PermissionRepo {
  final ApiClient apiClient;

  PermissionRepo({required this.apiClient});

  Future<Response> getPermissions({String? search}) async {
    Map<String, dynamic> query = {};
    if (search != null && search.isNotEmpty) query['search'] = search;
    return await apiClient.getData(AppConstants.permissions, "getPermissions", query: query);
  }
}
