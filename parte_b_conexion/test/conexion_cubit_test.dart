import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';
import 'package:parte_b_conexion/presentation/estado/conexion_cubit.dart';

class RepositorioPrueba implements ConexionRepository {
  final lectura = Completer<EstadoConexion>();
  final eventos = StreamController<EstadoConexion>.broadcast(sync: true);
  int suscripciones = 0;
  @override
  Future<EstadoConexion> consultarAhora() => lectura.future;
  @override
  Stream<EstadoConexion> observarCambios() {
    suscripciones++;
    return eventos.stream;
  }
}

void main() {
  test('cerrar durante la consulta no emite ni abre una suscripción', () async {
    final repo = RepositorioPrueba();
    final cubit =
        ConexionCubit(ConsultarConexion(repo), ObservarConexion(repo));
    final inicio = cubit.iniciar();
    await cubit.close();
    repo.lectura.complete(EstadoConexion.wifi);
    await inicio;
    expect(repo.suscripciones, 0);
    expect(repo.eventos.hasListener, isFalse);
    await repo.eventos.close();
  });

  test('escucha una vez, cuenta transiciones y cancela al cerrar', () async {
    final repo = RepositorioPrueba();
    repo.lectura.complete(EstadoConexion.wifi);
    final cubit =
        ConexionCubit(ConsultarConexion(repo), ObservarConexion(repo));
    await cubit.iniciar();
    await cubit.iniciar();
    expect(repo.suscripciones, 1);
    repo.eventos.add(EstadoConexion.wifi);
    expect(cubit.cambios, 0);
    repo.eventos.add(EstadoConexion.sinConexion);
    expect(cubit.state, EstadoConexion.sinConexion);
    expect(cubit.cambios, 1);
    repo.eventos.add(EstadoConexion.wifi);
    expect(cubit.cambios, 2);
    await cubit.close();
    expect(repo.eventos.hasListener, isFalse);
    repo.eventos.add(EstadoConexion.sinConexion);
    await repo.eventos.close();
  });
}
