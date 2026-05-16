# Agora SDK
-keep class io.agora.** { *; }
-dontwarn io.agora.**

# Flutter plugins
-keep class io.flutter.plugins.** { *; }

# WebRTC / media (if used internally)
-keep class org.webrtc.** { *; }
-dontwarn org.webrtc.**

-keepattributes *Annotation*
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
