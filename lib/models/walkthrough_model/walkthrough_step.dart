import 'package:flutter/material.dart';

enum WalkthroughTooltipPosition { above, below, center }

class WalkthroughStep {
  final String id;
  final String title;
  final String description;
  final GlobalKey? targetKey;
  final int? tabIndex;
  final bool expandClassroom;
  final bool waitForTargetTap;
  final WalkthroughTooltipPosition tooltipPosition;
  final IconData? icon;

  const WalkthroughStep({
    required this.id,
    required this.title,
    required this.description,
    this.targetKey,
    this.tabIndex,
    this.expandClassroom = false,
    this.waitForTargetTap = false,
    this.tooltipPosition = WalkthroughTooltipPosition.below,
    this.icon,
  });
}
