import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// One of the six selectable brand palettes described in the storyboard's
/// design system. Each entry carries a seed color (used to derive a full
/// Material 3 ColorScheme) plus a friendly label for the palette picker.
class AppPalette {
  final String id;
  final String label;
  final Color seed;

  const AppPalette({required this.id, required this.label, required this.seed});
}

const List<AppPalette> kAppPalettes = [
  AppPalette(id: 'navy', label: 'Navy', seed: Color(0xFF1E3A5F)),
  AppPalette(id: 'green', label: 'Green', seed: Color(0xFF2F6D4F)),
  AppPalette(id: 'orange', label: 'Orange', seed: Color(0xFFC5622A)),
  AppPalette(id: 'purple', label: 'Purple', seed: Color(0xFF5B4B8A)),
  AppPalette(id: 'magenta', label: 'Magenta', seed: Color(0xFFA43D6A)),
  AppPalette(id: 'teal', label: 'Teal', seed: Color(0xFF1F7A73)),
];

AppPalette paletteById(String id) =>
    kAppPalettes.firstWhere((p) => p.id == id, orElse: () => kAppPalettes.first);

/// Builds the full app ThemeData for a given palette + brightness.
///
/// Headings use Lexend — a typeface designed specifically to improve
/// reading proficiency and reduce visual stress, which is the actual reason
/// it fits a senior-citizen-facing product (not a stock "AI" pick). Body
/// and UI text use Plus Jakarta Sans, a distinct but companionable sans so
/// the two don't collapse into one generic voice.
ThemeData buildAppTheme({required AppPalette palette, required Brightness brightness}) {
  final scheme = ColorScheme.fromSeed(seedColor: palette.seed, brightness: brightness);
  final isDark = brightness == Brightness.dark;

  final base = isDark ? ThemeData.dark() : ThemeData.light();
  var textTheme = base.textTheme;

  textTheme = textTheme.copyWith(
    displayLarge: GoogleFonts.lexend(textStyle: textTheme.displayLarge, fontWeight: FontWeight.w600),
    displayMedium: GoogleFonts.lexend(textStyle: textTheme.displayMedium, fontWeight: FontWeight.w600),
    displaySmall: GoogleFonts.lexend(textStyle: textTheme.displaySmall, fontWeight: FontWeight.w600),
    headlineLarge: GoogleFonts.lexend(textStyle: textTheme.headlineLarge, fontWeight: FontWeight.w600),
    headlineMedium: GoogleFonts.lexend(textStyle: textTheme.headlineMedium, fontWeight: FontWeight.w600),
    headlineSmall: GoogleFonts.lexend(textStyle: textTheme.headlineSmall, fontWeight: FontWeight.w600),
    titleLarge: GoogleFonts.lexend(textStyle: textTheme.titleLarge, fontWeight: FontWeight.w500),
    titleMedium: GoogleFonts.plusJakartaSans(textStyle: textTheme.titleMedium, fontWeight: FontWeight.w600),
    titleSmall: GoogleFonts.plusJakartaSans(textStyle: textTheme.titleSmall, fontWeight: FontWeight.w600),
    bodyLarge: GoogleFonts.plusJakartaSans(textStyle: textTheme.bodyLarge, height: 1.4),
    bodyMedium: GoogleFonts.plusJakartaSans(textStyle: textTheme.bodyMedium, height: 1.4),
    bodySmall: GoogleFonts.plusJakartaSans(textStyle: textTheme.bodySmall, height: 1.35),
    labelLarge: GoogleFonts.plusJakartaSans(textStyle: textTheme.labelLarge, fontWeight: FontWeight.w600),
    labelMedium: GoogleFonts.plusJakartaSans(textStyle: textTheme.labelMedium, fontWeight: FontWeight.w600),
    labelSmall: GoogleFonts.plusJakartaSans(textStyle: textTheme.labelSmall, fontWeight: FontWeight.w600),
  );

  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    ),
    dividerTheme: DividerThemeData(color: scheme.outlineVariant.withValues(alpha: 0.6)),
  );
}
