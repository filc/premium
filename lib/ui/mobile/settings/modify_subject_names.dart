import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_sheet_menu/rounded_bottom_sheet.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:filcnaplo_premium/models/premium_scopes.dart';
import 'package:filcnaplo_premium/providers/premium_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class MenuRenamedSubjects extends StatelessWidget {
  const MenuRenamedSubjects({Key? key, required this.settings}) : super(key: key);

  final SettingsProvider settings;

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<PremiumProvider>(context).hasScope(PremiumScopes.timetableWidget)) {
      return const SizedBox(); // TODO: premium upsell
    }

    return PanelButton(
      padding: const EdgeInsets.only(left: 14.0),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(builder: (context) => const ModifySubjectNames()),
        );
      },
      title: Text(
        "Tantárgyak átnevezése",
        style: TextStyle(color: AppColors.of(context).text.withOpacity(settings.renamedSubjectsEnabled ? 1.0 : .5)),
      ),
      leading: settings.renamedSubjectsEnabled
          ? const Icon(FeatherIcons.penTool)
          : Icon(FeatherIcons.penTool, color: AppColors.of(context).text.withOpacity(.25)),
      trailingDivider: true,
      trailing: Switch(
        onChanged: (v) async {
          settings.update(renamedSubjectsEnabled: v);
          await Provider.of<GradeProvider>(context, listen: false).convertBySettings();
          await Provider.of<TimetableProvider>(context, listen: false).convertBySettings();
          await Provider.of<AbsenceProvider>(context, listen: false).convertBySettings();
        },
        value: settings.renamedSubjectsEnabled,
        activeColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class ModifySubjectNames extends StatefulWidget {
  const ModifySubjectNames({Key? key}) : super(key: key);

  @override
  State<ModifySubjectNames> createState() => _ModifySubjectNamesState();
}

class _ModifySubjectNamesState extends State<ModifySubjectNames> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _subjectName = TextEditingController();
  String? selectedSubjectId;

  late List<Subject> subjects;
  late UserProvider user;
  late DatabaseProvider dbProvider;

  @override
  void initState() {
    super.initState();
    subjects = Provider.of<GradeProvider>(context, listen: false).grades.map((e) => e.subject).toSet().toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    user = Provider.of<UserProvider>(context, listen: false);
    dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
  }

  Future<Map<String, String>> fetchRenamedSubjects() async {
    return await dbProvider.userQuery.renamedSubjects(userId: user.id!);
  }

  void showRenameDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setS) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
          title: Text("Tantárgy átnevezése"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton2(
                items: subjects
                    .map((item) => DropdownMenuItem<String>(
                          value: item.id,
                          child: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.of(context).text,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                onChanged: (String? v) async {
                  final renamedSubs = await fetchRenamedSubjects();

                  setS(() {
                    selectedSubjectId = v;

                    if (renamedSubs.containsKey(selectedSubjectId)) {
                      _subjectName.text = renamedSubs[selectedSubjectId]!;
                    } else {
                      _subjectName.text = "";
                    }
                  });
                },
                iconSize: 14,
                iconEnabledColor: AppColors.of(context).text,
                iconDisabledColor: AppColors.of(context).text,
                underline: const SizedBox(),
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                buttonWidth: 50,
                dropdownWidth: 300,
                dropdownPadding: null,
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                dropdownElevation: 8,
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 6,
                scrollbarAlwaysShow: true,
                offset: const Offset(-10, -10),
                buttonSplashColor: Colors.transparent,
                customButton: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                  child: Text(
                    selectedSubjectId == null ? "Válassz tantárgyat" : subjects.firstWhere((element) => element.id == selectedSubjectId).name,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w700, color: AppColors.of(context).text.withOpacity(0.75)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Icon(FeatherIcons.arrowDown, size: 32),
              ),
              TextField(
                controller: _subjectName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                  hintText: "Módosított név",
                  suffixIcon: IconButton(
                    icon: const Icon(
                      FeatherIcons.x,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _subjectName.text = "";
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(
                "Mégse",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
            TextButton(
              child: const Text(
                "Kész",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onPressed: () async {
                if (selectedSubjectId != null) {
                  final renamedSubs = await fetchRenamedSubjects();

                  renamedSubs[selectedSubjectId!] = _subjectName.text;
                  await dbProvider.userStore.storeRenamedSubjects(renamedSubs, userId: user.id!);
                  await Provider.of<GradeProvider>(context, listen: false).convertBySettings();
                  await Provider.of<TimetableProvider>(context, listen: false).convertBySettings();
                  await Provider.of<AbsenceProvider>(context, listen: false).convertBySettings();
                }
                Navigator.of(context).pop(true);
                setState(() {});
              },
            ),
          ],
        );
      }),
    ).then((val) {
      _subjectName.text = "";
      selectedSubjectId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          leading: BackButton(color: AppColors.of(context).text),
          title: Text(
            "Tantárgyak átnevezése",
            style: TextStyle(color: AppColors.of(context).text),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: showRenameDialog,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
                    child: Center(
                      child: Text(
                        "Új tárgy átnevezése",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.of(context).text.withOpacity(.85),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                FutureBuilder<Map<String, String>>(
                  future: fetchRenamedSubjects(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return Container();

                    return Panel(
                      title: const Text("Átnevezett Tantárgyaid"),
                      child: Column(
                        children: snapshot.data!.keys.map(
                          (key) {
                            Subject? subject = subjects.firstWhere((element) => key == element.id);
                            String renameTo = snapshot.data![key]!;
                            return RenamedSubjectItem(
                              subject: subject,
                              renamedTo: renameTo,
                              modifyCallback: () {
                                setState(() {
                                  selectedSubjectId = subject.id;
                                  _subjectName.text = renameTo;
                                });
                                showRenameDialog();
                              },
                              removeCallback: () {
                                setState(() {
                                  Map<String, String> subs = Map.from(snapshot.data!);
                                  subs.remove(key);
                                  dbProvider.userStore.storeRenamedSubjects(subs, userId: user.id!);
                                });
                              },
                            );
                          },
                        ).toList(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class RenamedSubjectItem extends StatelessWidget {
  const RenamedSubjectItem({
    Key? key,
    required this.subject,
    required this.renamedTo,
    required this.modifyCallback,
    required this.removeCallback,
  }) : super(key: key);

  final Subject subject;
  final String renamedTo;
  final void Function() modifyCallback;
  final void Function() removeCallback;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 32.0,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      visualDensity: VisualDensity.compact,
      onTap: () {},
      leading: Icon(SubjectIcon.resolveVariant(subject: subject, context: context), color: AppColors.of(context).text.withOpacity(.75)),
      title: InkWell(
        onTap: modifyCallback,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject.name.capital(),
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: AppColors.of(context).text.withOpacity(.75)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              renamedTo,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      trailing: InkWell(
        onTap: removeCallback,
        child: Icon(FeatherIcons.trash, color: AppColors.of(context).red.withOpacity(.75)),
      ),
    );
  }
}
