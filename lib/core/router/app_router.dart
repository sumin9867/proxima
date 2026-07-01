import 'package:go_router/go_router.dart';

import 'package:local_voice_call/core/session/session_service.dart';
import 'package:local_voice_call/features/call/presentation/call_page.dart';
import 'package:local_voice_call/features/home/presentation/home_page.dart';
import 'package:local_voice_call/features/host/presentation/host_page.dart';
import 'package:local_voice_call/features/join/presentation/join_page.dart';
import 'package:local_voice_call/models/session.dart';

/// Central route table for the Proxima app.
abstract final class AppRoutes {
  static const home = '/';
  static const host = '/host';
  static const join = '/join';
  static const call = '/call';
}

/// Navigation payload for the call screen: the live, already-connected session
/// plus the media mode to present.
class CallArgs {
  const CallArgs({required this.session, required this.mode});
  final SessionService session;
  final CallMode mode;
}

/// The app's [GoRouter], wiring each Proxima screen to its path.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.host,
      builder: (context, state) => const HostPage(),
    ),
    GoRoute(
      path: AppRoutes.join,
      builder: (context, state) => const JoinPage(),
    ),
    GoRoute(
      path: AppRoutes.call,
      builder: (context, state) {
        final args = state.extra! as CallArgs;
        return CallPage(session: args.session, mode: args.mode);
      },
    ),
  ],
);
