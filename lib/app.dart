import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'presentation/viewmodels/inductor_calculator_vm.dart';
import 'presentation/viewmodels/coil_calculator_vm.dart';
import 'presentation/pages/splash_screen.dart';

class InductorCalculatorApp extends StatelessWidget {
  const InductorCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InductorCalculatorViewModel()),
        ChangeNotifierProvider(create: (_) => CoilCalculatorViewModel()),
      ],
      child: MaterialApp(
        title: 'Inductor Calculator',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}