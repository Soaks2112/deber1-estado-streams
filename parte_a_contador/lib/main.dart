import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/contador_prefs_repository.dart';
import 'domain/usecases/decrementar.dart';
import 'domain/usecases/incrementar.dart';
import 'domain/usecases/obtener_contador.dart';
import 'presentation/estado/contador_cubit.dart';
import 'presentation/pantallas/pantalla_visor.dart';

void main() {
  Bloc.observer = ContadorObserver();
  final repository = ContadorPrefsRepository();
  runApp(
    BlocProvider(
      create: (_) => ContadorCubit(
        obtener: ObtenerContador(repository),
        incrementar: Incrementar(repository),
        decrementar: Decrementar(repository),
      )..cargar(),
      child: const ContadorApp(),
    ),
  );
}

class ContadorApp extends StatelessWidget {
  const ContadorApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Contador',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      useMaterial3: true,
    ),
    home: const PantallaVisor(),
  );
}
