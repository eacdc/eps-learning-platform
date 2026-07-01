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
        title: 'Bienvenue sur Test Your Learning !',
        description:
            'Faites une visite rapide pour découvrir la génération de quiz, les outils d\'apprentissage et le suivi des progrès.',
        tooltipPosition: WalkthroughTooltipPosition.center,
        icon: Icons.waving_hand_rounded,
      ),
      WalkthroughStep(
        id: 'home_stats',
        title: 'Suivez vos progrès',
        description:
            'Consultez d\'un coup d\'œil les quiz en cours, les quiz terminés, les points gagnés et les heures d\'étude.',
        targetKey: homeStatsKey,
        tabIndex: 0,
        tooltipPosition: WalkthroughTooltipPosition.below,
        icon: Icons.insights_rounded,
      ),
      WalkthroughStep(
        id: 'classroom_fab',
        title: 'Commencer à apprendre ou à faire des quiz',
        description:
            'Appuyez sur Classroom pour ouvrir les modes Apprendre et Quiz. Essayez d\'appuyer maintenant !',
        targetKey: classroomFabKey,
        tabIndex: 0,
        waitForTargetTap: true,
        tooltipPosition: WalkthroughTooltipPosition.above,
        icon: Icons.school_rounded,
      ),
      WalkthroughStep(
        id: 'learn_quiz_modes',
        title: 'Apprendre vs Quiz',
        description:
            'Choisissez Apprendre pour une étude guidée par l\'IA, ou Quiz pour tester vos connaissances avec des questions interactives.',
        targetKey: learnQuizRowKey,
        tabIndex: 0,
        expandClassroom: true,
        tooltipPosition: WalkthroughTooltipPosition.above,
        icon: Icons.menu_book_rounded,
      ),
      WalkthroughStep(
        id: 'my_library',
        title: 'Ma bibliothèque',
        description:
            'Accédez à vos livres et chapitres abonnés. Choisissez un livre pour commencer un quiz ou une session d\'apprentissage.',
        targetKey: navLibraryKey,
        tooltipPosition: WalkthroughTooltipPosition.above,
        icon: Icons.bookmark_rounded,
      ),
      WalkthroughStep(
        id: 'collection',
        title: 'Parcourir et s\'abonner',
        description:
            'Explorez la collection de livres et abonnez-vous à de nouveaux titres pour les quiz et l\'apprentissage.',
        targetKey: navCollectionKey,
        tooltipPosition: WalkthroughTooltipPosition.above,
        icon: Icons.collections_bookmark_rounded,
      ),
      WalkthroughStep(
        id: 'performance',
        title: 'Aperçu des performances',
        description:
            'Consultez vos performances par chapitre et voyez comment vous progressez au fil du temps.',
        targetKey: performanceOverviewKey,
        tabIndex: 0,
        tooltipPosition: WalkthroughTooltipPosition.above,
        icon: Icons.bar_chart_rounded,
      ),
      WalkthroughStep(
        id: 'progress_scores',
        title: 'Progrès et scores détaillés',
        description:
            'Ouvrez votre profil, puis appuyez sur Progrès et scores pour des résultats d\'évaluation approfondis et des classements.',
        targetKey: navProfileKey,
        tooltipPosition: WalkthroughTooltipPosition.above,
        icon: Icons.emoji_events_rounded,
      ),
      const WalkthroughStep(
        id: 'complete',
        title: "Vous êtes prêt !",
        description:
            'Vous êtes prêt à explorer. Commencez un quiz, suivez vos progrès et continuez à apprendre !',
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
