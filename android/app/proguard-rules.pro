# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# flutter_webrtc / libwebrtc — reflection-heavy native bindings
-keep class org.webrtc.** { *; }
-dontwarn org.webrtc.**

# mobile_scanner (ML Kit barcode) uses reflection
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# permission_handler
-keep class com.baseflow.permissionhandler.** { *; }

# Flutter references Play Core deferred-components classes that aren't bundled
# (this app doesn't use deferred components). Silence R8's missing-class errors.
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
