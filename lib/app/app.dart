import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:local_voice_call/core/router/app_router.dart';
import 'package:local_voice_call/core/settings/app_settings.dart';
import 'package:local_voice_call/core/theme/app_theme.dart';

/// Root of the Proxima application: installs settings, theme, and the router.
class ProximaApp extends StatelessWidget {
  const ProximaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppSettings(),
      child: MaterialApp.router(
        title: 'Proxima',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        routerConfig: appRouter,
      ),
    );
  }
}
