import 'dart:developer' as dev;

/// [AppLogger] is a centralized singleton for logging across the application.
/// It provides structured logging that can be easily turned off or redirected in production.
class AppLogger {
  AppLogger._internal();
  static final AppLogger _instance = AppLogger._internal();
  static AppLogger get instance => _instance;

  /// Log a debug message
  void d(String message, {String? tag}) {
    _log(message, level: 'DEBUG', tag: tag);
  }

  /// Log an information message
  void i(String message, {String? tag}) {
    _log(message, level: 'INFO', tag: tag);
  }

  /// Log a warning message
  void w(String message, {String? tag}) {
    _log(message, level: 'WARN', tag: tag);
  }

  /// Log an error message with optional exception and stack trace
  void e(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    dev.log(
      '[$tag] ❌ ERROR: $message',
      name: tag ?? 'APP',
      error: error,
      stackTrace: stackTrace,
    );
  }

  void _log(String message, {required String level, String? tag}) {
    final emoji = _getEmoji(level);
    dev.log(
      '$emoji $level: $message',
      name: tag ?? 'APP',
    );
  }

  String _getEmoji(String level) {
    switch (level) {
      case 'DEBUG':
        return '🐛';
      case 'INFO':
        return 'ℹ️';
      case 'WARN':
        return '⚠️';
      default:
        return '📝';
    }
  }
}
