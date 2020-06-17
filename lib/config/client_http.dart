import 'package:central_oftalmica_app_cliente/config/constants.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClientHttp {
  Dio dio = Dio();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _currentToken = '';

  ClientHttp() {
    dio.interceptors.clear();
    dio.options.baseUrl = MOCK_API;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) {
          if (_currentToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_currentToken';
            options.headers['Content-Type'] = 'application/json';
          }
        },
        onResponse: (Response response) => response,
        onError: (DioError error) async {
          if (error.response?.statusCode == 401) {
            dio.interceptors.requestLock.lock();
            dio.interceptors.responseLock.lock();

            RequestOptions options = error.response.request;
            FirebaseUser _user = await _auth.currentUser();
            IdTokenResult jwt = await _user.getIdToken();
            _currentToken = jwt.token;

            options.headers['Authorization'] = _currentToken;

            dio.interceptors.requestLock.unlock();
            dio.interceptors.responseLock.unlock();

            return dio.request(
              options.path,
              options: options,
            );
          }
          return error;
        },
      ),
    );
  }

  Dio getClient() => dio;
}
