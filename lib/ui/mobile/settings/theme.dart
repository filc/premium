import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/accent.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/theme/observer.dart';
import 'package:filcnaplo/ui/widgets/grade/grade_tile.dart';
import 'package:filcnaplo/ui/widgets/message/message_tile.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/homework.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_mobile_ui/common/filter_bar.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade/new_grades.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/homework/homework_tile.dart';
import 'package:filcnaplo_premium/ui/mobile/flutter_colorpicker/colorpicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PremiumCustomAccentColorSetting extends StatefulWidget {
  const PremiumCustomAccentColorSetting({Key? key}) : super(key: key);

  @override
  State<PremiumCustomAccentColorSetting> createState() => _PremiumCustomAccentColorSettingState();
}

enum CustomColorMode { theme, accent, background, highlight }

class _PremiumCustomAccentColorSettingState extends State<PremiumCustomAccentColorSetting> with TickerProviderStateMixin {
  late final SettingsProvider settings;
  bool colorSelection = false;
  bool customColorMenu = false;
  CustomColorMode colorMode = CustomColorMode.theme;
  final customColorInput = TextEditingController();

  late TabController _testTabController;
  late TabController _colorsTabController;

  @override
  void initState() {
    super.initState();
    _colorsTabController = TabController(length: 4, vsync: this);
    _testTabController = TabController(length: 4, vsync: this);
    settings = Provider.of<SettingsProvider>(context, listen: false);
  }

  void setTheme(ThemeMode mode, bool store) {
    settings.update(theme: mode, store: store);
    Provider.of<ThemeModeObserver>(context, listen: false).changeTheme(mode);
  }

  Color? getCustomColor() {
    switch (colorMode) {
      case CustomColorMode.theme:
        return accentColorMap[settings.accentColor];
      case CustomColorMode.background:
        return settings.customBackgroundColor;
      case CustomColorMode.highlight:
        return settings.customHighlightColor;
      case CustomColorMode.accent:
        return settings.customAccentColor;
    }
  }

