import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/controllers/dashboard_controller.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/models/walkthrough_model/walkthrough_step.dart';

class WalkthroughController extends GetxController {
  final homeStatsKey = GlobalKey();
  final performanceOverviewKey = GlobalKey();
  final classroomFabKey = GlobalKey();
  final learnQuizRowKey = GlobalKey();
  final navHomeKey = GlobalKey();
  final navLibraryKey = GlobalKey();
  final navCollectionKey = GlobalKey();
  final navProfileKey = GlobalKey();

  final isActive = false.obs;
  final currentStepIndex = 0.obs;
  final targetInteractionDone = false.obs;

  late final DashboardController _dashboardController;

  late final List<WalkthroughStep> steps;

  @override
  void onInit() {
    super.onInit();
    _dashboardController = Get.find<DashboardController>();
    steps = _buildSteps();
  }

  List<WalkthroughStep> _buildSteps() {
    return [
      const WalkthroughStep(
        id: 'welcome',
        title: 'Welcome to Test Your Learning!',
        description:
            'Take a quick tour to discover quiz generation, learning tools, and progress tracking.',
        tooltipPosition: WalkthroughTooltipPosition.center,
        icon: Icons.waving_hand_rounded,
      ),
      WalkthroughStep(
        id: 'home_stats',
        title: 'Track Your Progress',
        description:
            'View quizzes in progress, completed quizzes, points earned, and study hours at a glance.',
        targetKey: homeStatsKey,
        tabIndex: 0,
        tooltipPosition: WalkthroughTooltipPosition.below,
        icon: Icons.insights_rounded,
      ),
      WalkthroughStep(
        id: 'classroom_fab',
        title: 'Start Learning or Quizzing',
        description:
            'Tap Classroom to open Learn and Quiz modes. Try tapping it now!',
        targetKey: classroomFabKey,
        tabIndex: 0,
        waitForTargetTap: true,
        tooltipPosition: WalkthroughTooltipPosition.above,
        icon: Icons.school_rounded,
      ),
      WalkthroughStep(
        id: 'learn_quiz_modes',
        title: 'Learn vs Quiz',
        description:
            'Choose Learn for AI-guided study, or Quiz to test your knowledge with interactive questions.',
        targetKey: learnQuizRowKey,
        tabIndex: 0,
        expandClassroom: true,
        tooltipPosition: WalkthroughTooltipPosition.above,
        icon: Icons.menu_book_rounded,
      ),
      WalkthroughStep(
        id: 'my_library',
        title: 'My Library',
        description:
            'Access your subscribed books and chapters. Pick a book to start a quiz or learning session.',
        targetKey: navLibraryKey,
        tooltipPosition: WalkthroughTooltipPosition.above,
        icon: Icons.bookmark_rounded,
      ),
      WalkthroughStep(
        id: 'collection',
        title: 'Browse & Subscribe',
        description:
            'Explore the book collection and subscribe to new titles for quizzes and learning.',
        targetKey: navCollectionKey,
        tooltipPosition: WalkthroughTooltipPosition.above,
        icon: Icons.collections_bookmark_rounded,
      ),
      WalkthroughStep(
        id: 'performance',
        title: 'Performance Overview',
        description:
            'Review your chapter-wise performance and see how you improve over time.',
        targetKey: performanceOverviewKey,
        tabIndex: 0,
        tooltipPosition: WalkthroughTooltipPosition.above,
        icon: Icons.bar_chart_rounded,
      ),
      WalkthroughStep(
        id: 'progress_scores',
        title: 'Detailed Progress & Scores',
        description:
            'Open your Profile, then tap Progress & Scores for in-depth assessment results and rankings.',
        targetKey: navProfileKey,
        tooltipPosition: WalkthroughTooltipPosition.above,
        icon: Icons.emoji_events_rounded,
      ),
      const WalkthroughStep(
        id: 'complete',
        title: "You're All Set!",
        description:
            'You are ready to explore. Start a quiz, track your progress, and keep learning!',
        tooltipPosition: WalkthroughTooltipPosition.center,
        icon: Icons.check_circle_rounded,
      ),
    ];
  }

  WalkthroughStep get currentStep => steps[currentStepIndex.value];

  bool get isFirstStep => currentStepIndex.value == 0;
  bool get isLastStep => currentStepIndex.value == steps.length - 1;

  bool get canGoNext {
    if (currentStep.waitForTargetTap && !targetInteractionDone.value) {
      return false;
    }
    return true;
  }

  void tryStartWalkthrough() {
    if (SharedPreferencesService.getHasSeenDashboardWalkthrough()) return;
    // Delay so initial home API calls can complete first (helps Render cold starts).
    Future.delayed(const Duration(seconds: 2), () {
      if (!isClosed) start();
    });
  }

  void start() {
    currentStepIndex.value = 0;
    targetInteractionDone.value = false;
    isActive.value = true;
    _prepareCurrentStep();
  }

  void next() {
    if (!canGoNext) return;

    if (isLastStep) {
      complete();
      return;
    }

    currentStepIndex.value++;
    targetInteractionDone.value = false;
    _prepareCurrentStep();
  }

  void previous() {
    if (isFirstStep) return;
    currentStepIndex.value--;
    targetInteractionDone.value = false;
    _prepareCurrentStep();
  }

  void skip() => complete();

  void complete() {
    isActive.value = false;
    _dashboardController.collapseClassroom();
    SharedPreferencesService.setHasSeenDashboardWalkthrough(true);
  }

  void onTargetTapped() {
    if (!isActive.value) return;
    if (!currentStep.waitForTargetTap) return;

    targetInteractionDone.value = true;

    if (currentStep.id == 'classroom_fab') {
      _dashboardController.toggleClassroomExpanded();
      Future.delayed(const Duration(milliseconds: 350), () {
        if (!isClosed && isActive.value) next();
      });
    }
  }

  void _prepareCurrentStep() {
    final step = currentStep;

    if (step.tabIndex != null) {
      _dashboardController.changeIndex(step.tabIndex!);
    }

    if (step.expandClassroom) {
      _dashboardController.isClassroomExpanded.value = true;
    } else if (step.id != 'classroom_fab' && step.id != 'learn_quiz_modes') {
      _dashboardController.collapseClassroom();
    }

    if (step.waitForTargetTap) {
      targetInteractionDone.value = false;
    } else {
      targetInteractionDone.value = true;
    }
  }
}
