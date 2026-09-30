import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/contador_repository.dart';

class ContadorPrefsRepository implements ContadorRepository {
  static const _clave = 'contador';

  @override
  Future<int> leer() async =>
      (await SharedPreferences.getInstance()).getInt(_clave) ?? 0;

  @override
  Future<void> guardar(int valor) async {
    await (await SharedPreferences.getInstance()).setInt(_clave, valor);
  }
}
