import Foundation

struct AppConfig {
    static let shared = AppConfig()
    
    // API Configuration
    let ollamaBaseURL: String
    let defaultModel: String
    let requestTimeout: TimeInterval
    
    // Testing Configuration
    let isTestMode: Bool
    let mockResponses: Bool
    
    private init() {
        // Check if running in test mode
        let isTest = ProcessInfo.processInfo.environment["TEST_MODE"] == "1"
        let isMock = ProcessInfo.processInfo.environment["MOCK_MODE"] == "1"
        
        self.isTestMode = isTest
        self.mockResponses = isMock
        
        // Configure base URL based on environment
        if let customURL = ProcessInfo.processInfo.environment["OLLAMA_URL"] {
            self.ollamaBaseURL = customURL
        } else {
            self.ollamaBaseURL = "http://localhost:11434"
        }
        
        // Configure default model
        if let customModel = ProcessInfo.processInfo.environment["DEFAULT_MODEL"] {
            self.defaultModel = customModel
        } else {
            self.defaultModel = "gemma3:1b"
        }
        
        // Configure timeout
        self.requestTimeout = isTest ? 5.0 : 30.0
    }
    
    // Available models for the picker
    var availableModels: [String] {
        if mockResponses {
            return ["mock-model-1", "mock-model-2"]
        }
        
        return [
            "gemma3:1b",
            "gemma3:4b",
            "jaahas/qwen3-abliterated:0.6b",
            "variant-iter1-8262349e:latest",
            "variant-iter1-25a8cae8:latest",
            "qwen2.5:3b"
        ]
    }
}