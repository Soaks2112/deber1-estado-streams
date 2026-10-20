# Respuestas — Deber 1

> **Estado de la evidencia (revisión 2026-10-20):** las pruebas automáticas de Parte A verifican navegación, botón atrás y recuperación del valor usando SharedPreferences simulado; no equivalen a cerrar y abrir la app en un teléfono. En Parte B se comprueban las transiciones con un repositorio de prueba y la cancelación al cerrar. El video existente dura 17,95 segundos, pero sus 10 fotogramas muestran Wi-Fi y el contador en 1: **no demuestra el cambio automático exigido**. Falta volver a grabarlo en un dispositivo real. Las observaciones previas de teléfono no se han podido reproducir en esta revisión.

## Parte A — Estado

### 1. `setState` y el botón atrás del sistema

El código guarda el incremento en SharedPreferences, así que el valor persistido cambia. Lo que quedaría desactualizado es el `int _contador` que conserva el `State` de la pantalla Visor: al salir de Control con el botón del sistema, la ruta se cierra sin devolver el valor y el Visor no vuelve a leer el repositorio. La pantalla conserva su copia anterior hasta que se recargue. La prueba de widgets reproduce el botón atrás del sistema y comprueba que el Visor queda en 0 mientras el repositorio simulado guarda 1. Falta repetirlo en el teléfono.

Para coordinar el dato se ponen de acuerdo al menos tres puntos: el Visor que pasa el valor y espera el resultado; Control, que recibe el valor y lo devuelve; y la navegación que lleva y recoge ese resultado. `main.dart` además conecta los casos de uso al Visor.

### 2. Riverpod y el botón atrás

El contador vive en el estado compartido de `ContadorNotifier`, expuesto por `contadorProvider`, fuera del estado local de cada pantalla. Control modifica ese mismo estado y Visor lo observa. Al volver con el botón del sistema, no hace falta devolver un resultado: Visor vuelve a dibujarse con el estado compartido actualizado.

### 3. `BlocObserver`

El observer permite ver en consola la secuencia de estados emitidos, por ejemplo `ContadorCubit: 3 -> 4`, incluso cuando el cambio se origina desde otra pantalla. Sirve para rastrear errores reportados por usuarios, reconstruir el orden de acciones o revisar una transición inesperada durante depuración. Al ejecutar las pruebas de Cubit, la consola mostró `0 -> 1`, `1 -> 2`, `2 -> 3` y `0 -> 3` al recrear la app con el valor guardado.

### 4. Comparación Git

En este repositorio la Parte A está dentro de `parte_a_contador/`, así que los comandos equivalentes desde la raíz son:

```text
git diff version/setstate version/riverpod -- parte_a_contador/lib/domain parte_a_contador/lib/data
(sin salida)

git diff version/setstate version/bloc -- parte_a_contador/lib/domain parte_a_contador/lib/data
(sin salida)

git diff version/setstate version/bloc --stat -- parte_a_contador/lib/presentation
 .../lib/presentation/estado/contador_cubit.dart    | 35 +++++++++++
 .../presentation/pantallas/pantalla_control.dart   | 73 +++++++++-------------
 .../lib/presentation/pantallas/pantalla_visor.dart | 72 +++++++--------------
 3 files changed, 87 insertions(+), 93 deletions(-)
```

| Comprobación A.5 | Salida |
|---|---|
| `domain` y `data`: setState vs Riverpod | Vacía |
| `domain` y `data`: setState vs Cubit | Vacía |
| `presentation`: setState vs Cubit | 3 archivos; 87 inserciones y 93 eliminaciones |

Los dos primeros diffs vacíos muestran que las tres versiones conservan la misma lógica de dominio y acceso a datos; el tercero muestra que la implementación intercambiable está en `presentation/`. Para cambiar Riverpod por otro administrador de estado se reescribiría `presentation/` y el cableado correspondiente de `main.dart`, no `domain/` ni `data/`.

### 5. Cuándo elegir cada opción

Para una sola pantalla y estado local sencillo elegiría `setState`: tiene menos piezas y el dueño del dato queda claro. Para ocho pantallas que comparten cinco datos elegiría un estado compartido como Riverpod o Cubit; evita pasar cada valor por muchas rutas y permite que las pantallas observen los cambios.

`setState` sí es correcto cuando el dato pertenece a un solo widget o a una interacción local breve. También cuando la app es pequeña y no hay que compartir ni persistir ese estado entre pantallas.

### A.6 Comparativa

| | setState | Riverpod | Cubit |
|---|---|---|---|
| ¿Dónde vive el contador? | En el `State` del Visor; Control mantiene su copia mientras está abierto y el repositorio persiste el valor. | En `ContadorNotifier`, accesible mediante `contadorProvider`. | En el estado actual de `ContadorCubit`. |
| ¿Las pantallas se pasan datos? | Sí: valor inicial, casos de uso y valor de retorno. | No; ambas leen/modifican el provider. | No; ambas usan el Cubit compartido. |
| Archivos de `presentation/` que tocaste | 2 pantallas | Provider y 2 pantallas | Cubit y 2 pantallas |
| ¿Qué pasa con el botón atrás? | Puede dejar el Visor mostrando su copia vieja si Control se cierra sin devolver valor. | El estado compartido sigue actualizado y el Visor lo observa. | El estado del Cubit sigue actualizado y el Visor lo observa. |
| ¿Tuviste que tocar `domain/`? | No | No | No |

> La navegación y el retorno están cubiertos por pruebas de widgets. La persistencia se prueba con SharedPreferences simulado; queda pendiente verificar el cierre completo en un teléfono.

## Parte B — Future y Stream

### 6. La foto de conectividad

La pantalla Future solo cambia al pulsar “Consultar ahora”: conserva la etiqueta y la hora de la última lectura aunque cambie la red. Por eso, si se consultó con Wi-Fi encendido y luego se apagó, el dato sigue siendo correcto para la hora registrada, pero ya está desactualizado. El registro anterior decía haber observado esto en el Redmi; el video disponible no muestra esa prueba y no se ha repetido en esta revisión.

### 7. Cancelar la suscripción

Sin cancelar, la suscripción puede seguir reteniendo al Cubit y escuchando eventos después de salir de la pantalla. Al crearse y cerrarse la pantalla repetidas veces pueden acumularse listeners; además, una emisión hacia un Cubit ya cerrado puede producir errores. `close()` cancela la suscripción antes de cerrar el Cubit para detener esa escucha.

### 8. Foto y película

Future conserva una foto de la conexión tomada al consultar. Stream recibe nuevos avisos de red y actualiza el estado sin otra pulsación. La prueba automática reproduce Wi-Fi → Sin conexión → Wi-Fi y comprueba dos cambios. Sin embargo, `demo.mp4` solo muestra Wi-Fi con “Cambios recibidos: 1”; no respalda la afirmación anterior de una transición visible. Falta grabar el experimento real para completar esta evidencia.

En una app pediría con Future una lista de productos al abrir una búsqueda y el detalle de una orden. Observaría con Stream la ubicación GPS mientras se navega y los mensajes nuevos de un chat.

