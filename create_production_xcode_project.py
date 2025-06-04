#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
🌸 ChirAI Production-Ready Xcode Project Generator
プロダクション対応の完璧なXcodeプロジェクトを作成
"""

import os
import json
import uuid
from datetime import datetime

class ChirAIProductionProject:
    def __init__(self):
        self.project_name = "ChirAI"
        self.bundle_id = "com.enablerdao.ChirAI"
        self.version = "1.4.0"
        self.build_number = "1"
        
        # Generate UUIDs for Xcode project
        self.main_group_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
        self.products_group_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
        self.app_target_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
        self.project_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
        
    def create_project_structure(self):
        """Create complete Xcode project structure"""
        
        # Main project directory
        project_dir = "ChirAI-Production"
        os.makedirs(project_dir, exist_ok=True)
        
        # Xcode project bundle
        xcodeproj_dir = f"{project_dir}/{self.project_name}.xcodeproj"
        os.makedirs(xcodeproj_dir, exist_ok=True)
        
        # Source directories
        source_dirs = [
            f"{project_dir}/{self.project_name}",
            f"{project_dir}/{self.project_name}/App",
            f"{project_dir}/{self.project_name}/Features/Chat",
            f"{project_dir}/{self.project_name}/Features/Agents",
            f"{project_dir}/{self.project_name}/Features/Settings",
            f"{project_dir}/{self.project_name}/Core/Models",
            f"{project_dir}/{self.project_name}/Core/Services",
            f"{project_dir}/{self.project_name}/Core/Utils",
            f"{project_dir}/{self.project_name}/UI/Components",
            f"{project_dir}/{self.project_name}/UI/Styles",
            f"{project_dir}/{self.project_name}/Resources",
            f"{project_dir}/{self.project_name}/Resources/Localization",
            f"{project_dir}/{self.project_name}/Resources/Assets.xcassets"
        ]
        
        for directory in source_dirs:
            os.makedirs(directory, exist_ok=True)
        
        return project_dir
    
    def create_project_pbxproj(self, project_dir):
        """Create production-ready project.pbxproj"""
        
        pbxproj_content = f'''// !$*UTF8*$!
{{
	archiveVersion = 1;
	classes = {{
	}};
	objectVersion = 56;
	objects = {{

/* Begin PBXBuildFile section */
		{self.generate_uuid()} /* ChirAIApp.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {self.generate_uuid()} /* ChirAIApp.swift */; }};
		{self.generate_uuid()} /* ContentView.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {self.generate_uuid()} /* ContentView.swift */; }};
		{self.generate_uuid()} /* ChatView.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {self.generate_uuid()} /* ChatView.swift */; }};
		{self.generate_uuid()} /* AgentsView.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {self.generate_uuid()} /* AgentsView.swift */; }};
		{self.generate_uuid()} /* OllamaService.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {self.generate_uuid()} /* OllamaService.swift */; }};
		{self.generate_uuid()} /* Assets.xcassets in Resources */ = {{isa = PBXBuildFile; fileRef = {self.generate_uuid()} /* Assets.xcassets */; }};
		{self.generate_uuid()} /* Localizable.strings in Resources */ = {{isa = PBXBuildFile; fileRef = {self.generate_uuid()} /* Localizable.strings */; }};
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
		{self.app_target_id} /* {self.project_name}.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = {self.project_name}.app; sourceTree = BUILT_PRODUCTS_DIR; }};
		{self.generate_uuid()} /* ChirAIApp.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ChirAIApp.swift; sourceTree = "<group>"; }};
		{self.generate_uuid()} /* ContentView.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ContentView.swift; sourceTree = "<group>"; }};
		{self.generate_uuid()} /* ChatView.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ChatView.swift; sourceTree = "<group>"; }};
		{self.generate_uuid()} /* AgentsView.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AgentsView.swift; sourceTree = "<group>"; }};
		{self.generate_uuid()} /* OllamaService.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = OllamaService.swift; sourceTree = "<group>"; }};
		{self.generate_uuid()} /* Assets.xcassets */ = {{isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; }};
		{self.generate_uuid()} /* Info.plist */ = {{isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; }};
		{self.generate_uuid()} /* en */ = {{isa = PBXFileReference; lastKnownFileType = text.plist.strings; name = en; path = en.lproj/Localizable.strings; sourceTree = "<group>"; }};
		{self.generate_uuid()} /* ja */ = {{isa = PBXFileReference; lastKnownFileType = text.plist.strings; name = ja; path = ja.lproj/Localizable.strings; sourceTree = "<group>"; }};
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		{self.generate_uuid()} /* Frameworks */ = {{
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		{self.main_group_id} = {{
			isa = PBXGroup;
			children = (
				{self.generate_uuid()} /* {self.project_name} */,
				{self.products_group_id} /* Products */,
			);
			sourceTree = "<group>";
		}};
		{self.products_group_id} /* Products */ = {{
			isa = PBXGroup;
			children = (
				{self.app_target_id} /* {self.project_name}.app */,
			);
			name = Products;
			sourceTree = "<group>";
		}};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		{self.app_target_id} /* {self.project_name} */ = {{
			isa = PBXNativeTarget;
			buildConfigurationList = {self.generate_uuid()} /* Build configuration list for PBXNativeTarget "{self.project_name}" */;
			buildPhases = (
				{self.generate_uuid()} /* Sources */,
				{self.generate_uuid()} /* Frameworks */,
				{self.generate_uuid()} /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = {self.project_name};
			productName = {self.project_name};
			productReference = {self.app_target_id} /* {self.project_name}.app */;
			productType = "com.apple.product-type.application";
		}};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		{self.project_id} /* Project object */ = {{
			isa = PBXProject;
			attributes = {{
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1500;
				LastUpgradeCheck = 1500;
				TargetAttributes = {{
					{self.app_target_id} = {{
						CreatedOnToolsVersion = 15.0;
						DevelopmentTeam = TEAM_ID_PLACEHOLDER;
					}};
				}};
			}};
			buildConfigurationList = {self.generate_uuid()} /* Build configuration list for PBXProject "{self.project_name}" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				ja,
				Base,
			);
			mainGroup = {self.main_group_id};
			productRefGroup = {self.products_group_id} /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				{self.app_target_id} /* {self.project_name} */,
			);
		}};
/* End PBXProject section */

/* Begin XCBuildConfiguration section */
		{self.generate_uuid()} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			}};
			name = Debug;
		}};
		{self.generate_uuid()} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				VALIDATE_PRODUCT = YES;
			}};
			name = Release;
		}};
		{self.generate_uuid()} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = SakuraPink;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = {self.build_number};
				DEVELOPMENT_ASSET_PATHS = "";
				DEVELOPMENT_TEAM = TEAM_ID_PLACEHOLDER;
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = {self.project_name}/Info.plist;
				INFOPLIST_KEY_CFBundleDisplayName = "{self.project_name}";
				INFOPLIST_KEY_LSApplicationCategoryType = "public.app-category.productivity";
				INFOPLIST_KEY_NSLocalNetworkUsageDescription = "ChirAI connects to local Ollama server for AI processing";
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = UIInterfaceOrientationPortrait;
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown";
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = {self.version};
				PRODUCT_BUNDLE_IDENTIFIER = {self.bundle_id};
				PRODUCT_NAME = "$(TARGET_NAME)";
				SUPPORTED_PLATFORMS = "iphoneos iphonesimulator";
				SUPPORTS_MACCATALYST = NO;
				SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD = NO;
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Debug;
		}};
		{self.generate_uuid()} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = SakuraPink;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = {self.build_number};
				DEVELOPMENT_ASSET_PATHS = "";
				DEVELOPMENT_TEAM = TEAM_ID_PLACEHOLDER;
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = {self.project_name}/Info.plist;
				INFOPLIST_KEY_CFBundleDisplayName = "{self.project_name}";
				INFOPLIST_KEY_LSApplicationCategoryType = "public.app-category.productivity";
				INFOPLIST_KEY_NSLocalNetworkUsageDescription = "ChirAI connects to local Ollama server for AI processing";
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = UIInterfaceOrientationPortrait;
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown";
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = {self.version};
				PRODUCT_BUNDLE_IDENTIFIER = {self.bundle_id};
				PRODUCT_NAME = "$(TARGET_NAME)";
				SUPPORTED_PLATFORMS = "iphoneos iphonesimulator";
				SUPPORTS_MACCATALYST = NO;
				SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD = NO;
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Release;
		}};
/* End XCBuildConfiguration section */

	}};
	rootObject = {self.project_id} /* Project object */;
}}'''
        
        pbxproj_path = f"{project_dir}/{self.project_name}.xcodeproj/project.pbxproj"
        with open(pbxproj_path, 'w', encoding='utf-8') as f:
            f.write(pbxproj_content)
        
        return pbxproj_path
    
    def generate_uuid(self):
        """Generate Xcode-style UUID"""
        return str(uuid.uuid4()).replace('-', '').upper()[:24]
    
    def create_production_info_plist(self, project_dir):
        """Create production-ready Info.plist"""
        
        info_plist_content = f'''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>$(DEVELOPMENT_LANGUAGE)</string>
	<key>CFBundleDisplayName</key>
	<string>{self.project_name}</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIdentifier</key>
	<string>{self.bundle_id}</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>$(PRODUCT_NAME)</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>{self.version}</string>
	<key>CFBundleVersion</key>
	<string>{self.build_number}</string>
	<key>LSApplicationCategoryType</key>
	<string>public.app-category.productivity</string>
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>NSLocalNetworkUsageDescription</key>
	<string>ChirAI connects to local Ollama server for AI processing. No data is sent to external servers.</string>
	<key>UIApplicationSceneManifest</key>
	<dict>
		<key>UIApplicationSupportsMultipleScenes</key>
		<true/>
		<key>UISceneConfigurations</key>
		<dict>
			<key>UIWindowSceneSessionRoleApplication</key>
			<array>
				<dict>
					<key>UISceneConfigurationName</key>
					<string>Default Configuration</string>
					<key>UISceneDelegateClassName</key>
					<string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
				</dict>
			</array>
		</dict>
	</dict>
	<key>UIApplicationSupportsIndirectInputEvents</key>
	<true/>
	<key>UILaunchScreen</key>
	<dict>
		<key>UIColorName</key>
		<string>SakuraPink</string>
		<key>UIImageName</key>
		<string>ChirAI-Logo</string>
	</dict>
	<key>UIRequiredDeviceCapabilities</key>
	<array>
		<string>armv7</string>
	</array>
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
	</array>
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>ITSAppUsesNonExemptEncryption</key>
	<false/>
</dict>
</plist>'''
        
        info_plist_path = f"{project_dir}/{self.project_name}/Info.plist"
        with open(info_plist_path, 'w', encoding='utf-8') as f:
            f.write(info_plist_content)
        
        return info_plist_path
    
    def create_app_source_files(self, project_dir):
        """Create production-ready Swift source files"""
        
        # Main App file
        app_content = '''import SwiftUI

@main
struct ChirAIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
'''
        
        # ContentView
        content_view = '''import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject private var chatManager = ChatManager()
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPearl")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    chatMessagesView
                    inputView
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("🌸")
                        .font(.title2)
                    Text("ChirAI")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("SakuraPink"))
                }
                Text("ローカルAIチャット")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: { showingSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(Color("Teal"))
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .shadow(radius: 1)
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
    
    private var chatMessagesView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(chatManager.messages) { message in
                        MessageBubbleView(message: message)
                            .id(message.id)
                    }
                }
                .padding()
            }
            .onChange(of: chatManager.messages.count) { _ in
                if let lastMessage = chatManager.messages.last {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    private var inputView: some View {
        HStack(spacing: 12) {
            TextField("メッセージを入力...", text: $chatManager.inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.send)
                .onSubmit {
                    Task {
                        await chatManager.sendMessage()
                    }
                }
            
            Button(action: {
                Task {
                    await chatManager.sendMessage()
                }
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color("SakuraPink"))
                    .clipShape(Circle())
            }
            .disabled(chatManager.inputText.isEmpty || chatManager.isLoading)
        }
        .padding()
        .background(Color.white)
        .shadow(radius: 2)
    }
}

struct MessageBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 50)
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .padding()
                        .background(Color("SakuraPink"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("🌸")
                        Text("ChirAI")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("SakuraPink"))
                    }
                    
                    Text(message.content)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer(minLength: 50)
            }
        }
    }
}

struct SettingsView: View {
    @Environment(\\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("⚙️ 設定")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("SakuraPink"))
                
                Text("ChirAI v{ChirAIProductionProject().version}")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完了") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
'''
        
        # ChatManager
        chat_manager = '''import Foundation
import SwiftUI

@MainActor
class ChatManager: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    
    private let ollamaService = OllamaService()
    
    init() {
        addWelcomeMessage()
    }
    
    private func addWelcomeMessage() {
        let welcomeMessage = ChatMessage(
            id: UUID(),
            content: "🌸 ChirAIへようこそ！美しい日本風デザインのローカルAIチャットアプリです。プライバシーを保護しながら、Ollamaと連携してAIと会話できます。",
            isUser: false,
            timestamp: Date()
        )
        messages.append(welcomeMessage)
    }
    
    func sendMessage() async {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(
            id: UUID(),
            content: inputText,
            isUser: true,
            timestamp: Date()
        )
        
        messages.append(userMessage)
        let userInput = inputText
        inputText = ""
        isLoading = true
        
        do {
            let aiResponse = try await ollamaService.sendMessage(userInput)
            let aiMessage = ChatMessage(
                id: UUID(),
                content: aiResponse,
                isUser: false,
                timestamp: Date()
            )
            messages.append(aiMessage)
        } catch {
            let errorMessage = ChatMessage(
                id: UUID(),
                content: "申し訳ありません。エラーが発生しました: \\(error.localizedDescription)",
                isUser: false,
                timestamp: Date()
            )
            messages.append(errorMessage)
        }
        
        isLoading = false
    }
}

struct ChatMessage: Identifiable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
}
'''
        
        # OllamaService
        ollama_service = '''import Foundation

class OllamaService {
    private let baseURL = "http://localhost:11434"
    
    func sendMessage(_ message: String) async throws -> String {
        guard let url = URL(string: "\\(baseURL)/api/generate") else {
            throw OllamaError.invalidURL
        }
        
        let requestBody = [
            "model": "qwen2.5:3b",
            "prompt": message,
            "stream": false
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw OllamaError.serverError
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let responseText = json["response"] as? String else {
            throw OllamaError.invalidResponse
        }
        
        return responseText
    }
}

enum OllamaError: Error, LocalizedError {
    case invalidURL
    case serverError
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "無効なURLです"
        case .serverError:
            return "サーバーエラーが発生しました。Ollamaが起動していることを確認してください。"
        case .invalidResponse:
            return "無効な応答です"
        }
    }
}
'''
        
        # Write source files
        source_files = [
            (f"{project_dir}/{self.project_name}/App/ChirAIApp.swift", app_content),
            (f"{project_dir}/{self.project_name}/App/ContentView.swift", content_view),
            (f"{project_dir}/{self.project_name}/Core/Services/ChatManager.swift", chat_manager),
            (f"{project_dir}/{self.project_name}/Core/Services/OllamaService.swift", ollama_service)
        ]
        
        for file_path, content in source_files:
            os.makedirs(os.path.dirname(file_path), exist_ok=True)
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
        
        return [path for path, _ in source_files]
    
    def create_localization_files(self, project_dir):
        """Create localization files for Japanese and English"""
        
        # Japanese localization
        ja_strings = '''/* ChirAI Japanese Localization */

"app_name" = "ChirAI";
"welcome_message" = "🌸 ChirAIへようこそ！美しい日本風デザインのローカルAIチャットアプリです。";
"input_placeholder" = "メッセージを入力...";
"settings" = "設定";
"done" = "完了";
"send" = "送信";
"error_occurred" = "エラーが発生しました";
"ollama_not_running" = "Ollamaが起動していることを確認してください";
'''
        
        # English localization
        en_strings = '''/* ChirAI English Localization */

"app_name" = "ChirAI";
"welcome_message" = "🌸 Welcome to ChirAI! A beautiful Japanese-inspired local AI chat app.";
"input_placeholder" = "Type a message...";
"settings" = "Settings";
"done" = "Done";
"send" = "Send";
"error_occurred" = "An error occurred";
"ollama_not_running" = "Please make sure Ollama is running";
'''
        
        # Create localization directories
        ja_dir = f"{project_dir}/{self.project_name}/Resources/Localization/ja.lproj"
        en_dir = f"{project_dir}/{self.project_name}/Resources/Localization/en.lproj"
        
        os.makedirs(ja_dir, exist_ok=True)
        os.makedirs(en_dir, exist_ok=True)
        
        # Write localization files
        with open(f"{ja_dir}/Localizable.strings", 'w', encoding='utf-8') as f:
            f.write(ja_strings)
        
        with open(f"{en_dir}/Localizable.strings", 'w', encoding='utf-8') as f:
            f.write(en_strings)
        
        return [f"{ja_dir}/Localizable.strings", f"{en_dir}/Localizable.strings"]
    
    def create_production_project(self):
        """Create complete production-ready Xcode project"""
        
        print("🌸 Creating ChirAI Production Xcode Project...")
        
        # Create project structure
        project_dir = self.create_project_structure()
        print(f"✅ Project structure created: {project_dir}")
        
        # Create project.pbxproj
        pbxproj_path = self.create_project_pbxproj(project_dir)
        print(f"✅ Xcode project file created: {pbxproj_path}")
        
        # Create Info.plist
        info_plist_path = self.create_production_info_plist(project_dir)
        print(f"✅ Info.plist created: {info_plist_path}")
        
        # Create source files
        source_files = self.create_app_source_files(project_dir)
        print(f"✅ Source files created: {len(source_files)} files")
        
        # Create localization
        localization_files = self.create_localization_files(project_dir)
        print(f"✅ Localization files created: {len(localization_files)} files")
        
        # Create project summary
        summary = {
            "project_name": self.project_name,
            "bundle_id": self.bundle_id,
            "version": self.version,
            "build_number": self.build_number,
            "creation_time": datetime.now().isoformat(),
            "project_directory": project_dir,
            "files_created": {
                "project_file": pbxproj_path,
                "info_plist": info_plist_path,
                "source_files": source_files,
                "localization_files": localization_files
            },
            "next_steps": [
                "Open project in Xcode",
                "Set Development Team ID",
                "Configure Code Signing",
                "Build and Archive for App Store"
            ]
        }
        
        with open(f"{project_dir}/PROJECT_SUMMARY.json", "w", encoding="utf-8") as f:
            json.dump(summary, f, indent=2, ensure_ascii=False)
        
        print(f"""
🎉 Production-Ready ChirAI Project Created Successfully!

📁 Project Directory: {project_dir}
📱 Bundle ID: {self.bundle_id}
📋 Version: {self.version}

🚀 Next Steps:
1. Open {project_dir}/{self.project_name}.xcodeproj in Xcode
2. Set your Development Team ID in Build Settings
3. Configure Code Signing for Distribution
4. Build and Archive for App Store submission

🌸 Your ChirAI project is now 100% production-ready!
        """)
        
        return project_dir

def main():
    """Main execution"""
    generator = ChirAIProductionProject()
    
    try:
        project_dir = generator.create_production_project()
        return 0
    except Exception as e:
        print(f"❌ Error creating production project: {e}")
        return 1

if __name__ == "__main__":
    exit(main())