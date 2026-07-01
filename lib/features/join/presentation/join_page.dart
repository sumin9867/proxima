import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:local_voice_call/core/discovery/discovery_service.dart';
import 'package:local_voice_call/core/router/app_router.dart';
import 'package:local_voice_call/core/settings/app_settings.dart';
import 'package:local_voice_call/core/theme/app_colors.dart';
import 'package:local_voice_call/core/widgets/avatar.dart';
import 'package:local_voice_call/core/widgets/screen_header.dart';
import 'package:local_voice_call/core/widgets/signal_bars.dart';
import 'package:local_voice_call/features/join/presentation/cubit/join_cubit.dart';
import 'package:local_voice_call/features/join/presentation/qr_scanner_page.dart';
import 'package:local_voice_call/features/join/presentation/widgets/manual_entry_row.dart';
import 'package:local_voice_call/features/join/presentation/widgets/scan_radar.dart';
import 'package:local_voice_call/models/session.dart';

/// Screen 03 — finding and joining a nearby session over the LAN.
class JoinPage extends StatelessWidget {
  const JoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<AppSettings>();
    return BlocProvider(
      create: (_) => JoinCubit(displayName: settings.displayName, video: true),
      child: const JoinView(),
    );
  }
}

class JoinView extends StatelessWidget {
  const JoinView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinCubit, JoinState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, state) {
        switch (state.status) {
          case JoinStatus.joined:
            final session = state.joinedSession!;
            context.go(
              AppRoutes.call,
              extra: CallArgs(session: session, mode: CallMode.voice),
            );
          case JoinStatus.failed:
            _snack(context, 'Could not connect to that session.');
            context.read<JoinCubit>().resetStatus();
          case JoinStatus.notFound:
            _snack(context, 'No session found for that code.');
            context.read<JoinCubit>().resetStatus();
          case JoinStatus.idle:
          case JoinStatus.joining:
            break;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenHeader(title: 'Find Nearby', onBack: () => context.go('/')),
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: ScanRadar(),
              ),
              Expanded(
                child: BlocBuilder<JoinCubit, JoinState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SectionHeader(count: state.hosts.length),
                          const SizedBox(height: 12),
                          for (final host in state.hosts) ...[
                            _DiscoveredRow(
                              host: host,
                              busy: state.status == JoinStatus.joining,
                              onTap: () => context
                                  .read<JoinCubit>()
                                  .joinDiscovered(host),
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (state.hosts.isEmpty) const _EmptyHint(),
                          const SizedBox(height: 8),
                          const _OrDivider(),
                          const SizedBox(height: 14),
                          _ScanQrRow(onTap: () => _scanQr(context)),
                          const SizedBox(height: 10),
                          ManualEntryRow(onTap: () => _enterCode(context)),
                          const SizedBox(height: 16),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scanQr(BuildContext context) async {
    final cubit = context.read<JoinCubit>();
    final payload = await Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const QrScannerPage()));
    if (payload != null) await cubit.joinByQr(payload);
  }

  Future<void> _enterCode(BuildContext context) async {
    final cubit = context.read<JoinCubit>();
    final code = await showManualCodeSheet(context);
    if (code != null && code.trim().isNotEmpty) {
      await cubit.joinByCode(code);
    }
  }

  static void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _DiscoveredRow extends StatelessWidget {
  const _DiscoveredRow({
    required this.host,
    required this.busy,
    required this.onTap,
  });

  final DiscoveredHost host;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: busy ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Avatar(
                initial: host.hostName.isNotEmpty
                    ? host.hostName[0].toUpperCase()
                    : '?',
                color: AppColors.avatarPurple,
                size: 44,
                fontSize: 18,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      host.hostName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: const [
                        SignalBars(color: AppColors.success, filledBars: 4),
                        SizedBox(width: 5),
                        Text(
                          'Strong',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (busy)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: AppColors.textPrimary.withValues(alpha: 0.2),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanQrRow extends StatelessWidget {
  const _ScanQrRow({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
                child: const Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Scan QR code',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.textPrimary.withValues(alpha: 0.18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        'Make sure you’re on the same Wi‑Fi as the host.',
        style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'NEARBY SESSIONS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 1,
          ),
        ),
        Text(
          count == 0 ? 'Searching…' : '$count found',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: AppColors.border)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'or',
            style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
          ),
        ),
        Expanded(child: Container(height: 1, color: AppColors.border)),
      ],
    );
  }
}
