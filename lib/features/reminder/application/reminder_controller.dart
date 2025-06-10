import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hey_champ_app/features/reminder/application/reminder_model.dart';
import 'package:hive/hive.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class ReminderController {
  static final _box = Hive.box<Reminder>('reminders');

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> scheduleReminder(Reminder reminder) async {
    _box.add(reminder); // Saves the reminder

    // 🔒 Request permission if needed
    final status = await Permission.scheduleExactAlarm.request();
    if (status != PermissionStatus.granted) {
      throw PlatformException(
        code: 'exact_alarms_not_permitted',
        message: 'Exact alarms are not permitted',
      );
    }

    // Add your notification scheduling logic here
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Channel for reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);
    final scheduledDate = tz.TZDateTime.from(reminder.dateTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      reminder.hashCode,
      'Reminder: ${reminder.title}',
      'It\'s time!',
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: _getRepeatInterval(reminder.repeat),
      payload: 'reminder_${reminder.hashCode}',
    );
  }

  static List<Reminder> getReminders() {
    return _box.values.toList();
  }

  static Future<void> initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> deleteReminder(Reminder reminder) async {
    // Cancel the scheduled notification
    await _notificationsPlugin.cancel(reminder.hashCode);

    // Delete from Hive
    final key = _box.keys.firstWhere(
      (k) => _box.get(k) == reminder,
      orElse: () => null,
    );

    if (key != null) {
      await _box.delete(key);
    }
  }

  static DateTimeComponents? _getRepeatInterval(String repeat) {
    switch (repeat) {
      case 'Daily':
        return DateTimeComponents.time;
      case 'Weekly':
        return DateTimeComponents.dayOfWeekAndTime;
      case 'Monthly':
        return DateTimeComponents.dayOfMonthAndTime;
      default:
        return null; // One-time
    }
  }
}
