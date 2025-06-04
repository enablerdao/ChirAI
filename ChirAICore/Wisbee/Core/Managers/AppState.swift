import Foundation
import SwiftUI
import Combine

@MainActor
class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    @Published var activeWorkspace: Workspace?
    @Published var isLoading: Bool = false
    @Published var error: AppError?
    @Published var networkStatus: NetworkStatus = .connected
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupObservers()
        checkAuthenticationStatus()
    }
    
    private func setupObservers() {
        NotificationCenter.default.publisher(for: .networkStatusChanged)
            .compactMap { $0.object as? NetworkStatus }
            .receive(on: DispatchQueue.main)
            .assign(to: &$networkStatus)
    }
    
    private func checkAuthenticationStatus() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            if let savedUser = UserDefaults.standard.user {
                self.currentUser = savedUser
                self.isAuthenticated = true
                await loadWorkspace()
            }
        }
    }
    
    func signIn(email: String, password: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        // Simulate authentication
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let user = User(
            id: UUID().uuidString,
            email: email,
            name: "User",
            avatarUrl: nil
        )
        
        self.currentUser = user
        self.isAuthenticated = true
        UserDefaults.standard.user = user
        
        await loadWorkspace()
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
        activeWorkspace = nil
        UserDefaults.standard.user = nil
    }
    
    private func loadWorkspace() async {
        // Load or create default workspace
        self.activeWorkspace = Workspace(
            id: UUID(),
            name: "Personal Workspace",
            ownerId: currentUser?.id ?? "",
            members: [],
            channels: [],
            agents: [Agent.queenBee, Agent.workerBee, Agent.scoutBee]
        )
    }
}

enum NetworkStatus {
    case connected
    case disconnected
    case connecting
}

enum AppError: LocalizedError {
    case authenticationFailed
    case networkError
    case dataError(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .authenticationFailed:
            return "Authentication failed. Please try again."
        case .networkError:
            return "Network connection error."
        case .dataError(let message):
            return message
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

struct User: Codable, Identifiable {
    let id: String
    var email: String
    var name: String
    var avatarUrl: URL?
    var preferences: UserPreferences = UserPreferences()
}

struct UserPreferences: Codable {
    var theme: String = "system"
    var language: String = "en"
    var notifications: Bool = true
}

struct Workspace: Identifiable, Codable {
    let id: UUID
    var name: String
    var ownerId: String
    var members: [WorkspaceMember]
    var channels: [Channel]
    var agents: [Agent]
    var createdAt: Date = Date()
}

struct WorkspaceMember: Codable, Identifiable {
    let id: String
    var userId: String
    var role: String
    var permissions: Set<String>
    var joinedAt: Date
}

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}

extension UserDefaults {
    private enum Keys {
        static let user = "currentUser"
    }
    
    var user: User? {
        get {
            guard let data = data(forKey: Keys.user) else { return nil }
            return try? JSONDecoder().decode(User.self, from: data)
        }
        set {
            if let user = newValue,
               let data = try? JSONEncoder().encode(user) {
                set(data, forKey: Keys.user)
            } else {
                removeObject(forKey: Keys.user)
            }
        }
    }
}