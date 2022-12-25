import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "colorpicker_presets": "Presets",
          "colorpicker_background": "Background",
          "colorpicker_panels": "Panels",
          "colorpicker_accent": "Accent",
        },
        "hu_hu": {
          "colorpicker_presets": "Téma",
          "colorpicker_background": "Háttér",
          "colorpicker_panels": "Panelek",
          "colorpicker_accent": "Színtónus",
        },
        "de_de": {
          "colorpicker_presets": "Farben",
          "colorpicker_background": "Hintergrund",
          "colorpicker_panels": "Tafeln",
          "colorpicker_accent": "Akzent",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
