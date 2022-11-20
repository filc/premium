import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/accent.dart';
import 'package:filcnaplo/theme/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_screen.i18n.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class PremiumCustomAccentColorSetting extends StatefulWidget {
  const PremiumCustomAccentColorSetting({Key? key}) : super(key: key);

  @override
  State<PremiumCustomAccentColorSetting> createState() => _PremiumCustomAccentColorSettingState();
}

enum CustomColorMode { accent, background, highlight }

class _PremiumCustomAccentColorSettingState extends State<PremiumCustomAccentColorSetting> {
  late final SettingsProvider settings;
  bool colorSelection = false;
  bool customColorMenu = false;
  CustomColorMode? colorMode;

  @override
  void initState() {
    super.initState();
    settings = Provider.of<SettingsProvider>(context, listen: false);
  }

  void setTheme(mode) {
    settings.update(theme: mode);
    Provider.of<ThemeModeObserver>(context, listen: false).changeTheme(mode);
  }

  Color? getCustomColor() {
    switch (colorMode) {
      case CustomColorMode.background:
        return settings.customBackgroundColor;
      case CustomColorMode.highlight:
        return settings.customHighlightColor;
      case CustomColorMode.accent:
      default:
        return settings.customAccentColor;
    }
  }

  void updateCustomColor(Color v) {
    switch (colorMode) {
      case CustomColorMode.background:
        settings.update(customBackgroundColor: v);
        break;
      case CustomColorMode.highlight:
        settings.update(customHighlightColor: v);
        break;
      case CustomColorMode.accent:
      default:
        settings.update(customAccentColor: v);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (colorSelection && colorMode != null) {
      return MaterialColorPicker(
        selectedColor: getCustomColor(),
        onColorChange: (v) {
          setState(() {
            updateCustomColor(v);
          });
          setTheme(settings.theme);
        },
        allowShades: true,
        elevation: 0,
        physics: const NeverScrollableScrollPhysics(),
        onBack: () {
          setTheme(settings.theme);
          Navigator.of(context).maybePop();
        },
      );
    }

    if (customColorMenu) {
      return Column(
        children: [
          TextButton(
            child: Text("Accent Color".i18n),
            onPressed: () {
              setState(() {
                colorSelection = true;
                colorMode = colorMode = CustomColorMode.accent;
              });
            },
          ),
          TextButton(
            child: Text("Background Color".i18n),
            onPressed: () {
              setState(() {
                colorSelection = true;
                colorMode = colorMode = CustomColorMode.background;
              });
            },
          ),
          TextButton(
            child: Text("Highlight Color".i18n),
            onPressed: () {
              setState(() {
                colorSelection = true;
                colorMode = colorMode = CustomColorMode.highlight;
              });
            },
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
      child: Center(
        child: Column(
          children: [
            SwitchListTile(
              contentPadding: const EdgeInsets.only(left: 32.0, right: 24.0, bottom: 12.0),
              title: Text("Adaptive Theme".i18n),
              value: settings.accentColor == AccentColor.adaptive,
              onChanged: (v) {
                // MARK PREMIUM
                setState(() {
                  if (v) {
                    settings.update(accentColor: AccentColor.adaptive);
                  } else {
                    settings.update(accentColor: AccentColor.filc);
                  }
                  setTheme(settings.theme);
                });
              },
            ),
            Wrap(
              alignment: WrapAlignment.start,
              children: List.generate(AccentColor.values.length, (index) {
                if (AccentColor.values[index] == AccentColor.adaptive) {
                  return const SizedBox();
                }

                if (AccentColor.values[index] == AccentColor.custom) {
                  // MARK PREMIUM
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipOval(
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            settings.update(accentColor: AccentColor.values[index]);
                            setState(() {
                              customColorMenu = true;
                            });
                          },
                          child: Container(
                            width: 54.0,
                            height: 54.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: SweepGradient(
                                colors: [
                                  Colors.red,
                                  Colors.orange,
                                  Colors.yellow,
                                  Colors.green,
                                  Colors.blue,
                                  Colors.purple,
                                  Colors.red,
                                ],
                              ),
                            ),
                            child: AccentColor.values[index] == settings.accentColor
                                ? const Center(
                                    child: Icon(FeatherIcons.check, color: Colors.white, size: 32.0),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipOval(
                    child: Material(
                      color: accentColorMap[AccentColor.values[index]],
                      child: InkWell(
                        onTap: () {
                          settings.update(accentColor: AccentColor.values[index]);
                          setTheme(settings.theme);
                          Navigator.of(context).maybePop();
                        },
                        child: Container(
                          width: 54.0,
                          height: 54.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: settings.accentColor == AccentColor.values[index]
                              ? Icon(FeatherIcons.check, color: Colors.black.withOpacity(0.7))
                              : null,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
