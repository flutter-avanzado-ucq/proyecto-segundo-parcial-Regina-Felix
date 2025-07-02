//  task_provider.dart 
import 'package:flutter/material.dart';
import '../services/notification_service.dart';

// Modelo de datos para tareas
class Task {
  String title;
  bool done;
  DateTime? dueDate;
  TimeOfDay? dueTime; //  Manejo de la hora
  int? notificationId; //  Identificador  de la notificación

  Task({
    required this.title,
    this.done = false,
    this.dueDate,
    this.dueTime,
    this.notificationId,
  });
}

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(String title, {DateTime? dueDate, TimeOfDay? dueTime, int? notificationId}) {
    _tasks.insert(0, Task(
      title: title,
      dueDate: dueDate,
      dueTime: dueTime, //  Se guarda la hora de la tarea
      notificationId: notificationId, //  Se guarda el ID de notificación
    ));
    notifyListeners();
  }

  void toggleTask(int index) {
    _tasks[index].done = !_tasks[index].done;
    notifyListeners();
  }

  void removeTask(int index) {
    final task = _tasks[index];
    //  Cancelación de notificación si la tarea tiene una notificación programada
    if (task.notificationId != null) {
      NotificationService.cancelNotification(task.notificationId!);
    }
    _tasks.removeAt(index);
    notifyListeners();
  }

  void updateTask(int index, String newTitle, {DateTime? newDate, TimeOfDay? newTime, int? notificationId}) {
    final task = _tasks[index];

    //  Cancelar notificación anterior para evitar duplicados
    if (task.notificationId != null) {
      NotificationService.cancelNotification(task.notificationId!);
    }

    //  Actualización de hora y 🔔 nuevo ID de notificación
    _tasks[index].title = newTitle;
    _tasks[index].dueDate = newDate;
    _tasks[index].dueTime = newTime;
    _tasks[index].notificationId = notificationId;

    notifyListeners();
  }
}
