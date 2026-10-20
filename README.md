# Deber 1: estado y streams en Flutter

El repositorio contiene dos proyectos Flutter independientes con sus carpetas de plataforma, dependencias fijadas y código fuente. En Parte A, `main` y las ramas `version/setstate`, `version/riverpod` y `version/bloc` contienen la app con distinta capa de presentación; las tres ramas comparadas conservan los mismos archivos `domain/` y `data/`. La Parte B está en todas las ramas.

Corre `flutter pub get` y luego `flutter run` desde el proyecto que quieras probar. Para la comparación A, selecciona la rama correspondiente antes de ejecutar `parte_a_contador`.

La revisión incluye análisis estático, compilación web y pruebas automáticas de navegación del contador y cierre de la suscripción. Consulta [RESPUESTAS.md](RESPUESTAS.md) para las ocho respuestas, las tablas y las limitaciones de la evidencia.

Resultados de la revisión del 20 de octubre de 2026:

| Versión | `flutter analyze` | Pruebas | Compilación web |
|---|---|---|---|
| Parte A: setState | Sin errores | 2 aprobadas | Correcta |
| Parte A: Riverpod | Sin errores | 2 aprobadas | Correcta |
| Parte A: Cubit | Sin errores | 2 aprobadas | Correcta |
| Parte B | Sin errores | 2 aprobadas | Correcta |

`main` contiene el mismo código de aplicación que `version/setstate`. Los dos diffs de `domain/` y `data/` entre las tres variantes están vacíos. La compilación Android y las pruebas físicas no se repitieron en esta revisión.

Para ejecutar las pruebas:

```powershell
cd parte_a_contador
flutter pub get
flutter test # Riverpod o Cubit
flutter test --dart-define=SETSTATE=true # main o version/setstate
cd ../parte_b_conexion
flutter pub get
flutter test
```

En Riverpod se usa `NotifierProvider` con `Notifier`, siguiendo la [guía oficial de migración](https://riverpod.dev/docs/migration/from_state_notifier). El repositorio concreto se inyecta desde `main.dart`; los providers solo conocen el contrato del dominio.

**Pendiente antes de entregar:** sustituir [demo.mp4](demo.mp4) por una grabación real de 15–20 segundos donde la pestaña “Con Stream” cambie de Wi-Fi a Sin conexión y vuelva a Wi-Fi sin pulsar la app. El archivo actual dura 17,95 segundos, pero todos sus fotogramas muestran Wi-Fi: no satisface ese requisito. También debe verificarse la persistencia al cerrar la app por completo en el teléfono; las pruebas de widgets utilizan almacenamiento simulado.

El repositorio de GitHub es privado. Para que el docente pueda revisarlo, necesita acceso al repositorio.