  void updateCustomColor(Color v, bool store) {
    if (colorMode != CustomColorMode.theme) settings.update(accentColor: AccentColor.custom, store: store);
    switch (colorMode) {
      case CustomColorMode.theme:
        settings.update(
            accentColor: accentColorMap.keys.firstWhere((element) => accentColorMap[element] == v, orElse: () => AccentColor.filc), store: store);
        settings.update(customBackgroundColor: AppColors.of(context).background, store: store);
        settings.update(customHighlightColor: AppColors.of(context).highlight, store: store);
        settings.update(customAccentColor: v, store: store);
        break;
      case CustomColorMode.background:
        settings.update(customBackgroundColor: v, store: store);
        break;
      case CustomColorMode.highlight:
        settings.update(customHighlightColor: v, store: store);
        break;
      case CustomColorMode.accent:
        settings.update(customAccentColor: v, store: store);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.of(context).highlight,
      ));
    }

    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).colorScheme.background,
        ));
        return true;
      },
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.of(context).background,
            leading: BackButton(color: AppColors.of(context).text),
            title: Text(
              "Preview",
              style: TextStyle(color: AppColors.of(context).text),
            ),
          ),
          body: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
                margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              ),
              Column(
                children: [
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(0, 25),
                      child: Transform.scale(
                        scale: 0.9,
                        child: SizedBox(
                          width: double.infinity,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 6.0),
                                  child: FilterBar(
                                    items: const [
                                      Tab(text: "All"),
                                      Tab(text: "Grades"),
                                      Tab(text: "Messages"),
                                      Tab(text: "Absences"),
                                    ],
                                    controller: _testTabController,
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                                  child: NewGradesSurprise(
                                    [
                                      Grade.fromJson(
                                        {
                                          "Uid": "0,Ertekeles",
                                          "RogzitesDatuma": "2022-01-01T23:00:00Z",
                                          "KeszitesDatuma": "2022-01-01T23:00:00Z",
                                          "LattamozasDatuma": null,
                                          "Tantargy": {
                                            "Uid": "0",
                                            "Nev": "Filc szakirodalom",
                                            "Kategoria": {"Uid": "0,_", "Nev": "_", "Leiras": "Nem mondom meg"},
                                            "SortIndex": 2
                                          },
                                          "Tema": "Kupak csomag vásárlás vizsga",
                                          "Tipus": {
                                            "Uid": "0,_",
                                            "Nev": "_",
                                            "Leiras": "Évközi jegy/értékelés",
                                          },
                                          "Mod": {
                                            "Uid": "0,_",
                                            "Nev": "_",
                                            "Leiras": "_ feladat",
                                          },
                                          "ErtekFajta": {
                                            "Uid": "1,Osztalyzat",
                                            "Nev": "Osztalyzat",
                                            "Leiras": "Elégtelen (1) és Jeles (5) között az öt alapértelmezett érték"
                                          },
                                          "ErtekeloTanarNeve": "Premium",
                                          "Jelleg": "Ertekeles",
                                          "SzamErtek": 5,
                                          "SzovegesErtek": "Jeles(5)",
                                          "SulySzazalekErteke": 100,
                                          "SzovegesErtekelesRovidNev": null,
                                          "OsztalyCsoport": {"Uid": "0"},
                                          "SortIndex": 2
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                                  child: Panel(
                                    child: GradeTile(
                                      Grade.fromJson(
                                        {
                                          "Uid": "0,Ertekeles",
                                          "RogzitesDatuma": "2022-01-01T23:00:00Z",
                                          "KeszitesDatuma": "2022-01-01T23:00:00Z",
                                          "LattamozasDatuma": null,
                                          "Tantargy": {
                                            "Uid": "0",
                                            "Nev": "Filc szakosztály",
                                            "Kategoria": {"Uid": "0,_", "Nev": "_", "Leiras": "Nem mondom meg"},
                                            "SortIndex": 2
                                          },
                                          "Tema": "Kupak csomag vásárlás vizsga",
                                          "Tipus": {
                                            "Uid": "0,_",
                                            "Nev": "_",
                                            "Leiras": "Évközi jegy/értékelés",
                                          },
                                          "Mod": {
                                            "Uid": "0,_",
                                            "Nev": "_",
                                            "Leiras": "_ feladat",
                                          },
                                          "ErtekFajta": {
                                            "Uid": "1,Osztalyzat",
                                            "Nev": "Osztalyzat",
                                            "Leiras": "Elégtelen (1) és Jeles (5) között az öt alapértelmezett érték"
                                          },
                                          "ErtekeloTanarNeve": "Premium",
                                          "Jelleg": "Ertekeles",
                                          "SzamErtek": 5,
                                          "SzovegesErtek": "Jeles(5)",
                                          "SulySzazalekErteke": 100,
                                          "SzovegesErtekelesRovidNev": null,
                                          "OsztalyCsoport": {"Uid": "0"},
                                          "SortIndex": 2
                                        },
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                                  child: Panel(
                                    child: HomeworkTile(
                                      Homework.fromJson(
                                        {
                                          "Uid": "0",
                                          "Tantargy": {
                                            "Uid": "0",
                                            "Nev": "Filc premium előnyei",
                                            "Kategoria": {
                                              "Uid": "0,_",
                                              "Nev": "_",
                                              "Leiras": "Filc premium előnyei",
                                            },
                                            "SortIndex": 0
                                          },
                                          "TantargyNeve": "Filc premium előnyei",
                                          "RogzitoTanarNeve": "Kupak János",
                                          "Szoveg": "45 perc filctollal való rajzolás",
                                          "FeladasDatuma": "2022-01-01T23:00:00Z",
                                          "HataridoDatuma": "2022-01-01T23:00:00Z",
                                          "RogzitesIdopontja": "2022-01-01T23:00:00Z",
                                          "IsTanarRogzitette": true,
                                          "IsTanuloHaziFeladatEnabled": false,
                                          "IsMegoldva": false,
                                          "IsBeadhato": false,
                                          "OsztalyCsoport": {"Uid": "0"},
                                          "IsCsatolasEngedelyezes": false
                                        },
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                                  child: Panel(
                                    child: MessageTile(
                                      Message.fromJson(
                                        {
                                          "azonosito": 0,
                                          "isElolvasva": true,
                                          "isToroltElem": false,
                                          "tipus": {
                                            "azonosito": 1,
                                            "kod": "BEERKEZETT",
                                            "rovidNev": "Beérkezett üzenet",
                                            "nev": "Beérkezett üzenet",
                                            "leiras": "Beérkezett üzenet"
                                          },
                                          "uzenet": {
                                            "azonosito": 0,
                                            "kuldesDatum": "2022-01-01T23:00:00",
                                            "feladoNev": "Filc Napló",
                                            "feladoTitulus": "Nagyon magas szintű személy",
                                            "szoveg":
                                                "<p>Kedves Felhasználó!</p><p><br></p><p>A prémium vásárlásakor kapott filctollal 90%-al több esély van jó jegyek szerzésére.</p>",
                                            "targy": "Filctoll használati útmutató",
                                            "statusz": {
                                              "azonosito": 2,
                                              "kod": "KIKULDVE",
                                              "rovidNev": "Kiküldve",
                                              "nev": "Kiküldve",
                                              "leiras": "Kiküldve"
                                            },
                                            "cimzettLista": [
                                              {
                                                "azonosito": 0,
                                                "kretaAzonosito": 0,
                                                "nev": "Tinta Józsi",
                                                "tipus": {"azonosito": 0, "kod": "TANULO", "rovidNev": "Tanuló", "nev": "Tanuló", "leiras": "Tanuló"}
                                              },
                                            ],
                                            "csatolmanyok": [
                                              {"azonosito": 0, "fajlNev": "Filctoll.doc"}
                                            ]
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                                  child: Panel(
                                    child: MessageTile(
                                      Message.fromJson(
                                        {
                                          "azonosito": 0,
                                          "isElolvasva": true,
                                          "isToroltElem": false,
                                          "tipus": {
                                            "azonosito": 1,
                                            "kod": "BEERKEZETT",
                                            "rovidNev": "Beérkezett üzenet",
                                            "nev": "Beérkezett üzenet",
                                            "leiras": "Beérkezett üzenet"
                                          },
                                          "uzenet": {
                                            "azonosito": 0,
                                            "kuldesDatum": "2022-01-01T23:00:00",
                                            "feladoNev": "Filc Napló",
                                            "feladoTitulus": "Nagyon magas szintű személy",
                                            "szoveg":
                                                "<p>Kedves Felhasználó!</p><p><br></p><p>A prémium vásárlásakor kapott filctollal 90%-al több esély van jó jegyek szerzésére.</p>",
                                            "targy": "Filctoll használati útmutató",
                                            "statusz": {
                                              "azonosito": 2,
                                              "kod": "KIKULDVE",
                                              "rovidNev": "Kiküldve",
                                              "nev": "Kiküldve",
                                              "leiras": "Kiküldve"
                                            },
                                            "cimzettLista": [
                                              {
                                                "azonosito": 0,
                                                "kretaAzonosito": 0,
                                                "nev": "Tinta Józsi",
                                                "tipus": {"azonosito": 0, "kod": "TANULO", "rovidNev": "Tanuló", "nev": "Tanuló", "leiras": "Tanuló"}
                                              },
                                            ],
                                            "csatolmanyok": [
                                              {"azonosito": 0, "fajlNev": "Filctoll.doc"}
                                            ]
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                                  child: Panel(
                                    child: MessageTile(
                                      Message.fromJson(
                                        {
                                          "azonosito": 0,
                                          "isElolvasva": true,
                                          "isToroltElem": false,
                                          "tipus": {
                                            "azonosito": 1,
                                            "kod": "BEERKEZETT",
                                            "rovidNev": "Beérkezett üzenet",
                                            "nev": "Beérkezett üzenet",
                                            "leiras": "Beérkezett üzenet"
                                          },
                                          "uzenet": {
                                            "azonosito": 0,
                                            "kuldesDatum": "2022-01-01T23:00:00",
                                            "feladoNev": "Filc Napló",
                                            "feladoTitulus": "Nagyon magas szintű személy",
                                            "szoveg":
                                                "<p>Kedves Felhasználó!</p><p><br></p><p>A prémium vásárlásakor kapott filctollal 90%-al több esély van jó jegyek szerzésére.</p>",
                                            "targy": "Filctoll használati útmutató",
                                            "statusz": {
                                              "azonosito": 2,
                                              "kod": "KIKULDVE",
                                              "rovidNev": "Kiküldve",
                                              "nev": "Kiküldve",
                                              "leiras": "Kiküldve"
                                            },
                                            "cimzettLista": [
                                              {
                                                "azonosito": 0,
                                                "kretaAzonosito": 0,
                                                "nev": "Tinta Józsi",
                                                "tipus": {"azonosito": 0, "kod": "TANULO", "rovidNev": "Tanuló", "nev": "Tanuló", "leiras": "Tanuló"}
                                              },
                                            ],
                                            "csatolmanyok": [
                                              {"azonosito": 0, "fajlNev": "Filctoll.doc"}
                                            ]
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.of(context).highlight.withOpacity(.75),
                            offset: const Offset(0, -4),
                            blurRadius: 16,
                            spreadRadius: 12,
                          ),
                        ],
                        color: AppColors.of(context).highlight,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FilterBar(
                              items: [
                                ColorTab(color: accentColorMap[settings.accentColor] ?? Colors.black, tab: const Tab(text: "Téma")),
                                ColorTab(color: settings.customBackgroundColor ?? Colors.black, tab: const Tab(text: "Háttér")),
                                ColorTab(color: settings.customHighlightColor ?? Colors.black, tab: const Tab(text: "Panel")),
                                ColorTab(color: settings.customAccentColor ?? Colors.black, tab: const Tab(text: "Elem")),
                              ],
                              onTap: (i) => {
                                if (i == 0)
                                  {
                                    setState(() {
                                      colorMode = CustomColorMode.theme;
                                    })
                                  }
                                else if (i == 1)
                                  {
                                    setState(() {
                                      colorMode = CustomColorMode.background;
                                    })
                                  }
                                else if (i == 2)
                                  {
                                    setState(() {
                                      colorMode = CustomColorMode.highlight;
                                    })
                                  }
                                else
                                  {
                                    {
                                      setState(() {
                                        colorMode = CustomColorMode.accent;
                                      })
                                    }
                                  }
                              },
                              controller: _colorsTabController,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          FilcColorPicker(
                            colorMode: colorMode,
                            pickerColor: colorMode == CustomColorMode.accent
                                ? settings.customAccentColor ?? Colors.black
                                : colorMode == CustomColorMode.background
                                    ? settings.customBackgroundColor ?? Colors.black
                                    : colorMode == CustomColorMode.theme
                                        ? (accentColorMap[settings.accentColor] ?? AppColors.of(context).text) // idk what else
                                        : settings.customHighlightColor ?? Colors.black,
                            onColorChanged: (c) {
                              //print("colormode:" + colorMode.name.toString());
                              setState(() {
                                updateCustomColor(c, false);
                              });
                              setTheme(settings.theme, false);
                            },
                            onColorChangeEnd: (c, {adaptive}) {
                              setState(() {
                                if (adaptive == true) {
                                  settings.update(accentColor: AccentColor.adaptive);
                                  settings.update(customBackgroundColor: AppColors.of(context).background, store: true);
                                  settings.update(customHighlightColor: AppColors.of(context).highlight, store: true);
                                } else {
                                  updateCustomColor(c, true);
                                }
                              });
                              setTheme(settings.theme, true);
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorTab extends StatelessWidget {
  const ColorTab({Key? key, required this.tab, required this.color}) : super(key: key);

  final Tab tab;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.translate(
          offset: const Offset(-3, 1),
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(color: Colors.black, width: 2.0),
            ),
          ),
        ),
        tab
      ],
    );
  }
}

class PremiumColorPickerItem extends StatelessWidget {
  const PremiumColorPickerItem({Key? key, required this.label, this.onTap, required this.color}) : super(key: key);

  final String label;
  final void Function()? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: AppColors.of(context).text, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all()),
              ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
