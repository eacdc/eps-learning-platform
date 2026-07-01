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
    title: "Découvrez une plateforme pour un apprentissage intelligent",
    image: "assets/images/onboard1.png",
    desc: "Embarquez dans un parcours d'apprentissage personnalisé où chaque quiz, défi et réussite vous rapproche de la maîtrise de vos matières.",
  ),
  OnboardingContents(
    title: "Restez organisé avec des livres et des quiz",
    image: "assets/images/onboard2.png",
    desc:
        "Gérez facilement vos supports d'étude en vous abonnant à des livres pertinents. Suivez vos progrès et plongez dans des chapitres spécifiques quand vous êtes prêt à apprendre.",
  ),
  OnboardingContents(
    title: "Élevez votre apprentissage vers de nouveaux sommets",
    image: "assets/images/onboard3.png",
    desc:
        "Développez vos compétences et atteignez vos objectifs académiques avec facilité et efficacité",
  ),
];
