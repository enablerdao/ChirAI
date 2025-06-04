#\!/usr/bin/env python3
import os
import subprocess

# Create a minimal Xcode project using xcrun
def create_xcode_project():
    # Create project structure
    os.makedirs("Wisbee.app/Contents", exist_ok=True)
    
    # Create Info.plist
    info_plist = """<?xml version="1.0" encoding="UTF-8"?>
<\!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>Wisbee</string>
    <key>CFBundleIdentifier</key>
    <string>com.wisbee.app</string>
    <key>CFBundleName</key>
    <string>Wisbee</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <true/>
    </dict>
    <key>UILaunchScreen</key>
    <dict/>
</dict>
</plist>"""
    
    with open("Wisbee.app/Contents/Info.plist", "w") as f:
        f.write(info_plist)
    
    print("Created minimal app structure")
    
    # Compile Swift code
    print("Compiling Swift code...")
    compile_cmd = [
        "swiftc",
        "-target", "arm64-apple-ios17.0-simulator",
        "-sdk", "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk",
        "-o", "Wisbee.app/Contents/Wisbee",
        "WisbeeSimple.swift"
    ]
    
    try:
        subprocess.run(compile_cmd, check=True)
        print("Compilation successful\!")
        
        # Open in simulator
        print("Opening in simulator...")
        subprocess.run(["open", "-a", "Simulator"])
        
    except subprocess.CalledProcessError as e:
        print(f"Compilation failed: {e}")

if __name__ == "__main__":
    create_xcode_project()
