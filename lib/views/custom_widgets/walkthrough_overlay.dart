import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/controllers/walkthrough_controller.dart';
import 'package:test_your_learing/models/walkthrough_model/walkthrough_step.dart';

class WalkthroughOverlay extends StatefulWidget {
  const WalkthroughOverlay({super.key});

  @override
  State<WalkthroughOverlay> createState() => _WalkthroughOverlayState();
}

class _WalkthroughOverlayState extends State<WalkthroughOverlay> {
  final WalkthroughController _controller = Get.find<WalkthroughController>();
  Rect? _targetRect;

  @override
  void initState() {
    super.initState();
    ever(_controller.currentStepIndex, (_) => _updateTargetRect());
    ever(_controller.isActive, (active) {
      if (active) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _updateTargetRect());
      }
    });
  }

  void _updateTargetRect() {
    if (!_controller.isActive.value) return;

    final step = _controller.currentStep;
    if (step.targetKey == null) {
      setState(() => _targetRect = null);
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final context = step.targetKey!.currentContext;
      if (context == null) {
        setState(() => _targetRect = null);
        return;
      }
      final box = context.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) {
        setState(() => _targetRect = null);
        return;
      }
      final offset = box.localToGlobal(Offset.zero);
      setState(() {
        _targetRect = offset & box.size;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!_controller.isActive.value) return const SizedBox.shrink();

      final step = _controller.currentStep;
      final isCentered = step.tooltipPosition == WalkthroughTooltipPosition.center;

      return LayoutBuilder(
        builder: (context, constraints) {
          _scheduleRectUpdate();

          return Stack(
            children: [
              if (isCentered)
                _buildFullOverlay()
              else
                ..._buildSpotlightRegions(constraints.biggest),
              _buildTooltipCard(context, step, constraints.biggest),
            ],
          );
        },
      );
    });
  }

  void _scheduleRectUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateTargetRect());
  }

  Widget _buildFullOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {},
        child: Container(color: Colors.black.withValues(alpha: 0.72)),
      ),
    );
  }

  List<Widget> _buildSpotlightRegions(Size screenSize) {
    const padding = 10.0;
    final rect = _targetRect;

    if (rect == null) {
      return [
        Positioned.fill(
          child: Container(color: Colors.black.withValues(alpha: 0.72)),
        ),
      ];
    }

    final hole = Rect.fromLTWH(
      rect.left - padding,
      rect.top - padding,
      rect.width + padding * 2,
      rect.height + padding * 2,
    );

    final allowTapThrough =
        _controller.currentStep.waitForTargetTap &&
        !_controller.targetInteractionDone.value;

    Widget region({
      required double left,
      required double top,
      required double width,
      required double height,
    }) {
      return Positioned(
        left: left,
        top: top,
        width: width,
        height: height,
        child: GestureDetector(
          onTap: () {},
          child: Container(color: Colors.black.withValues(alpha: 0.72)),
        ),
      );
    }

    final regions = <Widget>[
      region(left: 0, top: 0, width: screenSize.width, height: hole.top),
      region(
        left: 0,
        top: hole.bottom,
        width: screenSize.width,
        height: screenSize.height - hole.bottom,
      ),
      region(
        left: 0,
        top: hole.top,
        width: hole.left,
        height: hole.height,
      ),
      region(
        left: hole.right,
        top: hole.top,
        width: screenSize.width - hole.right,
        height: hole.height,
      ),
      Positioned(
        left: hole.left,
        top: hole.top,
        width: hole.width,
        height: hole.height,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: primarycolor, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: primarycolor.withValues(alpha: 0.35),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: allowTapThrough
              ? GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _controller.onTargetTapped,
                  child: const SizedBox.expand(),
                )
              : null,
        ),
      ),
    ];

    return regions;
  }

  Widget _buildTooltipCard(
    BuildContext context,
    WalkthroughStep step,
    Size screenSize,
  ) {
    final isCentered = step.tooltipPosition == WalkthroughTooltipPosition.center;
    final isLast = _controller.isLastStep;
    final canNext = _controller.canGoNext;
    final showTryPrompt =
        step.waitForTargetTap && !_controller.targetInteractionDone.value;

    final card = Material(
      color: Colors.transparent,
      child: Container(
        width: isCentered ? screenSize.width * 0.88 : screenSize.width * 0.9,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (step.icon != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primarycolor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(step.icon, color: primarycolor, size: 22),
                  ),
                if (step.icon != null) const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                if (!isCentered)
                  Text(
                    '${_controller.currentStepIndex.value + 1}/${_controller.steps.length}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: graytext,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              step.description,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: graytext,
              ),
            ),
            if (showTryPrompt) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.touch_app_rounded, size: 16, color: primarycolor),
                  const SizedBox(width: 6),
                  Text(
                    'Tap the highlighted area to try it',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: primarycolor,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                if (!isLast)
                  TextButton(
                    onPressed: _controller.skip,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: graytext,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const Spacer(),
                if (!_controller.isFirstStep && !isLast)
                  TextButton(
                    onPressed: _controller.previous,
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: primarycolor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: canNext ? _controller.next : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primarycolor,
                    foregroundColor: whitecolor,
                    disabledBackgroundColor: primarycolor.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    isLast ? 'Get Started' : 'Next',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (isCentered) {
      return Positioned.fill(
        child: Center(child: card),
      );
    }

    final rect = _targetRect;
    if (rect == null) {
      return Positioned(
        left: screenSize.width * 0.05,
        bottom: 24,
        child: card,
      );
    }

    final showAbove = step.tooltipPosition == WalkthroughTooltipPosition.above;
    final cardHeightEstimate = 220.0;
    final top = showAbove
        ? (rect.top - cardHeightEstimate - 16).clamp(16.0, screenSize.height)
        : (rect.bottom + 16).clamp(16.0, screenSize.height - cardHeightEstimate);

    return Positioned(
      left: screenSize.width * 0.05,
      top: top,
      child: card,
    );
  }
}
