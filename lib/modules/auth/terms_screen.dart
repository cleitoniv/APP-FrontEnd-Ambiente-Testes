import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TermsResponsability extends StatefulWidget {
  @override
  _TermsResponsabilityState createState() => _TermsResponsabilityState();
}

class _TermsResponsabilityState extends State<TermsResponsability> {
  AuthBloc _authBloc = Modular.get<AuthBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authBloc.getTermsOfResponsability();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Termos de Responsabilidade"),
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: _authBloc.getTermsOfResponsabilityStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                return Center(
                  child: Text("Falha ao carregar Termos!"),
                );
              }
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.83),
                      child: ListView(
                          children: snapshot.data.data.map<Widget>(
                        (e) {
                          return Column(
                            children: [
                              Container(
                                child: ListTile(
                                  title: Text(e),
                                ),
                              ),
                              Container(
                                height: 20,
                              )
                            ],
                          );
                        },
                      ).toList()),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
