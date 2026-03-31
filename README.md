# OpenCV Android

Easy way to integrate OpenCV into your Android project via Gradle.
**No NDK dependency needed** — just include this library and you are good to go.

## 16KB Page Size Support

Android 15 (API 35) requires that native libraries in apps targeting Android 15+ support 16KB
memory page sizes. Starting **November 1, 2025**, Google Play enforces this for all new uploads.

This repository ships a publishable `opencv-contrib` library module that satisfies every layer
of the 16KB requirement:

| Layer | Mechanism |
|-------|-----------|
| ELF binary alignment | `org.opencv:opencv:4.10.0` is compiled with NDK r27+ and `-DANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES=ON`, so every LOAD segment is aligned to 16 KB |
| APK storage alignment | `jniLibs.useLegacyPackaging = false` stores `.so` files uncompressed + 16 KB-aligned inside the APK |
| Runtime mmap | `android:extractNativeLibs="false"` (merged from the library manifest) tells the OS to mmap `.so` files directly from the APK at their stored offset |

## Build Requirements

| Tool | Minimum version |
|------|----------------|
| Android Gradle Plugin | 8.7.0 |
| Gradle | 8.9 |
| JDK (build host) | 17 |
| compileSdk / targetSdk | 35 |
| minSdk | 21 |

## Publishing the library

The `opencv-contrib` module is ready to publish. Run:

```bash
./gradlew :opencv-contrib:publishToMavenLocal
```

This installs the AAR to your local Maven cache (`~/.m2/repository`) as:

```
com.quickbirdstudios:opencv-contrib:4.10.0
```

## Consuming the library in another app

### 1 — Add `mavenLocal()` to the consuming project's repository list

**`settings.gradle` (new-style) or root `build.gradle` (legacy):**
```groovy
dependencyResolutionManagement {
    repositories {
        mavenLocal()          // picks up the locally published AAR
        mavenCentral()        // needed for org.opencv:opencv transitive dep
        google()
    }
}
```

### 2 — Declare the dependency

```groovy
dependencies {
    implementation "com.quickbirdstudios:opencv-contrib:4.10.0"
}
```

That is all. The library's `api` declaration for `org.opencv:opencv:4.10.0` means you do **not**
need to list it separately; Gradle pulls it in transitively.

### 3 — 16KB packaging in the consuming app

The library's manifest already merges `android:extractNativeLibs="false"` into your app.
You only need to add one line to your **app's** `build.gradle` to ensure the APK stores the
`.so` files uncompressed (required for 16KB page-size alignment):

```groovy
android {
    packaging {
        jniLibs {
            useLegacyPackaging = false
        }
    }
}
```

### 4 — Initialize OpenCV

```kotlin
if (!OpenCVLoader.initLocal()) {
    Log.e("OpenCV", "Unable to load OpenCV!")
} else {
    Log.d("OpenCV", "OpenCV loaded successfully!")
}
```

`initLocal()` is synchronous and does not require the OpenCV Manager app. It replaced the
deprecated `initDebug()` in OpenCV 4.9.0+.

## Repository structure

```
opencv-android/
├── app/                  Demo app — depends on :opencv-contrib via project dep
├── opencv-contrib/       Publishable library module
│   ├── build.gradle      android library + maven-publish configuration
│   ├── consumer-rules.pro  ProGuard rules merged into consuming apps
│   └── src/main/
│       └── AndroidManifest.xml   sets android:extractNativeLibs="false"
├── build.gradle          Root build script (AGP 8.7.0, Kotlin 2.0.21)
├── settings.gradle
└── gradle/wrapper/
    └── gradle-wrapper.properties  (Gradle 8.9)
```

## Breaking changes from `com.quickbirdstudios:opencv-contrib:4.5.3.0`

| Old | New |
|-----|-----|
| `com.quickbirdstudios:opencv-contrib:4.5.3.0` | `com.quickbirdstudios:opencv-contrib:4.10.0` |
| `OpenCVLoader.initDebug()` | `OpenCVLoader.initLocal()` |
| 4KB page-size `.so` files | 16KB page-size `.so` files (NDK r27+) |
| compileSdk 30 | compileSdk 35 |
| AGP 7.0.2 | AGP 8.7.0 |

## References

- [Android — Support 16 KB page sizes](https://developer.android.com/guide/practices/page-sizes)
- [OpenCV issue #27024 — 16KB page size](https://github.com/opencv/opencv/issues/27024)
- [OpenCV ci-gha-workflow PR #246 — NDK r27c](https://github.com/opencv/ci-gha-workflow/pull/246)
- [org.opencv on Maven Central](https://central.sonatype.com/artifact/org.opencv/opencv)
