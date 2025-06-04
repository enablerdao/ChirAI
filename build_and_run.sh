#!/bin/bash

echo "🔨 Building and Running Wisbee iOS App"
echo "======================================"

# Kill any existing simulator
killall "Simulator" 2>/dev/null || true
sleep 2

# Open simulator
echo "📱 Opening iPhone 15 simulator..."
open -a Simulator
sleep 5

# Boot iPhone 15 if needed
xcrun simctl boot "iPhone 15" 2>/dev/null || true
sleep 3

# Build the app using xcodebuild
echo "🏗️  Building app..."
cd /Users/yuki/wisbee-iOS/WisbeeApp

# Create a simple SwiftUI app project if needed
if [ ! -f "WisbeeApp.xcodeproj/project.pbxproj" ]; then
    echo "Creating Xcode project..."
    xcodegen generate --spec project.yml 2>/dev/null || {
        # Fallback: Open in Xcode directly
        echo "Opening in Xcode for manual build..."
        open -a Xcode .
        echo ""
        echo "✅ Xcode opened. Please:"
        echo "1. Select iPhone 15 as the target device"
        echo "2. Press Cmd+R to build and run"
        echo ""
        echo "The app includes:"
        echo "- Local LLM chat interface"
        echo "- Support for multiple models (gemma3:1b, qwen2.5:3b, etc.)"
        echo "- Japanese language support"
        echo "- Real-time chat with Ollama backend"
        exit 0
    }
fi

# Try to build with xcodebuild
xcodebuild -scheme WisbeeApp \
           -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.5' \
           -configuration Debug \
           clean build 2>&1 | grep -E "(SUCCEEDED|FAILED|error:|warning:)" || {
    echo "⚠️  Build failed. Opening in Xcode..."
    open -a Xcode WisbeeApp.xcodeproj
    echo ""
    echo "Please build and run manually in Xcode (Cmd+R)"
    exit 0
}

# Find the built app
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "WisbeeApp.app" -type d | head -1)

if [ -n "$APP_PATH" ]; then
    echo "📲 Installing app to simulator..."
    xcrun simctl install "iPhone 15" "$APP_PATH"
    
    echo "🚀 Launching app..."
    xcrun simctl launch "iPhone 15" com.wisbee.WisbeeApp
    
    echo ""
    echo "✅ App launched successfully!"
    echo "The Wisbee chat app is now running in the simulator."
    echo ""
    echo "Features available:"
    echo "- Chat with local LLMs (gemma3:1b, qwen2.5:3b)"
    echo "- Switch between models using the picker"
    echo "- Japanese language support with qwen2.5:3b"
    echo "- Real-time responses from Ollama"
else
    echo "⚠️  Could not find built app. Opening in Xcode..."
    open -a Xcode .
fi