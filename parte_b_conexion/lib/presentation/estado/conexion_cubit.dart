import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';

class ConexionCubit extends Cubit<EstadoConexion> {
  ConexionCubit(this._consultar, this._observar) : super(EstadoConexion.otro);
  final ConsultarConexion _consultar;
  final ObservarConexion _observar;
  StreamSubscription<EstadoConexion>? _suscripcion;
  int _cambios = 0;
  int get cambios => _cambios;

  Future<void> iniciar() async {
    emit(await _consultar());
    _suscripcion = _observar().listen((estado) {
      _cambios++;
      emit(estado);
    }, onError: (Object error, StackTrace stack) {
      addError(error, stack);
    });
  }

  @override
  Future<void> close() async {
    await _suscripcion?.cancel();
    await super.close();
  }
}
