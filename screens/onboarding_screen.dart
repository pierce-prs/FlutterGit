import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../state/app_state.dart';
import 'admin_screen.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);
    final s = app.s;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(20)),
                child: Icon(Icons.volunteer_activism_rounded, color: scheme.onPrimary, size: 32),
              ),
              const SizedBox(height: 24),
              Text(s.welcome, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text(
                s.tagline,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 32),
              Text(s.chooseLanguage, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 12),
              Row(
                children: AppLanguage.values.map((lang) {
                  final selected = app.language == lang;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () => app.setLanguage(lang),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: selected ? scheme.primaryContainer : scheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: selected ? scheme.primary : scheme.outlineVariant),
                          ),
                          child: Column(
                            children: [
                              Text(lang.flag, style: const TextStyle(fontSize: 26)),
                              const SizedBox(height: 6),
                              Text(lang.label, style: Theme.of(context).textTheme.labelLarge),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())),
                  child: Text(s.continueLabel),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    app.setPortal(Portal.admin);
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminScreen()));
                  },
                  child: Text(s.goToAdmin),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  s.prototypeNotice,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.outline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
