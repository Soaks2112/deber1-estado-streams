import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

final obtenerContadorProvider = Provider<ObtenerContador>(
    (ref) => throw UnimplementedError('Inyectar en ProviderScope'));
final incrementarProvider = Provider<Incrementar>(
    (ref) => throw UnimplementedError('Inyectar en ProviderScope'));
final decrementarProvider = Provider<Decrementar>(
    (ref) => throw UnimplementedError('Inyectar en ProviderScope'));

final contadorProvider = StateNotifierProvider<ContadorNotifier, int>((ref) =>
    ContadorNotifier(ref.read(obtenerContadorProvider),
        ref.read(incrementarProvider), ref.read(decrementarProvider)));

class ContadorNotifier extends StateNotifier<int> {
  ContadorNotifier(this._obtener, this._incrementar, this._decrementar)
      : super(0) {
    cargar();
  }
  final ObtenerContador _obtener;
  final Incrementar _incrementar;
  final Decrementar _decrementar;
  Future<void> cargar() async => state = await _obtener();
  Future<void> incrementar() async => state = await _incrementar();
  Future<void> decrementar() async => state = await _decrementar();
}
