# Proxima

Proxima is a local-network voice and video calling app built with Flutter and WebRTC.
It lets nearby devices join the same call over Wi-Fi or hotspot without using the internet.

## Features

- Local voice and video calls over LAN
- QR-based joining for quick session setup
- Manual session code entry
- Host discovery on the local network
- In-call controls for mute, camera, speaker, and camera switch
- Android and iOS support

## How It Works

1. One device starts a session as the host.
2. The host advertises the session on the local network.
3. Other devices join by scanning the QR code or entering the session code.
4. Media is sent directly with WebRTC peer-to-peer connections.

## Screens

- Home
- Host session
- Join session
- Active call

## Requirements

- Flutter 3.x
- Android or iOS device on the same Wi-Fi network or hotspot
- Microphone permission
- Camera permission for video calls

## Setup

```bash
flutter pub get
```

## Run

```bash
flutter run
```

To run on a specific device:

```bash
flutter devices
flutter run -d <device_id>
```

## Build

Release APK:

```bash
flutter build apk --release --split-per-abi
```

Release IPA:

```bash
flutter build ipa
```

## App Name

The app is branded as **Proxima** in the launcher and UI.

## Notes

- Devices must be on the same local network for discovery and signaling.
- If discovery does not work, try manual code entry.
- On Android 13+, nearby Wi-Fi and camera/microphone permissions may need to be granted manually in system settings.

## Tech Stack

- Flutter
- flutter_webrtc
- flutter_bloc
- go_router
- permission_handler
- qr_flutter
- mobile_scanner

## Project Structure

- `lib/app` - app root and theme
- `lib/core` - signaling, discovery, permissions, router, shared widgets
- `lib/features/home` - landing and session start flow
- `lib/features/host` - host session screen
- `lib/features/join` - joining and QR scanning flow
- `lib/features/call` - active call UI and state

## License

This project does not currently include a license file.

# proxima
