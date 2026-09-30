import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../estado/contador_cubit.dart';

class PantallaControl extends StatelessWidget {
  const PantallaControl({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Control')),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<ContadorCubit, int>(
            builder: (context, contador) => Text(
              'Contador: $contador',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: context.read<ContadorCubit>().incrementar,
            child: const Text('+1'),
          ),
          FilledButton(
            onPressed: context.read<ContadorCubit>().decrementar,
            child: const Text('-1'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver'),
          ),
        ],
      ),
    ),
  );
}
