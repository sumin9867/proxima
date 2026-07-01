import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';

import 'package:local_voice_call/core/session/session_service.dart';
import 'package:local_voice_call/core/theme/app_colors.dart';
import 'package:local_voice_call/core/widgets/waveform.dart';
import 'package:local_voice_call/features/call/presentation/cubit/call_cubit.dart';
import 'package:local_voice_call/features/call/presentation/widgets/call_control_button.dart';
import 'package:local_voice_call/models/session.dart';

/// Screens 04 & 05 — an active call. Renders the video layout (full-screen
/// remote feed + self PIP) or the voice layout (avatars + waveform) depending
/// on the active [CallMode], driven by a live [SessionService].
class CallPage extends StatelessWidget {
  const CallPage({super.key, required this.session, required this.mode});

  final SessionService session;
  final CallMode mode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CallCubit(session: session, mode: mode),
      child: CallView(mode: mode),
    );
  }
}

class CallView extends StatelessWidget {
  const CallView({super.key, required this.mode});

  final CallMode mode;

  Future<void> _hangUp(BuildContext context) async {
    await context.read<CallCubit>().hangUp();
    if (context.mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _hangUp(context);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: context.select((CallCubit c) => c.state.mode) == CallMode.video
            ? _VideoLayout(onHangUp: () => _hangUp(context))
            : _VoiceLayout(onHangUp: () => _hangUp(context)),
      ),
    );
  }
}

// ---- Video ------------------------------------------------------------------

class _VideoLayout extends StatelessWidget {
  const _VideoLayout({required this.onHangUp});
  final VoidCallback onHangUp;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CallCubit>().state;
    final remote = state.remotes.firstOrNull;
    final self = state.self;

    return Scaffold(
      backgroundColor: AppColors.videoBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: remote?.renderer != null
                ? RTCVideoView(
                    remote!.renderer!,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  )
                : const _WaitingForPeer(),
          ),
          SafeArea(bottom: false, child: _TopBar()),
          if (self?.renderer != null)
            SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 16),
                  child: _SelfPip(renderer: self!.renderer!),
                ),
              ),
            ),
          _VideoControls(onHangUp: onHangUp),
        ],
      ),
    );
  }
}

class _WaitingForPeer extends StatelessWidget {
  const _WaitingForPeer();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0E0F1A), Color(0xFF0A0B14), Color(0xFF0D0E1B)],
        ),
      ),
      child: Center(
        child: Text(
          'Waiting for others to join…',
          style: TextStyle(color: Colors.white70, fontSize: 15),
        ),
      ),
    );
  }
}

class _SelfPip extends StatelessWidget {
  const _SelfPip({required this.renderer});
  final RTCVideoRenderer renderer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 106,
      height: 142,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 2,
        ),
        color: const Color(0xFF14152A),
      ),
      child: RTCVideoView(
        renderer,
        mirror: true,
        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final duration = context.select((CallCubit c) => c.state.elapsedLabel);
    final peers = context.select((CallCubit c) => c.state.remotes.length);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black54, Colors.transparent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                duration,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              _StatusPill(connected: peers > 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.connected});
  final bool connected;

  @override
  Widget build(BuildContext context) {
    final color = connected ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 5),
          Text(
            connected ? 'Connected' : 'Waiting',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoControls extends StatelessWidget {
  const _VideoControls({required this.onHangUp});
  final VoidCallback onHangUp;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CallCubit>();
    final isMuted = context.select((CallCubit c) => c.state.isMuted);
    final isCameraOn = context.select((CallCubit c) => c.state.isCameraOn);

    return Positioned(
      bottom: 46,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF0E0F16).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CallControlButton(
                icon: isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                background: isMuted ? Colors.white : AppColors.controlSurface,
                iconColor: isMuted ? AppColors.callBackground : Colors.white,
                onTap: cubit.toggleMute,
              ),
              const SizedBox(width: 16),
              CallControlButton(
                icon: isCameraOn
                    ? Icons.videocam_rounded
                    : Icons.videocam_off_rounded,
                background: isCameraOn
                    ? AppColors.controlSurface
                    : Colors.white,
                iconColor: isCameraOn ? Colors.white : AppColors.callBackground,
                iconSize: 24,
                onTap: cubit.toggleCamera,
              ),
              const SizedBox(width: 16),
              EndCallButton(onTap: onHangUp),
              const SizedBox(width: 16),
              CallControlButton(
                icon: Icons.cameraswitch_rounded,
                onTap: cubit.switchCamera,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---- Voice ------------------------------------------------------------------

class _VoiceLayout extends StatelessWidget {
  const _VoiceLayout({required this.onHangUp});
  final VoidCallback onHangUp;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CallCubit>().state;

    return Scaffold(
      backgroundColor: AppColors.callBackground,
      body: SafeArea(
        child: Column(
          children: [
            _VoiceHeader(
              duration: state.elapsedLabel,
              connected: state.remotes.isNotEmpty,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Wrap so three avatars never overflow on a narrow screen.
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      for (final p in state.participants)
                        _VoiceAvatar(name: p.name, isSelf: p.isSelf),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Waveform(),
                ],
              ),
            ),
            _VoiceControls(onHangUp: onHangUp),
          ],
        ),
      ),
    );
  }
}

class _VoiceHeader extends StatelessWidget {
  const _VoiceHeader({required this.duration, required this.connected});
  final String duration;
  final bool connected;

  @override
  Widget build(BuildContext context) {
    final color = connected ? AppColors.success : AppColors.warning;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
      child: Column(
        children: [
          const Text(
            'Voice Call',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textOnDarkMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            duration,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textOnDark,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  connected ? 'All connected' : 'Waiting for others',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VoiceAvatar extends StatelessWidget {
  const _VoiceAvatar({required this.name, required this.isSelf});
  final String name;
  final bool isSelf;

  @override
  Widget build(BuildContext context) {
    final size = isSelf ? 82.0 : 108.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.avatarPurple, Color(0xFF6A4FDB)],
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: TextStyle(
              fontSize: isSelf ? 30 : 42,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textOnDark,
          ),
        ),
      ],
    );
  }
}

class _VoiceControls extends StatelessWidget {
  const _VoiceControls({required this.onHangUp});
  final VoidCallback onHangUp;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CallCubit>();
    final isMuted = context.select((CallCubit c) => c.state.isMuted);
    final isCameraOn = context.select((CallCubit c) => c.state.isCameraOn);
    final isSpeakerOn = context.select((CallCubit c) => c.state.isSpeakerOn);

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.controlBar,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CallControlButton(
              icon: isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
              background: isMuted ? Colors.white : AppColors.controlSurface,
              iconColor: isMuted ? AppColors.callBackground : Colors.white,
              onTap: cubit.toggleMute,
            ),
            CallControlButton(
              icon: isCameraOn
                  ? Icons.videocam_rounded
                  : Icons.videocam_off_rounded,
              background: isCameraOn ? AppColors.controlSurface : Colors.white,
              iconColor: isCameraOn ? Colors.white : AppColors.callBackground,
              iconSize: 24,
              onTap: cubit.toggleCamera,
            ),
            EndCallButton(onTap: onHangUp),
            CallControlButton(
              icon: isSpeakerOn
                  ? Icons.volume_up_rounded
                  : Icons.volume_down_rounded,
              background: isSpeakerOn ? Colors.white : AppColors.controlSurface,
              iconColor: isSpeakerOn ? AppColors.callBackground : Colors.white,
              onTap: cubit.toggleSpeaker,
            ),
          ],
        ),
      ),
    );
  }
}
