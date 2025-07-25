// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Tareas Pro';

  @override
  String get addTask => 'Agregar tarea';

  @override
  String get editTask => 'Editar tarea';

  @override
  String get deleteTask => 'Eliminar tarea';

  @override
  String get taskDetails => 'Detalles de la tarea';

  @override
  String get changeTheme => 'Cambiar tema';

  @override
  String get addNewTask => 'Agregar nueva tarea';

  @override
  String get description => 'Descripción';

  @override
  String get selectDate => 'Seleccionar fecha';

  @override
  String get selectTime => 'Seleccionar Hora';

  @override
  String get timeLabel => 'Hora:';

  @override
  String dueDate(Object date) {
    return 'vence el $date';
  }

  @override
  String get hourLabel => 'Hora:';

  @override
  String get titleLabel => 'Título';

  @override
  String get changeDate => 'Cambiar fecha';

  @override
  String get changeTime => 'Cambiar hora';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get greeting => 'Hola, Regina';

  @override
  String get todayTasks => 'Estas son tus tareas para hoy';

  @override
  String get name => 'nombre';

  @override
  String pendingTasks(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tienes $count tareas pendientes',
      one: 'Tienes 1 tarea pendiente',
      zero: 'No tienes tareas pendientes',
    );
    return '$_temp0';
  }

  @override
  String get language => 'Idioma';

  @override
  String get settings => 'Configuración';

  @override
  String get theme => 'Tema';

  @override
  String get holidayTag => '🎉 Feriado';

  @override
  String get systemDefault => 'Idioma del sistema';

  @override
  String get weatherLoading => 'Cargando clima...';

  @override
  String get holiday => '🎉 Hoy es feriado: ';
}
