# Respuestas — Deber 1

> **Estado de la evidencia:** los cuatro proyectos pasaron `flutter analyze` y `flutter build web`. La Parte B sí se probó en un Redmi Note 7: Future mantuvo una lectura obsoleta y Stream reflejó el cambio de Wi-Fi. Se grabó `demo.mp4` durante 18 segundos. Las pruebas de navegación del contador en Parte A siguen pendientes.

## Parte A — Estado

### 1. `setState` y el botón atrás del sistema

El código guarda el incremento en SharedPreferences, así que el valor persistido cambia. Lo que quedaría desactualizado es el `int _contador` que conserva el `State` de la pantalla Visor: al salir de Control con el botón del sistema, la ruta se cierra sin devolver el valor y el Visor no vuelve a leer el repositorio. La pantalla conserva su copia anterior hasta que se recargue. No probé esta navegación de Parte A en el teléfono.

Para coordinar el dato se ponen de acuerdo al menos tres puntos: el Visor que pasa el valor y espera el resultado; Control, que recibe el valor y lo devuelve; y la navegación que lleva y recoge ese resultado. `main.dart` además conecta los casos de uso al Visor.

### 2. Riverpod y el botón atrás

El contador vive en el estado compartido de `ContadorNotifier`, expuesto por `contadorProvider`, fuera del estado local de cada pantalla. Control modifica ese mismo estado y Visor lo observa. Al volver con el botón del sistema, no hace falta devolver un resultado: Visor vuelve a dibujarse con el estado compartido actualizado.

### 3. `BlocObserver`

El observer permite ver en consola la secuencia de estados emitidos, por ejemplo `ContadorCubit: 3 -> 4`, incluso cuando el cambio se origina desde otra pantalla. Sirve para rastrear errores reportados por usuarios, reconstruir el orden de acciones o revisar una transición inesperada durante depuración. La compilación y análisis están verificados; no ejecuté Parte A para observar la consola.

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

> Las filas describen el comportamiento esperado por el código; falta confirmarlo al usar la app.

## Parte B — Future y Stream

### 6. La foto de conectividad

En el Redmi consulté con Wi-Fi encendido: la pantalla mostró “Wi‑Fi” y la hora `23:53:05`. Apagué Wi‑Fi y la captura aún mostraba “Wi‑Fi” con esa misma hora. El dato era correcto para el momento de consulta, pero estaba desactualizado; al volver a pulsar “Consultar ahora” se solicita una nueva foto.

### 7. Cancelar la suscripción

Sin cancelar, la suscripción puede seguir reteniendo al Cubit y escuchando eventos después de salir de la pantalla. Al crearse y cerrarse la pantalla repetidas veces pueden acumularse listeners; además, una emisión hacia un Cubit ya cerrado puede producir errores. `close()` cancela la suscripción antes de cerrar el Cubit para detener esa escucha.

### 8. Foto y película

Con Future vi que la etiqueta y hora quedaron iguales al apagar Wi‑Fi. En Stream, la pantalla cambió sola de Wi‑Fi a “Sin conexión”; la probé además dos veces y el contador de cambios aumentó. `demo.mp4` muestra la prueba de 18 segundos. En este teléfono, sin datos móviles disponibles, el resultado al apagar Wi‑Fi fue “Sin conexión”.

En una app pediría con Future una lista de productos al abrir una búsqueda y el detalle de una orden. Observaría con Stream la ubicación GPS mientras se navega y los mensajes nuevos de un chat.

