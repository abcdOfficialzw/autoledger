import 'dart:ui';

import 'package:flutter/material.dart';

class LiquidOrb {
  const LiquidOrb({
    required this.diameter,
    required this.color,
    this.top,
    this.left,
    this.right,
    this.bottom,
  });

  final double diameter;
  final Color color;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
}

class LiquidBackdrop extends StatelessWidget {
  const LiquidBackdrop({
    super.key,
    required this.child,
    this.colors = const [
      Color(0xFFE2F3EF),
      Color(0xFFF3F8FF),
      Color(0xFFF6F5FF),
    ],
    this.orbs = const [],
  });

  final Widget child;
  final List<Color> colors;
  final List<LiquidOrb> orbs;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
            ),
          ),
        ),
        for (final orb in orbs)
          Positioned(
            top: orb.top,
            left: orb.left,
            right: orb.right,
            bottom: orb.bottom,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: orb.color,
                ),
                child: SizedBox(width: orb.diameter, height: orb.diameter),
              ),
            ),
          ),
        Positioned.fill(child: child),
      ],
    );
  }
}

class LiquidGlassCard extends StatelessWidget {
  const LiquidGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 24,
    this.sigma = 12,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double sigma;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.66),
                Colors.white.withValues(alpha: 0.42),
              ],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class LiquidInsetCard extends StatelessWidget {
  const LiquidInsetCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.radius = 16,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.white.withValues(alpha: 0.58),
        border: Border.all(color: Colors.white.withValues(alpha: 0.76)),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
