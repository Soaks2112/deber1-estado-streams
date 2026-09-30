# Deber 1: estado y streams en Flutter

El repositorio contiene dos proyectos Flutter independientes con sus carpetas de plataforma, dependencias fijadas y código fuente. En Parte A, `main` y las ramas `version/setstate`, `version/riverpod` y `version/bloc` contienen la app con distinta capa de presentación; las tres ramas comparadas conservan los mismos archivos `domain/` y `data/`. La Parte B está en todas las ramas.

Corre `flutter pub get` y luego `flutter run` desde el proyecto que quieras probar. Para la comparación A, selecciona la rama correspondiente antes de ejecutar `parte_a_contador`.

Los cuatro proyectos pasaron `flutter analyze` y `flutter build web`. La Parte B se probó en un Redmi Note 7: Future conservó la lectura anterior al apagar Wi-Fi y Stream cambió solo a “Sin conexión”. El video de 18 segundos está en [demo.mp4](demo.mp4). Las pruebas de navegación de Parte A quedan pendientes. Consulta [RESPUESTAS.md](RESPUESTAS.md) para el registro de las respuestas y observaciones.
