import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:local_voice_call/core/permissions/call_permissions.dart';
import 'package:local_voice_call/core/router/app_router.dart';
import 'package:local_voice_call/core/settings/app_settings.dart';
import 'package:local_voice_call/core/theme/app_colors.dart';
import 'package:local_voice_call/core/widgets/proxima_logo.dart';
import 'package:local_voice_call/features/home/presentation/action_tile.dart';
import 'package:local_voice_call/features/home/presentation/start_session_sheet.dart';

/// Screen 01 — the launch surface: brand badge, tagline, and the two primary
/// entry points into hosting or joining a session.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// Collects the display name, requests call permissions, then navigates.
  Future<void> _begin(
    BuildContext context, {
    required String route,
    required String title,
  }) async {
    final settings = context.read<AppSettings>();
    final choice = await showStartSessionSheet(
      context,
      title: title,
      initialName: settings.displayName,
    );
    if (choice == null || !context.mounted) return;
    settings.displayName = choice.displayName;

    final granted = await CallPermissions.requestForCall(video: true);
    if (!context.mounted) return;
    if (!granted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Microphone and camera access are needed to call.'),
          ),
        );
      return;
    }
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 36, 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ProximaLogoBadge(),
                    const SizedBox(height: 20),
                    const Text(
                      'Proxima',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'No internet needed.\nWorks over local Wi‑Fi.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 52),
                    ActionTile(
                      title: 'Start Call',
                      subtitle: 'Host a session',
                      filled: true,
                      icon: _phoneOutgoingIcon,
                      onTap: () => _begin(
                        context,
                        route: AppRoutes.host,
                        title: 'Host a session',
                      ),
                    ),
                    const SizedBox(height: 14),
                    ActionTile(
                      title: 'Join Call',
                      subtitle: 'Find nearby sessions',
                      filled: false,
                      icon: _searchPlusIcon,
                      onTap: () => _begin(
                        context,
                        route: AppRoutes.join,
                        title: 'Join a session',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(32, 0, 32, 24),
              child: Text(
                'Works over Wi‑Fi or hotspot · Up to 3 people',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _phoneOutgoingIcon(Color color) =>
      Icon(Icons.phone_forwarded_rounded, color: color, size: 22);

  static Widget _searchPlusIcon(Color color) => SizedBox(
    width: 22,
    height: 22,
    child: CustomPaint(painter: _SearchPlusPainter(color)),
  );
}

/// A magnifier with a plus inside it — the "find and add a session" glyph.
class _SearchPlusPainter extends CustomPainter {
  _SearchPlusPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    canvas.scale(s, s);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    stroke.strokeWidth = 2;
    canvas.drawCircle(const Offset(11, 11), 7, stroke);
    canvas.drawLine(const Offset(16.5, 16.5), const Offset(21, 21), stroke);

    stroke.strokeWidth = 1.8;
    canvas.drawLine(const Offset(11, 8), const Offset(11, 14), stroke);
    canvas.drawLine(const Offset(8, 11), const Offset(14, 11), stroke);
  }

  @override
  bool shouldRepaint(_SearchPlusPainter oldDelegate) =>
      oldDelegate.color != color;
}
