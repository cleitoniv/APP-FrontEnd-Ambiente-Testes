import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/repository.dart';
import 'package:dio/dio.dart';

class ProductRepository implements Repository<ProductModel> {
  Dio dio;

  ProductRepository(this.dio);

  @override
  Future<String> delete({int id}) {
    throw UnimplementedError();
  }

  @override
  Future<List<ProductModel>> index() async {
    try {
      Response response = await dio.get('/products');

      return (response.data as List)
          .map(
            (e) => ProductModel.fromJson(e),
          )
          .toList();
    } catch (error) {
      return null;
    }
  }

  @override
  Future<ProductModel> show({int id}) async {
    try {
      Response response = await dio.get('/products/$id');

      return ProductModel.fromJson(
        response.data,
      );
    } catch (error) {
      return null;
    }
  }

  @override
  Future<String> store({ProductModel model}) {
    throw UnimplementedError();
  }

  @override
  Future<String> update({int id, ProductModel model}) {
    throw UnimplementedError();
  }
}
