import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'widgets/device_frame.dart';

void main() {
  runApp(const TabunSeniorCareApp());
}

class TabunSeniorCareApp extends StatefulWidget {
  const TabunSeniorCareApp({super.key});

  @override
  State<TabunSeniorCareApp> createState() => _TabunSeniorCareAppState();
}

class _TabunSeniorCareAppState extends State<TabunSeniorCareApp> {
  final AppState appState = AppState();

  @override
  void dispose() {
    appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: appState,
      child: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return MaterialApp(
            title: 'Tabun SeniorCare',
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(palette: appState.palette, brightness: appState.brightness),
            builder: (context, child) {
              final mq = MediaQuery.of(context);
              return MediaQuery(
                data: mq.copyWith(textScaler: TextScaler.linear(appState.textScale)),
                child: DeviceFrame(child: child ?? const SizedBox.shrink()),
              );
            },
            home: const OnboardingScreen(),
          );
        },
      ),
    );
  }
}
