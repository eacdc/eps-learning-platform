import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/views/custom_widgets/primary_button.dart';

class UpdateSheet extends StatelessWidget {
  final bool forced;
  final String storeUrl;
  final String? releaseNotes;
  final VoidCallback? onLater;

  const UpdateSheet({
    Key? key,
    required this.forced,
    required this.storeUrl,
    this.releaseNotes,
    this.onLater,
  }) : super(key: key);

  Future<void> _openStore() async {
    try {
      final uri = Uri.parse(storeUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (kDebugMode) print("Failed to open store: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return PopScope(
      canPop: !forced,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: lightbluetext,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: primarycolor.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.system_update_rounded,
                color: primarycolor,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              forced
                  ? "Mise à jour requise"
                  : "Nouvelle version disponible",
              style: TextStyle(
                fontSize: 18,
                color: onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                forced
                    ? "Une nouvelle version de l'application est requise pour continuer. Veuillez mettre à jour pour poursuivre."
                    : "Une version améliorée de l'application est disponible. Mettez à jour pour profiter des dernières fonctionnalités.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            if (releaseNotes != null && releaseNotes!.trim().isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer
                      .withAlpha(120),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nouveautés",
                      style: TextStyle(
                        fontSize: 13,
                        color: onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      releaseNotes!.trim(),
                      style: TextStyle(
                        fontSize: 13,
                        color: onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PrimaryButton(
                buttonColor: primarycolor,
                textValue: "Mettre à jour",
                textColor: onprimary,
                onPressed: _openStore,
              ),
            ),

            if (!forced) ...[
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {
                  onLater?.call();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Plus tard",
                  style: TextStyle(
                    fontSize: 15,
                    color: onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
