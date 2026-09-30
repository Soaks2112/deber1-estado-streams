import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'data/repositories/conexion_plus_repository.dart';
import 'domain/usecases/consultar_conexion.dart';
import 'domain/usecases/observar_conexion.dart';
import 'presentation/pantallas/pantalla_foto.dart';
import 'presentation/pantallas/pantalla_stream.dart';

void main() {
  final repository = ConexionPlusRepository(Connectivity());
  runApp(ConexionApp(consultar: ConsultarConexion(repository), observar: ObservarConexion(repository)));
}

class ConexionApp extends StatefulWidget {
  const ConexionApp({super.key, required this.consultar, required this.observar});
  final ConsultarConexion consultar;
  final ObservarConexion observar;

  @override
  State<ConexionApp> createState() => _ConexionAppState();
}

class _ConexionAppState extends State<ConexionApp> {
  int _indice = 0;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Conexión',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), useMaterial3: true),
        home: Scaffold(
          appBar: AppBar(title: Text(_indice == 0 ? 'Con Future' : 'Con Stream')),
          body: _indice == 0
              ? PantallaFoto(consultar: widget.consultar)
              : PantallaStream(consultar: widget.consultar, observar: widget.observar),
          bottomNavigationBar: NavigationBar(selectedIndex: _indice, onDestinationSelected: (value) => setState(() => _indice = value), destinations: const [
            NavigationDestination(icon: Icon(Icons.photo), label: 'Con Future'),
            NavigationDestination(icon: Icon(Icons.movie), label: 'Con Stream'),
          ]),
        ),
      );
}
