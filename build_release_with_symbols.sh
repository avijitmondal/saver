#!/bin/bash

# Saver App - Release Build Script with Debug Symbols
# This script builds the app bundle with debug symbols for Google Play Store

set -e  # Exit on any error

echo "🚀 Building Saver App Bundle with Debug Symbols..."
echo "================================================="

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "pubspec.yaml not found. Are you in the Flutter project root?"
    exit 1
fi

# Clean previous builds
print_status "Cleaning previous builds..."
flutter clean
if [ $? -eq 0 ]; then
    print_success "Clean completed"
else
    print_error "Clean failed"
    exit 1
fi

# Get dependencies
print_status "Getting dependencies..."
flutter pub get
if [ $? -eq 0 ]; then
    print_success "Dependencies resolved"
else
    print_error "Failed to get dependencies"
    exit 1
fi

# Generate app icons
print_status "Generating app icons..."
flutter pub run flutter_launcher_icons:main
if [ $? -eq 0 ]; then
    print_success "App icons generated"
else
    print_warning "App icon generation failed (continuing anyway)"
fi

# Create symbols directory if it doesn't exist
mkdir -p build/app/outputs/symbols

# Check for signing configuration
print_status "Checking signing configuration..."

# Set your keystore details here or use environment variables
KEYSTORE_PATH="${KEYSTORE_PATH:-android/upload-keystore.jks}"
KEY_ALIAS="${KEY_ALIAS:-upload}"
STORE_PASSWORD="${STORE_PASSWORD}"
KEY_PASSWORD="${KEY_PASSWORD}"

if [ ! -f "$KEYSTORE_PATH" ]; then
    print_error "Keystore not found at: $KEYSTORE_PATH"
    print_error "Please create a keystore or update KEYSTORE_PATH"
    echo ""
    echo "To create a keystore, run:"
    echo "keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload"
    exit 1
fi

if [ -z "$STORE_PASSWORD" ] || [ -z "$KEY_PASSWORD" ]; then
    print_error "Keystore passwords not set!"
    echo "Please set environment variables:"
    echo "export STORE_PASSWORD='your_store_password'"
    echo "export KEY_PASSWORD='your_key_password'"
    echo ""
    echo "Or edit this script to set them directly (not recommended for production)"
    exit 1
fi

print_success "Signing configuration found"

# Build release app bundle with debug symbols and proper signing
print_status "Building release app bundle with debug symbols..."
print_status "This may take several minutes..."

flutter build appbundle \
    --release \
    --verbose \
    --build-name=1.0.2 \
    --build-number=3 \
    --split-debug-info=build/app/outputs/symbols \
    --obfuscate \
    --dart-define=FLUTTER_WEB_CANVASKIT_URL=https://unpkg.com/canvaskit-wasm@0.33.0/bin/

BUILD_EXIT_CODE=$?

if [ $BUILD_EXIT_CODE -eq 0 ]; then
    print_success "Build completed successfully!"
else
    print_error "Build failed with exit code $BUILD_EXIT_CODE"
    exit 1
fi

echo ""
echo "================================================="
print_success "Saver App Bundle Build Complete!"
echo "================================================="
echo ""

# Check if files were generated
APP_BUNDLE_PATH="build/app/outputs/bundle/release/app-release.aab"
SYMBOLS_PATH="build/app/outputs/symbols"

echo "📁 Generated Files:"
echo "=================="

if [ -f "$APP_BUNDLE_PATH" ]; then
    APP_SIZE=$(du -h "$APP_BUNDLE_PATH" | cut -f1)
    print_success "📱 App Bundle: $APP_BUNDLE_PATH ($APP_SIZE)"
else
    print_error "❌ App Bundle not found at $APP_BUNDLE_PATH"
fi

if [ -d "$SYMBOLS_PATH" ] && [ "$(ls -A $SYMBOLS_PATH)" ]; then
    SYMBOL_COUNT=$(ls -1 "$SYMBOLS_PATH" | wc -l)
    print_success "🔧 Debug Symbols: $SYMBOLS_PATH ($SYMBOL_COUNT files)"
    echo "   Symbol files:"
    for file in "$SYMBOLS_PATH"/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            filesize=$(du -h "$file" | cut -f1)
            echo "   - $filename ($filesize)"
        fi
    done
else
    print_warning "⚠️  Debug symbols directory is empty or missing"
fi

echo ""
echo "📋 Next Steps:"
echo "=============="
echo "1. 📤 Upload to Google Play Console:"
echo "   - Go to Google Play Console"
echo "   - Upload: $APP_BUNDLE_PATH"
echo ""
echo "2. 🔧 Upload Debug Symbols:"
echo "   - In Play Console, go to App Bundle Explorer"
echo "   - Find your uploaded bundle"
echo "   - Click 'Upload debug symbols'"
echo "   - Upload all files from: $SYMBOLS_PATH"
echo ""
echo "3. ✅ Verify Upload:"
echo "   - Check that symbols are listed in Play Console"
echo "   - This resolves the 'missing debug symbols' warning"
echo ""

# Create a summary file
SUMMARY_FILE="build_summary.txt"
cat > "$SUMMARY_FILE" << EOF
Saver App Build Summary
======================
Build Date: $(date)
Build Type: Release with Debug Symbols
Flutter Version: $(flutter --version | head -n1)

Files Generated:
- App Bundle: $APP_BUNDLE_PATH
- Debug Symbols: $SYMBOLS_PATH

Build Command Used:
flutter build appbundle --release --verbose --build-name=1.0.2 --build-number=3 --split-debug-info=build/app/outputs/symbols --obfuscate

Next Steps:
1. Upload app bundle to Google Play Console
2. Upload debug symbols to resolve Play Console warning
3. Test the release build before publishing
EOF

print_success "Build summary saved to: $SUMMARY_FILE"

echo ""
print_success "🎉 Ready for Google Play Store upload!"
echo ""

# Make sure the script is executable
chmod +x "$0"
