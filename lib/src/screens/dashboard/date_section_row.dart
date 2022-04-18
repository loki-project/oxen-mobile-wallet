import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oxen_wallet/l10n.dart';
import 'package:oxen_wallet/palette.dart';

extension RelativeDateHelpers on DateTime {
  bool isToday([DateTime? now]) {
    now ??= DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool isYesterday([DateTime? now]) {
    now ??= DateTime.now();
    return isToday(now.subtract(Duration(days: 1)));
  }

  bool isPastWeek([DateTime? now]) {
    now ??= DateTime.now();
    // diffDays gives us the integer days difference, but that is a pain because a value of 6 could
    // be anywhere from 6.00 to 6.99 days ago, while the date 6 days before now will only partially
    // overlap with that range, so we have to muck around a bit to deal with those edge cases.
    final diffDays = difference(now).inDays;
    if (diffDays >= -5 && diffDays <= -1)
      return true;
    if (diffDays == 0) // if diff is 0 then this is anywhere from -0.99 to 0.99: allow yesterday and today but not tomorrow
      return isToday(now) || isYesterday(now);
    if (diffDays == -6) // if -6 then allow the date that was 6 days ago but not the one that was 7 days ago
      return isToday(now.subtract(Duration(days: 6)));
    return false;
  }
}

class DateSectionRow extends StatelessWidget {
  DateSectionRow({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final t = tr(context);

    String title;
    if (date.isToday())
      title = t.today;
    else if (date.isYesterday())
      title = t.yesterday;
    else if (date.isPastWeek())
      title = DateFormat.EEEE(t.localeName).format(date);
    else if (date.isAfter(DateTime.now().subtract(Duration(days: 304))))
      // If within (approximately) the last 10 months then don't include the year
      title = DateFormat.MMMd(t.localeName).format(date);
    else
      title = DateFormat.yMMMd(t.localeName).format(date);

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Center(
          child: Text(title,
              style: TextStyle(fontSize: 16, color: Palette.wildDarkBlue))),
    );
  }
}
