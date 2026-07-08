import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:timeago/timeago.dart' as timeago;

String dateTimeFormat(BuildContext context, DateTime date) {
  return DateFormat(
    'MMM d, yyyy • HH:mm',
    Localizations.localeOf(context).languageCode,
  ).format(date);
}

String dateFormat(BuildContext context, DateTime date) {
  return DateFormat(
    'MMM d, yyyy',
    Localizations.localeOf(context).languageCode,
  ).format(date);
}

String dateFormatWithDay(BuildContext context, DateTime date) {
  return DateFormat(
    'EEE, MMM d, yyyy',
    Localizations.localeOf(context).languageCode,
  ).format(date);
}

String humanReadableDate(BuildContext context, DateTime date) {
  return timeago.format(
    date,
    locale: Localizations.localeOf(context).languageCode,
  );
}

String casualDateFormat(BuildContext context, DateTime date) {
  return DateFormat(
    'dd/MM/yyyy',
    Localizations.localeOf(context).languageCode,
  ).format(date);
}

TimeOfDay parseTime(String timeString) {
  final parts = timeString.split(':');
  if (parts.length >= 2) {
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
  return const TimeOfDay(hour: 0, minute: 0);
}

String dateTimeWithAmPm(BuildContext context, DateTime date) {
  final locale = Localizations.localeOf(context).languageCode;

  return DateFormat('MMM d, yyyy', locale).add_jm().format(date);
}

String dashboardDateFormat(BuildContext context, DateTime date) {
  return DateFormat(
    'EEEE, MMMM d yyyy',
    Localizations.localeOf(context).languageCode,
  ).format(date);
}

// "June 2026" — calendar month header
String monthYearFormat(BuildContext context, DateTime date) {
  return DateFormat(
    'MMMM yyyy',
    Localizations.localeOf(context).languageCode,
  ).format(date);
}

// "Wednesday, June 3" — day detail header (no year)
String fullDayMonthFormat(BuildContext context, DateTime date) {
  return DateFormat(
    'EEEE, MMMM d',
    Localizations.localeOf(context).languageCode,
  ).format(date);
}


// "Mon, Jun 22" — compact appointment date (no year)
String shortDayMonthFormat(BuildContext context, DateTime date) {
  return DateFormat(
    'EEE, MMM d',
    Localizations.localeOf(context).languageCode,
  ).format(date);
}

// "Tuesday, June 23, 2026" — slot panel header
String slotPanelDateFormat(BuildContext context, DateTime date) {
  return DateFormat(
    'EEEE, MMMM d, yyyy',
    Localizations.localeOf(context).languageCode,
  ).format(date);
}

// "Tuesday" — day name only
String dayOfWeekFormat(BuildContext context, DateTime date) {
  return DateFormat(
    'EEEE',
    Localizations.localeOf(context).languageCode,
  ).format(date);
}

// "2026-07-15" — API date string, no locale needed
String dateToApiString(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

// "HH:MM" from a DateTime — for displaying slot times
String slotTimeFormat(DateTime dt) =>
    '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

// "2026-07-15T10:30:00" from a date + "HH:MM" string
DateTime slotToDateTime(DateTime date, String hhmm) {
  final parts = hhmm.split(':');
  return DateTime(
    date.year,
    date.month,
    date.day,
    int.parse(parts[0]),
    int.parse(parts[1]),
  );
}

// "15:30" from "15:00" + 30 minutes — no locale needed
String addMinutesToSlot(String slot, int minutes) {
  final parts = slot.split(':');
  final total = int.parse(parts[0]) * 60 + int.parse(parts[1]) + minutes;
  final h = (total ~/ 60) % 24;
  final m = total % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

Future<void> pickDate(BuildContext context, ValueChanged<String> onDatePicked) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: primaryColor,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      onDatePicked(DateFormat('dd/MM/yyyy').format(picked));
    }
  }
