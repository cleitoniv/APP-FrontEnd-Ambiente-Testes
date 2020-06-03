import 'package:central_oftalmica_app_cliente/models/financial_credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/product_credit_model.dart';
import 'package:dio/dio.dart';

class CreditsRepository {
  Dio dio;

  CreditsRepository(this.dio);

  Future<FinancialCreditModel> indexFinancial() async {
    try {
      Response response = await dio.get('/financialCredits');

      return FinancialCreditModel.fromJson(response.data);
    } catch (error) {
      return null;
    }
  }

  Future<ProductCreditModel> indexProduct() async {
    try {
      Response response = await dio.get('/productCredits');

      return ProductCreditModel.fromJson(response.data);
    } catch (error) {
      return null;
    }
  }
}
