import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './providers/labels.dart';
import './providers/transactions.dart';
import './providers/settings.dart';
import './providers/theme_provider.dart';
import './screens/home_tabs_screen.dart';
import './screens/edit_labels_screen.dart';
import './screens/settings_screen.dart';
import './screens/onboarding.dart';
import './utils/db_helper.dart';

Future<void> main() async {
  // Add custom font license.
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  // Needed for onboarding.
  WidgetsFlutterBinding.ensureInitialized();
  final isOnboarded = await DBHelper.isOnboarded();

  runApp(MyApp(isOnboarded: isOnboarded));
}

class MyApp extends StatelessWidget {
  final bool isOnboarded;

  const MyApp({
    @required this.isOnboarded,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Settings(),
        ),
        ChangeNotifierProvider(
          create: (_) => Transactions(),
        ),
        ChangeNotifierProvider(
          create: (_) => Labels(),
        ),
      ],
      child: MaterialApp(
        title: 'Budget My Life',
        theme: ThemeProvider.lightTheme,
        darkTheme: ThemeProvider.amoledTheme,
        initialRoute: isOnboarded ? '/' : Onboarding.routeName,
        home: HomeTabsScreen(),
        routes: {
          EditLabelsScreen.routeName: (_) => EditLabelsScreen(),
          SettingsScreen.routeName: (_) => SettingsScreen(),
          Onboarding.routeName: (_) => Onboarding()
        },
      ),
    );
  }
}
