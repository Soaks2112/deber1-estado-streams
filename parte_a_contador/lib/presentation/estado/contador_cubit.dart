import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

class ContadorCubit extends Cubit<int> {
  ContadorCubit({
    required ObtenerContador obtener,
    required Incrementar incrementar,
    required Decrementar decrementar,
  }) : _obtener = obtener,
       _incrementar = incrementar,
       _decrementar = decrementar,
       super(0);

  final ObtenerContador _obtener;
  final Incrementar _incrementar;
  final Decrementar _decrementar;

  Future<void> cargar() async => emit(await _obtener());
  Future<void> incrementar() async => emit(await _incrementar());
  Future<void> decrementar() async => emit(await _decrementar());
}

class ContadorObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    if (bloc is ContadorCubit) {
      // ignore: avoid_print
      print('ContadorCubit: ${change.currentState} -> ${change.nextState}');
    }
    super.onChange(bloc, change);
  }
}
