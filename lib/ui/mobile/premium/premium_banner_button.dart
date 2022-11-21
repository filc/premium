import 'package:filcnaplo/icons/filc_icons.dart';
import 'package:filcnaplo_premium/providers/premium_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PremiumBannerButton extends StatefulWidget {
  const PremiumBannerButton({Key? key}) : super(key: key);

  @override
  State<PremiumBannerButton> createState() => _PremiumBannerButtonState();
}

class _PremiumBannerButtonState extends State<PremiumBannerButton> with SingleTickerProviderStateMixin {
  late final AnimationController _animation;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animation.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final premium = Provider.of<PremiumProvider>(context);

    if (premium.hasPremium) {
      return const SizedBox();
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          height: 64,
          child: Stack(
            children: [
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      gradient: GradientTween(
                        begin: const LinearGradient(
                            colors: [Color(0xff54BBA6), Color(0xff107563)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        end: const LinearGradient(
                            colors: [Color(0xff107563), Color(0xff54BBA6)], begin: Alignment.topRight, end: Alignment.bottomLeft),
                      ).animate(_animation).value,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xff107563),
                          blurRadius: 14.0,
                        )
                      ]),
                  child: child),
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14.0),
                  onTap: () {
                    premium.auth.initAuth();
                    showDialog(
                      context: context,
                      useRootNavigator: true,
                      builder: (context) {
                        final premium = Provider.of<PremiumProvider>(context);

                        if (premium.hasPremium) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.of(context, rootNavigator: true).maybePop();
                          });
                        }

                        return AlertDialog(
                          title: const Text("Premium auth token"),
                          content: TextField(
                            onSubmitted: (token) => premium.auth.finishAuth(token),
                          ),
                        );
                      },
                    );
                  },
                  child: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(FilcIcons.premium),
          SizedBox(width: 16.0),
          Text(
            "Get Premium",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
        ],
      ),
    );
  }
}

class GradientTween extends Tween<Gradient> {
  GradientTween({
    required Gradient begin,
    required Gradient end,
  }) : super(begin: begin, end: end);

  @override
  Gradient lerp(double t) => Gradient.lerp(begin, end, t)!;
}
