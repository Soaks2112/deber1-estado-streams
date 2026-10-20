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
  bool _iniciado = false;
  bool _cerrando = false;
  int get cambios => _cambios;

  Future<void> iniciar() async {
    if (_iniciado || _cerrando || isClosed) return;
    _iniciado = true;
    final inicial = await _consultar();
    if (_cerrando || isClosed) return;
    emit(inicial);
    _suscripcion = _observar().listen(
      (estado) {
        if (_cerrando || isClosed || estado == state) return;
        _cambios++;
        emit(estado);
      },
      onError: (Object error, StackTrace stack) {
        addError(error, stack);
      },
    );
  }

  @override
  Future<void> close() async {
    _cerrando = true;
    await _suscripcion?.cancel();
    await super.close();
  }
}
