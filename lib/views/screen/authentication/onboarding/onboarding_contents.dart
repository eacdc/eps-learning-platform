class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Discover a platform for smart learning ",
    image: "assets/images/onboard1.png",
    desc: "Embark on a personalized learning journey where every quiz, challenge, and achievement brings you closer to mastering your subjects.",
  ),
  OnboardingContents(
    title: "Stay organised with books & quizzes",
    image: "assets/images/onboard2.png",
    desc:
        "Easily manage your study materials by subscribing to relevant books. Keep track of your progress and dive into specific chapters whenever you're ready to learn.",
  ),
  OnboardingContents(
    title: "Level up your Learning to new heights",
    image: "assets/images/onboard3.png",
    desc:
        "Elevate your skills and achieve your academic goals with ease and efficiency",
  ),
];
