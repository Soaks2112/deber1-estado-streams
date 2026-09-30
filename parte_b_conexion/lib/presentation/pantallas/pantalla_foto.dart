import 'package:flutter/material.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';

class PantallaFoto extends StatefulWidget {
  const PantallaFoto({super.key, required this.consultar});
  final ConsultarConexion consultar;

  @override
  State<PantallaFoto> createState() => _PantallaFotoState();
}

class _PantallaFotoState extends State<PantallaFoto> {
  EstadoConexion? _estado;
  DateTime? _momento;
  bool _consultando = false;

  Future<void> _consultar() async {
    setState(() => _consultando = true);
    try {
      final estado = await widget.consultar();
      if (mounted) setState(() { _estado = estado; _momento = DateTime.now(); });
    } finally {
      if (mounted) setState(() => _consultando = false);
    }
  }

  String _nombre(EstadoConexion estado) => switch (estado) {
        EstadoConexion.wifi => 'Wi-Fi',
        EstadoConexion.datosMoviles => 'Datos móviles',
        EstadoConexion.otro => 'Otra conexión',
        EstadoConexion.sinConexion => 'Sin conexión',
      };

  @override
  Widget build(BuildContext context) {
    final conectado = _estado != null && _estado != EstadoConexion.sinConexion;
    final color = conectado ? Colors.green : Colors.red;
    final hora = _momento == null ? '—' : '${_momento!.hour.toString().padLeft(2, '0')}:${_momento!.minute.toString().padLeft(2, '0')}:${_momento!.second.toString().padLeft(2, '0')}';
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      FilledButton(onPressed: _consultando ? null : _consultar, child: const Text('Consultar ahora')),
      const SizedBox(height: 24),
      if (_estado != null) Icon(conectado ? Icons.wifi : Icons.wifi_off, size: 52, color: color),
      Text(_estado == null ? 'Sin consultar' : _nombre(_estado!), style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: color)),
      Text('Consulta: $hora'),
    ]));
  }
}
