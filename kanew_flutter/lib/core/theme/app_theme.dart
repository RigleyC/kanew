import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      fontFamily: GoogleFonts.inter().fontFamily,
      brightness: Brightness.light,

      // Cores de Fundo (Scaffold & Surface)
      // Mapeado de bg-light-50 e globals.css
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      canvasColor: const Color(0xFFFFFFFF),

      // Esquema de Cores Principal
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF0A0A0A), // light-1000 (Botões, Acentos)
        onPrimary: Color(0xFFFAFAFA), // Texto no botão primário
        secondary: Color(0xFFFAFAFA), // Botões secundários (bg-light-50)
        onSecondary: Color(0xFF171717), // Texto no botão secundário
        surface: Color(0xFFFFFFFF), // Cards, Modais, Dropdowns
        onSurface: Color(0xFF171717), // Texto padrão (neutral-900)
        error: Color(0xFFDC2626), // red-600
        outline: Color(0xFF525252), // light-600 (Bordas fortes)
        outlineVariant: Color(0xFFE5E5E5), // light-200 (Bordas sutis)
      ),

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFAFAFA),
        foregroundColor: Color(0xFF0A0A0A),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: Color(0xFF171717)),
      ),

      // Inputs (Input.tsx)
      // Classes: rounded-md border-0 ring-1 ring-light-600 focus:ring-2
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFFFFFF), // bg-white/5 (no light é white)
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF737373),
          fontSize: 14,
        ), // placeholder:text-dark-800 approx
        // Borda Padrão (ring-1 ring-light-600)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Color(0xFF525252),
            width: 1,
          ), // light-600
        ),
        // Borda Focada (ring-2 ring-light-600)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Color(0xFF525252),
            width: 2,
          ), // light-600
        ),
        // Borda de Erro
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
        ),
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFFF2F2F2), // bg-light-50
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(
            color: Color(0xFFE5E5E5),
            width: 1,
          ), // border-light-200
        ),
      ),

      // Modais / Dialogs (modal.tsx)
      // Classes: rounded-lg border border-light-600 bg-white/90 shadow-3xl-light
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFFFFFFFF), // bg-white
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // rounded-lg
          side: const BorderSide(
            color: Color(0xFF525252),
            width: 1,
          ), // border-light-600
        ),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF171717),
        ),
      ),

      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xFFFFFFFF)),
          elevation: WidgetStateProperty.all(8),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Color(0xFFE5E5E5),
              ),
            ),
          ),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
        ),
      ),

      // Botões (Button.tsx)
      // Primary: bg-light-1000 text-light-50
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A0A0A), // light-1000
          foregroundColor: const Color(0xFFFAFAFA), // light-50
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          elevation: 0,
        ),
      ),

      // Secondary: border-[1px] border-light-600 bg-light-50 text-light-1000
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFFAFAFA), // bg-light-50
          foregroundColor: const Color(0xFF0A0A0A), // text-light-1000
          side: const BorderSide(
            color: Color(0xFF525252),
            width: 1,
          ), // border-light-600
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          elevation: 0,
        ),
      ),

      // Divisores
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE5E5E5), // light-200
        thickness: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        year2023: false,
      ),
    );
  }

  // --- TEMA ESCURO (DARK) ---
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'GeistSans',
      brightness: Brightness.dark,

      // Cores de Fundo
      // Mapeado de bg-dark-50
      scaffoldBackgroundColor: const Color(0xFF101012),
      canvasColor: const Color(0xFF0E0E10),

      // Esquema de Cores Principal
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFFFFFF), // dark-1000 (white) - Alto contraste
        onPrimary: Color(0xFF0A0A0A), // dark-50 (Texto no botão primário)
        secondary: Color(0xFF404040), // dark-300 (Botão secundário)
        onSecondary: Color(0xFFFFFFFF), // Texto no botão secundário
        surface: Color(0xFF171717), // dark-100 (Cards, Modais)
        onSurface: Color(0xFFFFFFFF), // Texto padrão
        error: Color(0xFFEF4444), // red-500
        outline: Color(0xFF525252), // dark-600 (Bordas)
        outlineVariant: Color(0xFF404040), // dark-300 (Divisores)
      ),

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0A0A0A), // dark-50
        foregroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
      ),

      // Inputs (Input.tsx - Dark Mode)
      // Classes: bg-dark-300 ring-dark-700 focus:ring-dark-700
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(
          0xFF262626,
        ), // Aproximação de bg-white/5 sobre dark
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        hintStyle: const TextStyle(color: Color(0xFF737373), fontSize: 14),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Color(0xFF404040),
            width: 1,
          ), // dark-700 approx
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Color(0xFF525252),
            width: 2,
          ), // Ring um pouco mais claro
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
        ),
      ),

      // Cards (Card.tsx - Dark Mode)
      // Classes: border-dark-200 bg-dark-200 text-dark-1000
      cardTheme: CardThemeData(
        color: const Color(0xFF262626), // bg-dark-200
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(
            color: Color(0xFF262626),
            width: 1,
          ), // border-dark-200 (muitas vezes sutil ou igual ao bg)
        ),
      ),

      // Modais / Dialogs (modal.tsx - Dark Mode)
      // Classes: border-dark-600 bg-dark-100/90
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF171717), // dark-100
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Color(0xFF525252),
            width: 1,
          ), // border-dark-600
        ),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
      ),

      // Dropdowns (Dropdown.tsx - Dark Mode)
      // Classes: border-dark-400 bg-dark-300
      popupMenuTheme: PopupMenuThemeData(
        menuPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        color: const Color(0xFF404040), // bg-dark-300
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Color(0xFF525252),
            width: 1,
          ),
        ),
        textStyle: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 14),
        elevation: 8,
      ),

      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xFF262626)),
          elevation: WidgetStateProperty.all(12),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Color(0xFF404040),
              ),
            ),
          ),
          padding: WidgetStateProperty.all(EdgeInsets.fromLTRB(14, 12, 14, 12)),
        ),
      ),

      // Botões (Button.tsx - Dark Mode)
      // Primary: dark:bg-dark-1000 dark:text-dark-50 (Branco no Preto)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFFFF), // dark-1000
          foregroundColor: const Color(0xFF0A0A0A), // dark-50
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          elevation: 0,
        ),
      ),

      // Secondary: dark:border-dark-600 dark:bg-dark-300 dark:text-dark-1000
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF404040), // bg-dark-300
          foregroundColor: const Color(0xFFFFFFFF), // text-dark-1000
          side: const BorderSide(
            color: Color(0xFF525252),
            width: 1,
          ), // border-dark-600
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          elevation: 0,
        ),
      ),

      // Divisores
      dividerTheme: const DividerThemeData(
        color: Color.fromARGB(255, 92, 92, 92),
        thickness: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        year2023: false,
      ),
    );
  }
}
