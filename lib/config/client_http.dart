import 'package:central_oftalmica_app_cliente/config/constants.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClientHttp {
  Dio dio = Dio();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _currentToken = '';

  ClientHttp() {
    dio.interceptors.clear();
    dio.options.baseUrl = API;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          if (_currentToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_currentToken';
            options.headers['Content-Type'] = 'application/json';
          }
          handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) =>
            handler.resolve(response),
        onError: (DioError error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {
            dio.interceptors.requestLock.lock();
            dio.interceptors.responseLock.lock();

            RequestOptions options = error.response.requestOptions;
            User _user = _auth.currentUser;
            String _currentToken = await _user.getIdToken();

            options.headers['Authorization'] = _currentToken;

            dio.interceptors.requestLock.unlock();
            dio.interceptors.responseLock.unlock();

            return dio.request(
              options.path,
              options: options.data,
            );
          }
          handler.reject(error);
        },
      ),
    );
  }

  Dio getClient() => dio;
}
