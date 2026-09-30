import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/repositories/contador_prefs_repository.dart';
import 'domain/usecases/decrementar.dart';
import 'domain/usecases/incrementar.dart';
import 'domain/usecases/obtener_contador.dart';
import 'presentation/estado/contador_provider.dart';
import 'presentation/pantallas/pantalla_visor.dart';

void main() {
  final repository = ContadorPrefsRepository();
  runApp(ProviderScope(overrides: [
    obtenerContadorProvider.overrideWithValue(ObtenerContador(repository)),
    incrementarProvider.overrideWithValue(Incrementar(repository)),
    decrementarProvider.overrideWithValue(Decrementar(repository)),
  ], child: const ContadorApp()));
}

class ContadorApp extends StatelessWidget {
  const ContadorApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Contador',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true),
        home: const PantallaVisor(),
      );
}
