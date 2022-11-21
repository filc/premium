import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/controllers/timetable_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo/utils/format.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:i18n_extension/i18n_widget.dart';

class PremiumFSTimetable extends StatefulWidget {
  const PremiumFSTimetable({Key? key, required this.controller}) : super(key: key);

  final TimetableController controller;

  @override
  State<PremiumFSTimetable> createState() => _PremiumFSTimetableState();
}

class _PremiumFSTimetableState extends State<PremiumFSTimetable> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final days = widget.controller.days!;
    final int maxLessonCount = days.fold(0, (a, b) => math.max(a, b.where((l) => l.subject.id != "" || l.isEmpty).length));

    const padding = 30 + 6 * 2;
    final colw = (MediaQuery.of(context).size.width - padding) / days.length;

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 24.0),
        itemCount: maxLessonCount + 1,
        itemBuilder: (context, index) {
          List<Widget> columns = [];

          for (int dayIndex = -1; dayIndex < days.length; dayIndex++) {
            final lessonIndex = index - 1;

            if (dayIndex == -1) {
              if (lessonIndex >= 0) {
                columns.add(SizedBox(
                  width: 30.0,
                  height: 40.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "$lessonIndex.",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ));
              } else {
                columns.add(const SizedBox(width: 30.0));
              }
              continue;
            }

            final lessons = days[dayIndex].where((l) => l.subject.id != "" || l.isEmpty).toList();

            if (dayIndex >= days.length || lessonIndex >= lessons.length) {
              columns.add(SizedBox(width: colw));
              continue;
            }

            if (lessonIndex == -1 && dayIndex >= 0) {
              columns.add(SizedBox(
                width: colw,
                height: 40.0,
                child: Text(
                  DateFormat("EEEE", I18n.of(context).locale.languageCode).format(lessons.first.date).capital(),
                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ));
              continue;
            }

            if (lessons[lessonIndex].isEmpty) {
              columns.add(SizedBox(
                width: colw,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(FeatherIcons.slash, size: 18.0, color: AppColors.of(context).text.withOpacity(.3)),
                    const SizedBox(width: 8.0),
                    Text(
                      "Lyukas óra",
                      style: TextStyle(color: AppColors.of(context).text.withOpacity(.3)),
                    ),
                  ],
                ),
              ));
              continue;
            }

            columns.add(SizedBox(
              width: colw,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        SubjectIcon.resolveVariant(context: context, subject: lessons[lessonIndex].subject),
                        size: 18.0,
                        color: AppColors.of(context).text.withOpacity(.7),
                      ),
                      const SizedBox(width: 8.0),
                      Text(lessons[lessonIndex].name.capital()),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 26.0),
                    child: Text(
                      lessons[lessonIndex].room,
                      style: TextStyle(color: AppColors.of(context).text.withOpacity(.5)),
                    ),
                  ),
                ],
              ),
            ));
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columns,
          );
        },
      ),
    );
  }
}
