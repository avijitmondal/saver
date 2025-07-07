import 'dart:developer' as developer;

import 'package:saver/constants/app_constants.dart';

enum LogLevel { debug, info, warning, error }

class Logger {
  static final Logger _instance = Logger._internal();
  factory Logger() => _instance;
  Logger._internal();

  static Logger get instance => _instance;

  bool _isEnabled = true;
  LogLevel _minLevel = LogLevel.debug;

  void configure({bool enabled = true, LogLevel minLevel = LogLevel.debug}) {
    _isEnabled = enabled;
    _minLevel = minLevel;
  }

  void debug(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message,
        tag: tag, error: error, stackTrace: stackTrace);
  }

  void info(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message,
        tag: tag, error: error, stackTrace: stackTrace);
  }

  void warning(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message,
        tag: tag, error: error, stackTrace: stackTrace);
  }

  void error(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message,
        tag: tag, error: error, stackTrace: stackTrace);
  }

  void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_isEnabled || level.index < _minLevel.index) {
      return;
    }

    final String logTag = tag ?? AppConstants.appName;
    final String levelStr = level.toString().split('.').last.toUpperCase();
    final String logMessage = '[$levelStr] $message';

    developer.log(
      logMessage,
      name: logTag,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
