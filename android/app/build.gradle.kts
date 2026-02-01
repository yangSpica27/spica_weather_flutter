plugins {
  id("com.android.application")
  id("kotlin-android")
  // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
  id("dev.flutter.flutter-gradle-plugin")
}

android {
  namespace = "me.spcia.spica_weather_flutter"
  compileSdk = flutter.compileSdkVersion
  ndkVersion = flutter.ndkVersion

  compileOptions {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
  }

  kotlinOptions {
    jvmTarget = JavaVersion.VERSION_17.toString()
  }

  defaultConfig {
    // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
    applicationId = "me.spcia.spica_weather_flutter"
    // You can update the following values to match your application needs.
    // For more information, see: https://flutter.dev/to/review-gradle-config.
    minSdk = flutter.minSdkVersion
    targetSdk = flutter.targetSdkVersion
    versionCode = flutter.versionCode
    versionName = flutter.versionName
    ndk {
      //armeabi armeabi-v7a arm64-v8a x86 x86_64
      abiFilters.clear()
      abiFilters.add("arm64-v8a")
    }
  }


  signingConfigs {
    register("signingConfig") {
      storePassword = "SPICa27"
      keyAlias = "wuqi"
      keyPassword = "SPICa27"
      storeFile = rootProject.file("key.jks")
    }
  }

  buildTypes {
    release {
      // TODO: Add your own signing config for the release build.
      // Signing with the debug keys for now, so `flutter run --release` works.
      signingConfig = signingConfigs.getByName("signingConfig")
    }
    debug {
      signingConfig = signingConfigs.getByName("signingConfig")
    }
  }
}

flutter {
  source = "../.."
}
