import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// Shared by the splash and login logos so the mark flies between them.
const brandHeroTag = 'brand-logo';

/// Shown while the stored session is checked. The logo pulses until then,
/// unless the system asks for reduced motion.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  late final _scale = Tween<double>(begin: 0.92, end: 1.06).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulse.value = 0.5;
    } else if (!_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Semantics(
        label: UiLocalizations.of(context).loading,
        child: ScaleTransition(
          scale: _scale,
          child: const Hero(tag: brandHeroTag, child: BrandLogo.kasir(height: 56)),
        ),
      ),
    ),
  );
}
