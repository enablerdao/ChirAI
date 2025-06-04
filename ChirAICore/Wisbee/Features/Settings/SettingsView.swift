import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showSignOutAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                // User section
                if let user = appState.currentUser {
                    Section {
                        HStack {
                            Circle()
                                .fill(Color.honeycomb.primary)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Text(user.name.prefix(1).uppercased())
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name)
                                    .font(.headline)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.honeycomb.textSecondary)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // Appearance
                Section("Appearance") {
                    Picker("Theme", selection: $themeManager.currentTheme) {
                        ForEach(Theme.allCases, id: \.self) { theme in
                            Text(theme.displayName).tag(theme)
                        }
                    }
                    
                    HStack {
                        Text("Accent Color")
                        Spacer()
                        Circle()
                            .fill(themeManager.accentColor)
                            .frame(width: 24, height: 24)
                    }
                }
                
                // Privacy & Security
                Section("Privacy & Security") {
                    NavigationLink(destination: PrivacySettingsView()) {
                        Label("Privacy Settings", systemImage: "lock.shield")
                    }
                    
                    NavigationLink(destination: SecuritySettingsView()) {
                        Label("Security", systemImage: "lock")
                    }
                    
                    NavigationLink(destination: DataManagementView()) {
                        Label("Data Management", systemImage: "externaldrive")
                    }
                }
                
                // Models & Agents
                Section("Models & Agents") {
                    NavigationLink(destination: ModelManagementView()) {
                        Label("Model Management", systemImage: "cpu")
                    }
                    
                    NavigationLink(destination: AgentSettingsView()) {
                        Label("Agent Settings", systemImage: "brain")
                    }
                }
                
                // Advanced
                Section("Advanced") {
                    NavigationLink(destination: DeveloperSettingsView()) {
                        Label("Developer Options", systemImage: "hammer")
                    }
                    
                    NavigationLink(destination: ExperimentalFeaturesView()) {
                        Label("Experimental Features", systemImage: "flask")
                    }
                }
                
                // About
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.honeycomb.textSecondary)
                    }
                    
                    NavigationLink(destination: AboutView()) {
                        Text("About Wisbee")
                    }
                    
                    Link("Privacy Policy", destination: URL(string: "https://wisbee.app/privacy")!)
                    Link("Terms of Service", destination: URL(string: "https://wisbee.app/terms")!)
                }
                
                // Sign out
                Section {
                    Button(action: { showSignOutAlert = true }) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Sign Out", role: .destructive) {
                    appState.signOut()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
}

struct PrivacySettingsView: View {
    @State private var localProcessingOnly = true
    @State private var analyticsEnabled = false
    @State private var crashReporting = false
    
    var body: some View {
        Form {
            Section {
                Toggle("Local Processing Only", isOn: $localProcessingOnly)
                Text("All AI processing happens on your device. No data is sent to external servers.")
                    .font(.caption)
                    .foregroundColor(.honeycomb.textSecondary)
            }
            
            Section("Data Collection") {
                Toggle("Analytics", isOn: $analyticsEnabled)
                Toggle("Crash Reporting", isOn: $crashReporting)
            }
            
            Section("Data Sharing") {
                HStack {
                    Text("Share Usage Data")
                    Spacer()
                    Text("Never")
                        .foregroundColor(.honeycomb.textSecondary)
                }
                
                HStack {
                    Text("Share Model Performance")
                    Spacer()
                    Text("Never")
                        .foregroundColor(.honeycomb.textSecondary)
                }
            }
        }
        .navigationTitle("Privacy Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SecuritySettingsView: View {
    @State private var biometricEnabled = true
    @State private var autoLockEnabled = true
    @State private var autoLockDuration = 5
    
    var body: some View {
        Form {
            Section("Authentication") {
                Toggle("Face ID / Touch ID", isOn: $biometricEnabled)
                
                Toggle("Auto-Lock", isOn: $autoLockEnabled)
                
                if autoLockEnabled {
                    Picker("Auto-Lock Duration", selection: $autoLockDuration) {
                        Text("1 minute").tag(1)
                        Text("5 minutes").tag(5)
                        Text("15 minutes").tag(15)
                        Text("30 minutes").tag(30)
                    }
                }
            }
            
            Section("Encryption") {
                HStack {
                    Text("Message Encryption")
                    Spacer()
                    Text("End-to-End")
                        .foregroundColor(.honeycomb.success)
                }
                
                HStack {
                    Text("Local Storage")
                    Spacer()
                    Text("AES-256")
                        .foregroundColor(.honeycomb.success)
                }
            }
        }
        .navigationTitle("Security")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ModelManagementView: View {
    @State private var installedModels: [String] = ["Llama 2 7B", "Mistral 7B"]
    @State private var availableModels: [String] = ["CodeLlama 13B", "Vicuna 13B"]
    
    var body: some View {
        List {
            Section("Installed Models") {
                ForEach(installedModels, id: \.self) { model in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(model)
                                .font(.headline)
                            Text("7.2 GB")
                                .font(.caption)
                                .foregroundColor(.honeycomb.textSecondary)
                        }
                        Spacer()
                        Button("Remove") {
                            // Remove model
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            
            Section("Available Models") {
                ForEach(availableModels, id: \.self) { model in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(model)
                                .font(.headline)
                            Text("13.5 GB")
                                .font(.caption)
                                .foregroundColor(.honeycomb.textSecondary)
                        }
                        Spacer()
                        Button("Install") {
                            // Install model
                        }
                    }
                }
            }
        }
        .navigationTitle("Model Management")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Stub views for remaining settings screens
struct DataManagementView: View {
    var body: some View {
        Form {
            Section("Storage") {
                HStack {
                    Text("Total Storage Used")
                    Spacer()
                    Text("2.3 GB")
                        .foregroundColor(.honeycomb.textSecondary)
                }
            }
        }
        .navigationTitle("Data Management")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AgentSettingsView: View {
    var body: some View {
        Form {
            Section("Default Behavior") {
                // Agent settings
            }
        }
        .navigationTitle("Agent Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DeveloperSettingsView: View {
    var body: some View {
        Form {
            Section("Debug") {
                // Developer options
            }
        }
        .navigationTitle("Developer Options")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExperimentalFeaturesView: View {
    var body: some View {
        Form {
            Section("Beta Features") {
                // Experimental features
            }
        }
        .navigationTitle("Experimental Features")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    var body: some View {
        VStack(spacing: 24) {
            HexagonView(size: 120, color: .honeycomb.primary, icon: "brain")
            
            Text("Wisbee")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("The Hive Mind of AI Collaboration")
                .font(.headline)
                .foregroundColor(.honeycomb.textSecondary)
            
            Text("Version 1.0.0")
                .font(.subheadline)
                .foregroundColor(.honeycomb.textSecondary)
            
            Spacer()
        }
        .padding()
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}