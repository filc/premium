import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/grades_page.i18n.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

final List<List<dynamic>> avgDropItems = [
  ["annual_average".i18n, 0],
  ["3_months_average".i18n, 90],
  ["30_days_average".i18n, 30],
  ["14_days_average".i18n, 14],
  ["7_days_average".i18n, 7],
];

class PremiumAverageSelector extends StatelessWidget {
  const PremiumAverageSelector({Key? key, this.onChanged, required this.value}) : super(key: key);

  final Function(String?)? onChanged;
  final int value;

  @override
  Widget build(BuildContext context) {
    return DropdownButton2(
      items: avgDropItems
          .map((item) => DropdownMenuItem<String>(
                value: item[0],
                child: Text(
                  item[0],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      onChanged: onChanged,
      iconSize: 14,
      iconEnabledColor: Colors.grey,
      iconDisabledColor: Colors.grey,
      underline: const SizedBox(),
      itemHeight: 40,
      itemPadding: const EdgeInsets.only(left: 14, right: 14),
      dropdownWidth: 200,
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
      customButton: SizedBox(
        height: 30,
        child: Row(
          children: [
            Text(avgDropItems[value][0],
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w600, color: AppColors.of(context).text.withOpacity(0.65))),
            const SizedBox(
              width: 4,
            ),
            const Icon(
              FeatherIcons.chevronDown,
              size: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
