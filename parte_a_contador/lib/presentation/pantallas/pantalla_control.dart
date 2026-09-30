import 'package:flutter/material.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';

class PantallaControl extends StatefulWidget {
  const PantallaControl(
      {super.key,
      required this.inicial,
      required this.incrementar,
      required this.decrementar});
  final int inicial;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  State<PantallaControl> createState() => _PantallaControlState();
}

class _PantallaControlState extends State<PantallaControl> {
  late int _contador = widget.inicial;
  bool _ocupado = false;

  Future<void> _cambiar(Future<int> Function() accion) async {
    if (_ocupado) return;
    setState(() => _ocupado = true);
    try {
      final valor = await accion();
      if (mounted) setState(() => _contador = valor);
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Control')),
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Contador: $_contador',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          FilledButton(
              onPressed:
                  _ocupado ? null : () => _cambiar(widget.incrementar.call),
              child: const Text('+1')),
          FilledButton(
              onPressed:
                  _ocupado ? null : () => _cambiar(widget.decrementar.call),
              child: const Text('-1')),
          OutlinedButton(
              onPressed: () => Navigator.pop(context, _contador),
              child: const Text('Volver')),
        ])),
      );
}
