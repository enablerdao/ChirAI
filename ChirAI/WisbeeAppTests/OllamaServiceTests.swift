import XCTest
@testable import WisbeeApp

class OllamaServiceTests: XCTestCase {
    var sut: OllamaService!
    
    override func setUp() {
        super.setUp()
        sut = OllamaService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testSingletonInstance() {
        let instance1 = OllamaService.shared
        let instance2 = OllamaService.shared
        XCTAssertTrue(instance1 === instance2, "OllamaService should be a singleton")
    }
    
    func testSendMessageWithValidModel() async throws {
        // This test requires Ollama to be running
        do {
            let response = try await sut.sendMessage("Hello", model: "gemma3:1b")
            XCTAssertFalse(response.isEmpty, "Response should not be empty")
        } catch {
            // If Ollama is not running, skip the test
            if error.localizedDescription.contains("connection") {
                XCTSkip("Ollama service is not running")
            } else {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }
    
    func testSendMessageWithEmptyInput() async throws {
        do {
            let response = try await sut.sendMessage("", model: "gemma3:1b")
            XCTAssertFalse(response.isEmpty, "Model should still respond to empty input")
        } catch {
            if error.localizedDescription.contains("connection") {
                XCTSkip("Ollama service is not running")
            } else {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }
    
    func testSendMessageWithJapaneseInput() async throws {
        do {
            let response = try await sut.sendMessage("こんにちは", model: "qwen2.5:3b")
            XCTAssertFalse(response.isEmpty, "Response should not be empty for Japanese input")
        } catch {
            if error.localizedDescription.contains("connection") {
                XCTSkip("Ollama service is not running")
            } else {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }
    
    func testSendMessageWithInvalidModel() async {
        do {
            _ = try await sut.sendMessage("Hello", model: "nonexistent:model")
            XCTFail("Should throw an error for invalid model")
        } catch {
            // Expected behavior
            XCTAssertTrue(true, "Error thrown as expected for invalid model")
        }
    }
    
    func testResponseParsing() async throws {
        // Mock test for response parsing logic
        let mockJSONData = """
        {
            "choices": [{
                "message": {
                    "content": "Test response"
                }
            }]
        }
        """.data(using: .utf8)!
        
        do {
            let response = try JSONDecoder().decode(OllamaService.ChatCompletionResponse.self, from: mockJSONData)
            XCTAssertEqual(response.choices.first?.message.content, "Test response")
        } catch {
            XCTFail("Failed to parse mock response: \(error)")
        }
    }
}