import 'dart:convert';

import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/repository.dart';
import 'package:dio/dio.dart';

class CreditCardRepository extends Repository<CreditCardModel> {
  Dio dio;

  CreditCardRepository(this.dio);

  Future<List<CreditCardModel>> index() async {
    try {
      Response response = await dio.get('/creditCards');

      return (response.data as List)
          .map(
            (e) => CreditCardModel.fromJson(e),
          )
          .toList();
    } catch (error) {
      return null;
    }
  }

  @override
  Future<String> store({CreditCardModel model}) async {
    try {
      Response response = await dio.post(
        '/creditCards',
        data: jsonEncode(model),
      );

      return response.data['data'];
    } catch (error) {
      return null;
    }
  }
}
