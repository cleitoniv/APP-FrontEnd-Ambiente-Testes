import 'dart:convert';

import 'package:dio/dio.dart';

class PaymentRepository {
  Dio dio;

  PaymentRepository(this.dio);

  Future<String> payment(Map<String, dynamic> data) async {
    try {
      Response response = await dio.post(
        '/payment',
        data: jsonEncode(data),
      );

      return response.data['data'];
    } catch (error) {
      return null;
    }
  }
}
