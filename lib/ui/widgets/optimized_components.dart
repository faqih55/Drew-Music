/// Optimized glass card builder without expensive BackdropFilter
library;

import 'package:flutter/material.dart';

/// Performance-optimized version of glass card that avoids BackdropFilter
class OptimizedGlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;

  const OptimizedGlassCard({
    required this.child,
    this.borderRadius = 9999,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFCABEFF).withValues(alpha: 0.1),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

/// Light background overlay for modals
class ModalBackgroundOverlay extends StatelessWidget {
  final Widget child;

  const ModalBackgroundOverlay({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.black.withValues(alpha: 0.5), child: child);
  }
}
