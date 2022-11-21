import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/accent.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/theme/observer.dart';
import 'package:filcnaplo_premium/models/premium_scopes.dart';
import 'package:filcnaplo_premium/providers/premium_provider.dart';
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
  final customColorInput = TextEditingController();

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
    settings.update(accentColor: AccentColor.custom);
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
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              controller: customColorInput,
              decoration: InputDecoration(
                hintText: "#aabbcc",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    final color = Color(int.parse("ff" + customColorInput.text.replaceAll("#", "").substring(0, 6), radix: 16));
                    setState(() {
                      updateCustomColor(color);
                    });
                    setTheme(settings.theme);
                  },
                ),
              ),
            ),
          ),
          MaterialColorPicker(
            selectedColor: getCustomColor(),
            onColorChange: (v) {
              setState(() {
                updateCustomColor(v);
              });
              setTheme(settings.theme);
            },
            allowShades: true,
            onlyShadeSelection: true,
            elevation: 0,
            physics: const NeverScrollableScrollPhysics(),
            onBack: () {
              setTheme(settings.theme);
              Navigator.of(context).maybePop();
            },
          ),
        ],
      );
    }

    String convertHex(Color? color) => color != null ? "#${(color.value - 0xff000000).toRadixString(16).padLeft(6, '0')}" : "#000000";

    if (customColorMenu) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumColorPickerItem(
            label: "Accent Color".i18n,
            color: Theme.of(context).colorScheme.secondary,
            onTap: () {
              setState(() {
                colorSelection = true;
                colorMode = CustomColorMode.accent;
                customColorInput.text = convertHex(settings.customAccentColor);
              });
            },
          ),
          PremiumColorPickerItem(
            label: "Background Color".i18n,
            color: Theme.of(context).scaffoldBackgroundColor,
            onTap: () {
              setState(() {
                colorSelection = true;
                colorMode = CustomColorMode.background;
                customColorInput.text = convertHex(settings.customBackgroundColor);
              });
            },
          ),
          PremiumColorPickerItem(
            label: "Highlight Color".i18n,
            color: Theme.of(context).backgroundColor,
            onTap: () {
              setState(() {
                colorSelection = true;
                colorMode = CustomColorMode.highlight;
                customColorInput.text = convertHex(settings.customHighlightColor);
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
                  if (!Provider.of<PremiumProvider>(context).hasScope(PremiumScopes.customColors)) {
                    return const SizedBox(); // TODO: premium upsell
                  }

                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipOval(
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
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
