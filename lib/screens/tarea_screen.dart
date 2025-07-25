import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:tareas/provider_task/holiday_provider.dart';
import '../widgets/card_tarea.dart';
import '../widgets/header.dart';
import '../widgets/add_task_sheet.dart';
import '../provider_task/task_provider.dart';
import '../provider_task/theme_provider.dart';
import 'settings_screen.dart';

// Importar AppLocalizations generado
import 'package:tareas/l10n/app_localizations.dart';

import '../provider_task/weather_provider.dart'; //nuevo import para el clima

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
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    //Nuevo: Carga el clima con coordenadas fijas (Querétaro)
    Future.microtask(() async{
      final weatherProvider = context.read<WeatherProvider>();
      await weatherProvider.loadWeather(20.5888, -100.3899);
    });

    //Nuevo: Cargar feriados oficiales de México para el año actual
    final now = DateTime.now();
    context.read<HolidayProvider>().loadHolidays(
      year: now.year,
      countryCode: 'MX', // Código de país para México
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

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
    final taskProvider = context.watch<TaskProvider>();
    final localizations = AppLocalizations.of(context)!; // Obtener localización actual

    return Scaffold(
      appBar: AppBar(
        actions: [
          // NUEVO: IconButton para cambiar idioma
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: 'Idioma / Language',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                // Usar traducción en el tooltip
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
            const Header(),
            // NUEVO: Mensaje con pluralización dinámica
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                localizations.pendingTasks(taskProvider.tasks.length),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
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
                            // Integración Hive: uso de task.key (HiveObject)
                            key: ValueKey(task.key),
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
                              key: ValueKey(task.key), // Integración Hive: uso de task.key
                              title: task.title,
                              isDone: task.done,
                              dueDate: task.dueDate,
                              onToggle: () {
                                taskProvider.toggleTask(index);
                                _iconController.forward(from: 0);
                              },
                              onDelete: () => taskProvider.removeTask(index),
                              iconRotation: _iconController,
                              index: index,
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
        onPressed: _showAddTaskSheet,
        backgroundColor: Colors.pinkAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.calendar_today),
      ),
    );
  }
}