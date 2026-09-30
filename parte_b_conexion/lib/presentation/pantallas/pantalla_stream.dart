import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';
import '../estado/conexion_cubit.dart';

class PantallaStream extends StatelessWidget {
  const PantallaStream({super.key, required this.consultar, required this.observar});
  final ConsultarConexion consultar;
  final ObservarConexion observar;

  String _nombre(EstadoConexion estado) => switch (estado) {
        EstadoConexion.wifi => 'Wi-Fi',
        EstadoConexion.datosMoviles => 'Datos móviles',
        EstadoConexion.otro => 'Otra conexión',
        EstadoConexion.sinConexion => 'Sin conexión',
      };

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => ConexionCubit(consultar, observar)..iniciar(),
        child: BlocBuilder<ConexionCubit, EstadoConexion>(
          builder: (context, estado) {
            final conectado = estado != EstadoConexion.sinConexion;
            return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(conectado ? Icons.wifi : Icons.wifi_off, size: 56, color: conectado ? Colors.green : Colors.red),
              Text(_nombre(estado), style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text('Cambios recibidos: ${context.read<ConexionCubit>().cambios}'),
            ]));
          },
        ),
      );
}
