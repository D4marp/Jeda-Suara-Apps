import 'package:flutter/material.dart';

import '../../../core/app_info.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/palette.dart';

/// Layar pembuka: wordmark tipografis, titik aksen muncul terakhir.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    const words = appNameParts;

    return Scaffold(
      backgroundColor: p.paper,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Align(
          alignment: const Alignment(-1, 0.1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < words.length; i++)
                _Reveal(
                  delay: i * 140,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: words[i]),
                        if (i == words.length - 1)
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: _Dot(color: p.accent),
                          ),
                      ],
                    ),
                    style: AppText.display(p.ink, size: 72),
                  ),
                ),
              const SizedBox(height: 20),
              _Reveal(
                delay: 420,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(
                    appMotto,
                    style: TextStyle(
                      color: p.muted,
                      fontSize: 16,
                      height: 1.5,
                      fontFamily: 'Georgia',
                      fontFamilyFallback: const ['serif'],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Reveal extends StatelessWidget {
  const _Reveal({required this.child, required this.delay});

  final Widget child;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 520 + delay),
      curve: Interval(
        delay / (520 + delay),
        1,
        curve: Curves.easeOutCubic,
      ),
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, 16 * (1 - t)), child: child),
      ),
      child: child,
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: const Interval(0.55, 1, curve: Curves.elasticOut),
      builder: (context, t, _) => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Transform.scale(
          scale: t,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
