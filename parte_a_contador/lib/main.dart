import 'package:flutter/material.dart';

import 'data/repositories/contador_prefs_repository.dart';
import 'domain/usecases/decrementar.dart';
import 'domain/usecases/incrementar.dart';
import 'domain/usecases/obtener_contador.dart';
import 'presentation/pantallas/pantalla_visor.dart';

void main() {
  final repository = ContadorPrefsRepository();
  runApp(ContadorApp(
      obtener: ObtenerContador(repository),
      incrementar: Incrementar(repository),
      decrementar: Decrementar(repository)));
}

class ContadorApp extends StatelessWidget {
  const ContadorApp(
      {super.key,
      required this.obtener,
      required this.incrementar,
      required this.decrementar});
  final ObtenerContador obtener;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Contador',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true),
        home: PantallaVisor(
            obtener: obtener,
            incrementar: incrementar,
            decrementar: decrementar),
      );
}
