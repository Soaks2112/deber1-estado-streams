import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/contador_repository.dart';
import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

final contadorRepositoryProvider = Provider<ContadorRepository>(
  (ref) => throw UnimplementedError('Inyectar en ProviderScope'),
);
final obtenerContadorProvider = Provider<ObtenerContador>(
  (ref) => ObtenerContador(ref.watch(contadorRepositoryProvider)),
);
final incrementarProvider = Provider<Incrementar>(
  (ref) => Incrementar(ref.watch(contadorRepositoryProvider)),
);
final decrementarProvider = Provider<Decrementar>(
  (ref) => Decrementar(ref.watch(contadorRepositoryProvider)),
);

final contadorProvider =
    NotifierProvider<ContadorNotifier, int>(ContadorNotifier.new);

class ContadorNotifier extends Notifier<int> {
  bool _activo = true;
  @override
  int build() {
    ref.onDispose(() => _activo = false);
    Future.microtask(cargar);
    return 0;
  }

  Future<void> _actualizar(Future<int> Function() accion) async {
    if (!_activo) return;
    final valor = await accion();
    if (_activo) state = valor;
  }

  Future<void> cargar() => _actualizar(ref.read(obtenerContadorProvider).call);
  Future<void> incrementar() => _actualizar(ref.read(incrementarProvider).call);
  Future<void> decrementar() => _actualizar(ref.read(decrementarProvider).call);
}
