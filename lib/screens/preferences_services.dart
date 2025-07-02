import 'package:hive/hive.dart';

// Esta clase maneja el guardado y recuperación de preferencias del usuario, como el tema oscuro
class PreferencesService {
  // Nombre de la caja de Hive donde se guardan las preferencias
  static const String _boxName = 'preferences_box';

  // Clave que se usa para guardar el estado del tema
  static const String _themeKey = 'isDarkMode';

  // Método para guardar si el tema es oscuro o no
  static Future<void> setDarkMode(bool isDark) async {
    // Abre (o crea si no existe) la caja de Hive
    final box = await Hive.openBox(_boxName);

    // Guarda el valor booleano con la clave correspondiente
    await box.put(_themeKey, isDark);
  }

  // Método para obtener el valor actual del tema
  static Future<bool> getDarkMode() async {
    // Abre la caja
    final box = await Hive.openBox(_boxName);

    // Retorna el valor guardado, o 'false' si no hay valor
    return box.get(_themeKey, defaultValue: false);
  }
}
