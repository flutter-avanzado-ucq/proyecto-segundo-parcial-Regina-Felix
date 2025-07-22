import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../provider_task/weather_provider.dart';  //Nuevo
import '../widgets/card_tarea.dart';
import '../widgets/header.dart';
import '../widgets/add_task_sheet.dart';
import '../provider_task/task_provider.dart';
import '../provider_task/theme_provider.dart';
import '../screens/settings_screen.dart';
import 'package:tareas/l10n/app_localizations.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> with SingleTickerProviderStateMixin {
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    // Controlador para la animación del ícono de completar tarea
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  

    //Nuevo: Carga el clima con coordenadas fijas (Querétaro)
    Future.microtask(() async{
      final weatherProvider = context.read<WeatherProvider>();
      await weatherProvider.loadWeather(20.5888, -100.3899);
    }); 
  }
  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  // Abre la hoja modal para agregar una nueva tarea
  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddTaskSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>(); // Estado de tareas
    final localizations = AppLocalizations.of(context)!; // Traducciones activas

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle), // Título traducido
        actions: [
          // Botón para cambiar idioma
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: localizations.language,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          // Botón para cambiar entre modo claro y oscuro
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
                tooltip: localizations.changeTheme,
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Header(), // Encabezado con saludo y subtítulo

            // Texto del número de tareas pendientes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                localizations.pendingTasks(taskProvider.tasks.length),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            // Lista de tareas animada
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks[index];

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 30.0,
                        child: FadeInAnimation(
                          child: Dismissible(
                            key: ValueKey(task.key), // Clave de Hive
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => taskProvider.removeTask(index),
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade300,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: TaskCard(
                              key: ValueKey(task.key),
                              title: task.title,
                              isDone: task.done,
                              dueDate: task.dueDate,
                              onToggle: () {
                                taskProvider.toggleTask(index); // Cambia estado completado
                                _iconController.forward(from: 0); // Ejecuta animación
                              },
                              onDelete: () => taskProvider.removeTask(index),
                              iconRotation: _iconController,
                              index: index,
                              dueTime: task.dueDate != null ? DateFormat('HH:mm').format(task.dueDate!) : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet, // Abre formulario para nueva tarea
        backgroundColor: Colors.pinkAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.calendar_today),
      ),
    );
  }
}