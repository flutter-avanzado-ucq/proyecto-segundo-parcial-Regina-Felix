import 'package:flutter/material.dart';
// Integración Hive: importación de Hive Flutter
import 'package:hive_flutter/hive_flutter.dart';

import 'package:tareas/screens/task_screen.dart'; 
import 'tema/tema_app.dart';
import 'package:provider/provider.dart';
import 'provider_task/task_provider.dart';
import 'provider_task/theme_provider.dart'; // NUEVO
import 'provider_task/locale_provider.dart'; // NUEVO

// Importar modelo para Hive
import 'models/task_model.dart';

// Importar el servicio de notificaciones
import 'services/notification_service.dart';

// NUEVO: Importar AppLocalizations generado
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  // Asegura que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Integración Hive: inicialización de Hive
  await Hive.initFlutter();

  // Integración Hive: registro del adapter para Task
  Hive.registerAdapter(TaskAdapter());

  // Integración Hive: apertura de la caja tasksBox
  await Hive.openBox<Task>('tasksBox');

  // Inicializar notificaciones
  await NotificationService.initializeNotifications();

  // Pedir permiso para notificaciones (Android 13+ y iOS)
  await NotificationService.requestPermission();

  // Iniciar la app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // ✅ NUEVO
        ChangeNotifierProvider(create: (_) => LocaleProvider()), // ✅ NUEVO: para el idioma
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

          // NUEVO: Configuración de idioma dinámico
          locale: localeProvider.locale, // Se toma el idioma guardado (o null para idioma del sistema)

          // NUEVO: Delegados de localización
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // NUEVO: Idiomas soportados
          supportedLocales: const [
            Locale('en'), // Inglés
            Locale('es'), // Español
          ],

          // NUEVO: Resolver idioma por preferencia guardada o idioma del sistema
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
