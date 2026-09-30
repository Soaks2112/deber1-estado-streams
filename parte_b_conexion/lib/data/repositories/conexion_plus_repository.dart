import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/repositories/conexion_repository.dart';

class ConexionPlusRepository implements ConexionRepository {
  ConexionPlusRepository() : _connectivity = Connectivity();
  final Connectivity _connectivity;

  EstadoConexion _traducir(List<ConnectivityResult> estados) {
    if (estados.contains(ConnectivityResult.wifi)) return EstadoConexion.wifi;
    if (estados.contains(ConnectivityResult.mobile)) {
      return EstadoConexion.datosMoviles;
    }
    if (estados.contains(ConnectivityResult.ethernet) ||
        estados.contains(ConnectivityResult.vpn)) {
      return EstadoConexion.otro;
    }
    return EstadoConexion.sinConexion;
  }

  @override
  Future<EstadoConexion> consultarAhora() async =>
      _traducir(await _connectivity.checkConnectivity());

  @override
  Stream<EstadoConexion> observarCambios() =>
      _connectivity.onConnectivityChanged.map(_traducir);
}
