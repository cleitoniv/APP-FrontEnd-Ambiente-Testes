import 'package:central_oftalmica_app_cliente/models/user_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/user_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class UserBloc extends Disposable {
  UserRepository repository;

  UserBloc(this.repository);

  Future<PointsResult> addPoints(Map<String, dynamic> data) async {
    return repository.addPoints(data);
  }

  void fetchUsuariosCliente() async {
    usuariosClienteSink.add(UsuarioClienteList(isLoading: true));
    UsuarioClienteList usuarios = await repository.getUsuarios();
    usuariosClienteSink.add(usuarios);
  }

  void getEnderecoEntrega() async {
    enderecoEntregaSink.add(Endereco(isLoading: true));
    Endereco endereco = await repository.enderecoEntrega();
    enderecoEntregaSink.add(endereco);
  }

  Future<AddUsuarioCliente> addUsuario(Map<String, dynamic> data) async {
    return repository.addUsuarioCliente(data);
  }

  Future<UpdateUsuarioCliente> updateUsuario(
      int id, Map<String, dynamic> data) async {
    return repository.updateUsuarioCliente(id, data);
  }

  BehaviorSubject _usuariosClienteController = BehaviorSubject();
  Sink get usuariosClienteSink => _usuariosClienteController.sink;
  Stream get usuariosClienteStream => _usuariosClienteController.stream;

  BehaviorSubject _enderecoEntregaController = BehaviorSubject();
  Sink get enderecoEntregaSink => _enderecoEntregaController.sink;
  Stream get enderecoEntregaStream => _enderecoEntregaController.stream;
  get enderecoEntregaValue => _enderecoEntregaController.value;

  void convertPoints(int points) async {
    convertPointsSink.add(PointsResult(isLoading: true));
    PointsResult result = await repository.convertPoints(points);
    convertPointsSink.add(result);
  }

  Future<PointsResult> rescuePoints(int points, credits) async {
    return repository.rescuePoints(points, credits);
  }

  BehaviorSubject _convertPointsController = BehaviorSubject();
  Sink get convertPointsSink => _convertPointsController.sink;
  Stream get convertPointsStream => _convertPointsController.stream;

  BehaviorSubject _pointsResultController = BehaviorSubject();
  Sink get pointsSink => _pointsResultController.sink;
  Stream get pointsStream => _pointsResultController.stream;

  BehaviorSubject _currentUserController = BehaviorSubject.seeded(null);
  Sink get currentUserIn => _currentUserController.sink;
  Stream<UserModel> get currentUserOut =>
      _currentUserController.stream.asyncMap(
        (event) => repository.currentUser(),
      );

  BehaviorSubject _updateController = BehaviorSubject.seeded(null);
  Sink get updateIn => _updateController.sink;
  Stream<String> get updateOut => _updateController.stream.asyncMap(
        (event) => repository.update(event),
      );

  BehaviorSubject _pointsController = BehaviorSubject.seeded(null);
  Sink get pointsIn => _pointsController.sink;
  Stream<String> get pointsOut => _pointsController.stream.asyncMap(
        (event) => repository.postPoints(event),
      );

  @override
  void dispose() {
    _usuariosClienteController.close();
    _enderecoEntregaController.close();
    _convertPointsController.close();
    _pointsResultController.close();
    _currentUserController.close();
    _updateController.close();
    _pointsController.close();
  }
}
