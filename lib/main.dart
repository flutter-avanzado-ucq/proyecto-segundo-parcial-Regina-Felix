import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tareas/provider_task/holiday_provider.dart';
import 'package:tareas/provider_task/locale_provider.dart';
import 'package:tareas/screens/tarea_screen.dart';
import 'tema/tema_app.dart';
import 'package:provider/provider.dart';
import 'provider_task/task_provider.dart';
import 'provider_task/theme_provider.dart';
import 'models/task_model.dart' as hive_task;
import 'services/notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tareas/l10n/app_localizations.dart';

// Nuevo
import 'provider_task/weather_provider.dart';

void main() async {
  // Asegura que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Integración Hive: inicialización de Hive
  await Hive.initFlutter();

  // Integración Hive: registro del adapter para Task (usando prefijo hive_task)
  Hive.registerAdapter(hive_task.TaskAdapter());

  // Integración Hive: apertura de la caja tasksBox (usando prefijo hive_task)
  await Hive.openBox<hive_task.Task>('tasksBox');

  // Inicializar notificaciones
  await NotificationService.initializeNotifications();

  // Pedir permiso para notificaciones (Android 13+ y iOS)
  await NotificationService.requestPermission();

  // Iniciar la app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), 
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => HolidayProvider()), // NUEVO: para los feriados
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tareas Pro',
          theme: AppTheme.theme,
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          locale: localeProvider.locale,

          // NUEVO: Configuración de internacionalización
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // Inglés
            Locale('es'), // Español
          ],

          // NUEVO: Callback para resolución de idioma
          localeResolutionCallback: (locale, supportedLocales) {
            if (localeProvider.locale != null) {
              return localeProvider.locale;
            }
            for (var supported in supportedLocales) {
              if (supported.languageCode == locale?.languageCode) {
                return supported;
              }
            }
            return supportedLocales.first;
          },

          home: const TaskScreen(),
        );
      },
    );
  }
}