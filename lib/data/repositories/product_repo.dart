import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class ProductRepo {
  final ApiClient apiClient;

  ProductRepo({required this.apiClient});

  Future<Response> getProducts(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.products, "getProducts", query: query);
  }

  Future<Response> createProduct(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.products, "createProduct", body);
  }

  Future<Response> updateProduct(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.products}/$id", "updateProduct", body);
  }

  Future<Response> deleteProduct(int id) async {
    return await apiClient.deleteData("${AppConstants.products}/$id", "deleteProduct");
  }
}
