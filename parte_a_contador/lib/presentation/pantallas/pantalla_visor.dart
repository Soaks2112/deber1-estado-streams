import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../estado/contador_provider.dart';
import 'pantalla_control.dart';

class PantallaVisor extends ConsumerWidget {
  const PantallaVisor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contador = ref.watch(contadorProvider);
    return Scaffold(
        appBar: AppBar(title: const Text('Visor')),
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Contador: $contador',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          FilledButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (_) => const PantallaControl())),
              child: const Text('Ir a Control')),
        ])));
  }
}
