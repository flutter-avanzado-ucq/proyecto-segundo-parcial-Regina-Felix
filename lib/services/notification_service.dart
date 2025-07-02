// notification_service.dart - Código comentado
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Plugin principal para gestionar notificaciones
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Inicializa las configuraciones para Android e iOS
  static Future<void> initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('ic_notification');
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    tz.initializeTimeZones(); // Inicializa zonas horarias necesarias para notificaciones programadas

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationResponse, // Callback al recibir interacción
    );
  }

  // Método que maneja el payload de la notificación
  static void _onNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      print('Payload: \${response.payload}');
    }
  }

  // Solicita permisos de notificación si no han sido concedidos
  static Future<void> requestPermission() async {
    if (await Permission.notification.isDenied ||
        await Permission.notification.isPermanentlyDenied) {
      await Permission.notification.request();
    }

    // Para dispositivos iOS específicamente
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  // Muestra una notificación inmediata
  static Future<void> showImmediateNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'instant_channel',
      'Notificaciones Instantaneas',
      channelDescription: 'Canal para notificaciones inmediatas',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Programa una notificación para mostrarse en el futuro
  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate, // Fecha y hora programada
    required int notificationId,     // ID de notificación programada
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'scheduled_channel',
      'Notificaciones Programadas',
      channelDescription: 'Canal para recordatorios de tareas',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      notificationId, // Se usa un identificador único para poder cancelarla después si se requiere
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local), // Convierte la fecha a zona horaria local
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  // Cancela una notificación programada a partir de su ID
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id); // Importante para evitar múltiples notificaciones duplicadas
  }
}
