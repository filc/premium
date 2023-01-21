import 'package:filcnaplo/icons/filc_icons.dart';
import 'package:flutter/material.dart';

enum PremiumFeature {
  gradestats,
  customcolors,
  profile,
  weeklytimetable,
  goalplanner,
}

enum PremiumFeatureLevel { kupak, tinta }

const Map<PremiumFeature, PremiumFeatureLevel> _featureLevels = {
  PremiumFeature.gradestats: PremiumFeatureLevel.kupak,
  PremiumFeature.customcolors: PremiumFeatureLevel.kupak,
  PremiumFeature.profile: PremiumFeatureLevel.kupak,
  PremiumFeature.weeklytimetable: PremiumFeatureLevel.tinta,
  PremiumFeature.goalplanner: PremiumFeatureLevel.tinta,
};

const Map<PremiumFeature, String> _featureAssets = {
  PremiumFeature.gradestats: "assets/images/premium_stats_showcase.png",
  PremiumFeature.customcolors: "assets/images/premium_theme_showcase.png",
  PremiumFeature.profile: "assets/images/premium_nickname_showcase.png",
  PremiumFeature.weeklytimetable: "assets/images/premium_timetable_showcase.png",
  PremiumFeature.goalplanner: "assets/images/premium_goal_showcase.png",
};

const Map<PremiumFeature, String> _featureTitles = {
  PremiumFeature.gradestats: "Találtál egy prémium funkciót.",
  PremiumFeature.customcolors: "Több személyre szabás kell?",
  PremiumFeature.profile: "Nem tetszik a neved?",
  PremiumFeature.weeklytimetable: "Szeretnéd egyszerre az egész hetet látni?",
  PremiumFeature.goalplanner: "Kövesd a céljaidat, sok-sok statisztikával.",
};

const Map<PremiumFeature, String> _featureDescriptions = {
  PremiumFeature.gradestats: "Támogass Kupak szinten, hogy több statisztikát láthass. ",
  PremiumFeature.customcolors: "Támogass Kupak szinten, és szabd személyre az elemek, a háttér, és a panelek színeit.",
  PremiumFeature.profile: "Kupak szinten változtathatod a nevedet, sőt, akár a profilképedet is.",
  PremiumFeature.weeklytimetable: "Támogass Tinta szinten a heti órarend funkcióért.",
  PremiumFeature.goalplanner: "A célkövetéshez támogass Tinta szinten.",
};

class PremiumLockedFeatureUpsell extends StatelessWidget {
  const PremiumLockedFeatureUpsell({super.key, required this.feature});

  static void show({required BuildContext context, required PremiumFeature feature}) =>
      showDialog(context: context, builder: (context) => PremiumLockedFeatureUpsell(feature: feature));

  final PremiumFeature feature;

  IconData _getIcon() => _featureLevels[feature] == PremiumFeatureLevel.kupak ? FilcIcons.kupak : FilcIcons.tinta;
  Color _getColor(BuildContext context) => _featureLevels[feature] == PremiumFeatureLevel.kupak
      ? const Color(0xffC8A708)
      : Theme.of(context).brightness == Brightness.light
          ? const Color(0xff691A9B)
          : const Color(0xffA66FC8);
  String _getAsset() => _featureAssets[feature]!;
  String _getTitle() => _featureTitles[feature]!;
  String _getDescription() => _featureDescriptions[feature]!;

  @override
  Widget build(BuildContext context) {
    final Color color = _getColor(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(_getIcon()),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            // Image showcase
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.asset(_getAsset()),
            ),

            // Dialog title
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                _getTitle(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),

            // Dialog description
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _getDescription(),
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),

            // CTA button
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(color.withOpacity(.25)),
                      foregroundColor: MaterialStatePropertyAll(color),
                      overlayColor: MaterialStatePropertyAll(color.withOpacity(.1))),
                  onPressed: () {
                    // navigate to premium screen
                  },
                  child: const Text(
                    "Vigyél oda!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
