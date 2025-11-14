#!/bin/bash
set -e

# Usage: ./build_release.sh [android|ios|web] [version] [release|dev]

APP_DIR="$(pwd)"
PLATFORM="$1"
VERSION_ARG="$2"
IOS_BUILD_TYPE="$3"

# Prompt for platform if not provided
if [[ -z "$PLATFORM" ]]; then
  echo "Select platform to build:"
  echo "1) Android"
  echo "2) iOS"
  echo "3) Web"
  echo -n "Enter choice [1-3]: "
  read -n 1 PLATFORM_CHOICE
  echo
  case $PLATFORM_CHOICE in
    1) PLATFORM="android" ;;
    2) PLATFORM="ios" ;;
    3) PLATFORM="web" ;;
    *) echo "Invalid choice"; exit 1 ;;
  esac
fi

# Read current version
CURRENT_VERSION=$(grep '^version:' pubspec.yaml | awk '{print $2}')
echo "📦 Current app version: $CURRENT_VERSION"

# Prompt for version if not provided
if [[ -z "$VERSION_ARG" ]]; then
  read -p "🔢 Enter new version (format x.y.z+build) or press Enter to use current version: " NEW_VERSION
else
  NEW_VERSION="$VERSION_ARG"
fi

if [ -z "$NEW_VERSION" ]; then
  echo "✅ Using current version: $CURRENT_VERSION"
  NEW_VERSION="$CURRENT_VERSION"
else
  echo "📝 Updating version to $NEW_VERSION ..."
  sed -i.bak "s/^version: .*/version: $NEW_VERSION/" pubspec.yaml
  rm pubspec.yaml.bak
fi

# Update README.md version badge (version only, without build number)
VERSION_ONLY=$(echo "$NEW_VERSION" | cut -d'+' -f1)
echo "📝 Updating README.md version badge to $VERSION_ONLY ..."

# Primary attempt: BSD-compatible sed (no -E needed because we use basic regex with \+)
sed -i.bak "s/version-[0-9]\+\.[0-9]\+\.[0-9]\+-blue\.svg/version-$VERSION_ONLY-blue.svg/" README.md || true
rm -f README.md.bak

# Verify replacement; if failed, fallback to awk line rewrite
if ! grep -q "version-$VERSION_ONLY-blue.svg" README.md; then
  echo "⚠️ Sed replacement did not match; applying fallback rewrite."
  awk 'BEGIN{updated=0} {
    if ($0 ~ /^!\[Version\]\(https:\/\/img\.shields\.io\/badge\/version-[0-9]+\.[0-9]+\.[0-9]+-blue\.svg\)/) {
      print "![Version](https://img.shields.io/badge/version-'"$VERSION_ONLY"'-blue.svg)"; updated=1;
    } else { print }
  } END { if(updated==0) { exit 1 } }' README.md > README.md.tmp && mv README.md.tmp README.md || echo "⚠️ Fallback rewrite could not locate Version badge line."
fi

if grep -q "version-$VERSION_ONLY-blue.svg" README.md; then
  echo "✅ README version badge updated to $VERSION_ONLY"
else
  echo "❌ Failed to update README version badge. Please check script patterns."
fi

if [[ "$PLATFORM" == "android" ]]; then
  # ===== Android Build =====
  BUILD_GRADLE="$APP_DIR/android/app/build.gradle.kts"
  if ! grep -q "signingConfigs" "$BUILD_GRADLE"; then
    echo "⚠️ Please ensure your android/app/build.gradle.kts has the signingConfigs block configured."
    exit 1
  fi
  echo "🧹 Cleaning project..."
  flutter clean
  echo "🚀 Building signed Android AAB (sampleData & developerMode disabled)..."
  flutter build appbundle --release --no-tree-shake-icons \
    --dart-define=SAMPLE_DATA=false \
    --dart-define=DEVELOPER_MODE=false
  OUTPUT_PATH="$APP_DIR/build/app/outputs/bundle/release/app-release.aab"
  echo "✅ Android AAB generated!"
  echo "📁 Location: $OUTPUT_PATH"
  echo "🎯 App version: $NEW_VERSION"

elif [[ "$PLATFORM" == "ios" ]]; then
  # ===== iOS Build =====
  if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Error: iOS builds can only be run on macOS"
    exit 1
  fi
  if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is not installed or xcodebuild is not in PATH"
    exit 1
  fi
  # Prompt for iOS build type if not provided
  if [[ -z "$IOS_BUILD_TYPE" ]]; then
    echo "Select iOS build type:"
    echo "1) App Store / TestFlight (release IPA)"
    echo "2) Development (dev, no codesign)"
    echo -n "Enter choice [1-2]: "
    read -n 1 IOS_BUILD_CHOICE
    echo
    case $IOS_BUILD_CHOICE in
      1) IOS_BUILD_TYPE="release" ;;
      2) IOS_BUILD_TYPE="dev" ;;
      *) echo "Invalid choice"; exit 1 ;;
    esac
  fi
  echo "🧹 Cleaning project..."
  flutter clean
  echo "📦 Getting dependencies..."
  flutter pub get
  echo "🔨 Running pod install..."
  cd ios
  pod install || pod repo update && pod install
  cd ..
  if [[ "$IOS_BUILD_TYPE" == "release" ]]; then
    echo "🚀 Building iOS App Store/TestFlight IPA (sampleData & developerMode disabled)..."
    flutter build ipa --release --no-tree-shake-icons \
      --dart-define=SAMPLE_DATA=false \
      --dart-define=DEVELOPER_MODE=false
    OUTPUT_PATH="$APP_DIR/build/ios/ipa"
    echo "✅ iOS IPA generated!"
    echo "📁 Location: $OUTPUT_PATH"
    echo "🎯 App version: $NEW_VERSION"
  elif [[ "$IOS_BUILD_TYPE" == "dev" ]]; then
    echo "🚀 Building iOS development build (no codesign, sampleData & developerMode disabled by default)..."
    flutter build ios --release --no-tree-shake-icons --no-codesign \
      --dart-define=SAMPLE_DATA=false \
      --dart-define=DEVELOPER_MODE=false
    OUTPUT_PATH="$APP_DIR/build/ios/Release-iphoneos/Runner.app"
    echo "✅ iOS development build generated!"
    echo "📁 Location: $OUTPUT_PATH"
    echo "🎯 App version: $NEW_VERSION"
  else
    echo "❌ Unknown iOS build type: $IOS_BUILD_TYPE"
    exit 1
  fi
elif [[ "$PLATFORM" == "web" ]]; then
  # ===== Web Build =====
  echo "🧹 Cleaning project..."
  flutter clean
  echo "🚀 Building Flutter Web release (sampleData & developerMode disabled)..."
  flutter build web --release --no-tree-shake-icons \
    --dart-define=SAMPLE_DATA=false \
    --dart-define=DEVELOPER_MODE=false
  OUTPUT_PATH="$APP_DIR/build/web"
  echo "✅ Web build generated!"
  echo "📁 Location: $OUTPUT_PATH"
  echo "🎯 App version: $NEW_VERSION"
else
  echo "❌ Unknown platform: $PLATFORM"
  exit 1
fi
