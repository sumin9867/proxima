import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:local_voice_call/core/router/app_router.dart';
import 'package:local_voice_call/core/session/session_service.dart';
import 'package:local_voice_call/core/settings/app_settings.dart';
import 'package:local_voice_call/core/theme/app_colors.dart';
import 'package:local_voice_call/core/widgets/avatar.dart';
import 'package:local_voice_call/core/widgets/primary_button.dart';
import 'package:local_voice_call/core/widgets/screen_header.dart';
import 'package:local_voice_call/features/host/presentation/cubit/host_cubit.dart';
import 'package:local_voice_call/features/host/presentation/widgets/participant_row.dart';
import 'package:local_voice_call/features/host/presentation/widgets/session_code_card.dart';
import 'package:local_voice_call/features/host/presentation/widgets/waiting_banner.dart';
import 'package:local_voice_call/models/session.dart';

/// Screen 02 — hosting a session: starts a real LAN session, shows the
/// shareable code + QR, and lists participants as they join.
class HostPage extends StatelessWidget {
  const HostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<AppSettings>();
    return BlocProvider(
      create: (_) => HostCubit(
        session: SessionService(displayName: settings.displayName, video: true),
      )..start(),
      child: const HostView(),
    );
  }
}

class HostView extends StatefulWidget {
  const HostView({super.key});

  @override
  State<HostView> createState() => _HostViewState();
}

class _HostViewState extends State<HostView> {
  bool _proceeding = false;

  Future<void> _startCall(SessionService session, CallMode mode) async {
    setState(() => _proceeding = true);
    // Permissions are already requested when media was acquired; proceed.
    if (!mounted) return;
    context.go(
      AppRoutes.call,
      extra: CallArgs(session: session, mode: mode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HostCubit, HostState>(
          builder: (context, state) {
            return switch (state.status) {
              HostStatus.starting => _buildStarting(context),
              HostStatus.failed => _buildFailed(
                context,
                state.errorMessage ?? 'Unknown error',
              ),
              HostStatus.hosting => _buildHosting(
                context,
                code: state.code!.code,
                participants: state.participants,
                qrPayload: state.code!.qrPayload,
              ),
            };
          },
        ),
      ),
    );
  }

  Widget _buildStarting(BuildContext context) {
    return Column(
      children: [
        ScreenHeader(title: 'Host Session', onBack: () => context.go('/')),
        const Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 16),
                Text(
                  'Starting your session…',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFailed(BuildContext context, String message) {
    return Column(
      children: [
        ScreenHeader(title: 'Host Session', onBack: () => context.go('/')),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    size: 40,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Couldn't start the session",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHosting(
    BuildContext context, {
    required String code,
    required List participants,
    required String qrPayload,
  }) {
    final session = context.read<HostCubit>().session;
    final joined = participants.where((p) => !p.isSelf).toList();
    const capacity = 3;
    final emptySlots = capacity - 1 - joined.length; // minus self

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ScreenHeader(title: 'Host Session', onBack: () => context.go('/')),
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 14),
          child: WaitingBanner(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: SessionCodeCard(code: code, qrPayload: qrPayload),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ParticipantsHeader(
                  joined: joined.length + 1,
                  capacity: capacity,
                ),
                const SizedBox(height: 12),
                for (final p in joined) ...[
                  _LiveRow(name: p.name),
                  const SizedBox(height: 10),
                ],
                for (var i = 0; i < emptySlots; i++) ...[
                  const EmptyParticipantSlot(),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 14),
          child: PrimaryButton(
            label: _proceeding ? 'Joining…' : 'Start Call Now',
            icon: Icons.call_rounded,
            onTap: _proceeding
                ? () {}
                : () => _startCall(session, CallMode.voice),
          ),
        ),
      ],
    );
  }
}

/// A roster row for a live joined participant.
class _LiveRow extends StatelessWidget {
  const _LiveRow({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Avatar(
            initial: name.isNotEmpty ? name[0].toUpperCase() : '?',
            color: AppColors.avatarPurple,
            size: 40,
            fontSize: 17,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Text(
                  '● Joined',
                  style: TextStyle(fontSize: 12, color: AppColors.success),
                ),
              ],
            ),
          ),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success.withValues(alpha: 0.1),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.4),
                width: 1.2,
              ),
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 11,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipantsHeader extends StatelessWidget {
  const _ParticipantsHeader({required this.joined, required this.capacity});

  final int joined;
  final int capacity;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Participants',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$joined / $capacity',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
