# Tareas By Re 

Aplicación desarrollada en Flutter para gestionar tareas del día a día

## Propósito de las animaciones implementadas

Se incorporaron diversas animaciones para hacer más intuitiva y atractiva la interacción del usuario con la aplicación. Las animaciones utilizadas son:

- Cambio de color (AnimatedContainer): El fondo de la tarjeta de cada tarea cambia dependiendo de si está completada o no.
- Cambio de opacidad (AnimatedOpacity): Las tareas completadas tienen menor opacidad, lo que visualmente las diferencia de las pendientes.
- Rotación del ícono (AnimationController + Transform.rotate): El ícono gira 180 grados al marcar o desmarcar una tarea.
- Cambio de ícono en el botón flotante (AnimatedIcon): Al abrir el formulario para agregar una tarea, el botón cambia con una animación fluida.
- Animaciones al ingresar las tareas (flutter_staggered_animations): Las tareas aparecen con animaciones escalonadas de entrada para dar un efecto visual agradable.

## Personalización de colores en las tareas

Se modificaron los colores originales para dejar evidencia de los cambios implementados:

| Estado de la tarea | Color original | Color personalizado |
|--------------------|----------------|----------------------|
| Completada         | Verde          | Morado claro (`Colors.purple.shade100`) |
| Incompleta         | Azul/Gris      | Café claro (`Colors.brown.shade100`)    |

Además, el color del ícono también cambia según el estado:

- Completada: Ícono morado (`Colors.purple`)
- Incompleta: Ícono café (`Colors.brown`)

Esto se refleja en el archivo `card_tarea.dart`:

```dart
color: Colors.purple.shade100 : Colors.brown.shade100,
...
color: Colors.purple : Colors.brown,

Se agrego un calendario interactivo con fechas de vencimiento para las tareas 

Se agrego un boton para permitir editar y quitar la fecha de la tarea 