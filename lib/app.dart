import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'presentation/viewmodels/inductor_calculator_vm.dart';
import 'presentation/viewmodels/coil_calculator_vm.dart';
import 'presentation/viewmodels/theme_vm.dart';
import 'presentation/viewmodels/history_vm.dart';
import 'presentation/pages/splash_screen.dart';

class InductorCalculatorApp extends StatelessWidget {
  const InductorCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(create: (_) => InductorCalculatorViewModel()),
        ChangeNotifierProvider(create: (_) => CoilCalculatorViewModel()),
        ChangeNotifierProvider(create: (_) => HistoryViewModel()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeVm, _) {
          return MaterialApp(
            title: 'Inductor Coil Calculator',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeVm.themeMode,
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}