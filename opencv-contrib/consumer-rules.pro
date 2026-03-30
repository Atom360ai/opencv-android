# ProGuard / R8 consumer rules for opencv-contrib.
# These rules are applied automatically to any app that depends on this library.

# Keep all OpenCV public API classes so reflection-based initialisation works.
-keep class org.opencv.** { *; }
