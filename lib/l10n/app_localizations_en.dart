// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tasks Pro';

  @override
  String get addTask => 'Add task';

  @override
  String get editTask => 'Edit task';

  @override
  String get deleteTask => 'Delete task';

  @override
  String get taskDetails => 'Task details';

  @override
  String get changeTheme => 'Change theme';

  @override
  String get addNewTask => 'Add new task';

  @override
  String get description => 'Description';

  @override
  String get selectDate => 'Select date';

  @override
  String get selectTime => 'Select Time';

  @override
  String get timeLabel => 'Time:';

  @override
  String dueDate(Object date) {
    return 'due $date';
  }

  @override
  String get hourLabel => 'Hour:';

  @override
  String get titleLabel => 'Title';

  @override
  String get changeDate => 'Change date';

  @override
  String get changeTime => 'Change time';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get greeting => 'Hello, Regina';

  @override
  String get todayTasks => 'These are your tasks for today';

  @override
  String get name => 'name';

  @override
  String pendingTasks(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pending tasks',
      one: '1 pending task',
      zero: 'No pending tasks',
    );
    return '$_temp0';
  }

  @override
  String get language => 'Language';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get holidayTag => '🎉 Holiday';

  @override
  String get systemDefault => 'System default';

  @override
  String get weatherLoading => 'Loading weather...';

  @override
  String get holiday => '🎉 Today is holiday: ';
}
