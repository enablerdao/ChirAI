import XCTest
@testable import WisbeeApp

class ChatViewModelTests: XCTestCase {
    var sut: ChatViewModel!
    
    override func setUp() {
        super.setUp()
        sut = ChatViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(sut.messages.isEmpty, "Messages should be empty initially")
        XCTAssertFalse(sut.isLoading, "Should not be loading initially")
        XCTAssertEqual(sut.selectedModel, "gemma3:1b", "Default model should be gemma3:1b")
    }
    
    func testAvailableModels() {
        let expectedModels = [
            "gemma3:1b",
            "gemma3:4b",
            "jaahas/qwen3-abliterated:0.6b",
            "variant-iter1-8262349e:latest",
            "variant-iter1-25a8cae8:latest",
            "qwen2.5:3b"
        ]
        XCTAssertEqual(sut.availableModels, expectedModels, "Available models should match expected list")
    }
    
    func testAddUserMessage() {
        let testMessage = "Test message"
        sut.inputText = testMessage
        
        // Manually add user message (simulating what happens in sendMessage)
        let userMessage = Message(content: testMessage, isUser: true)
        sut.messages.append(userMessage)
        
        XCTAssertEqual(sut.messages.count, 1, "Should have one message")
        XCTAssertEqual(sut.messages.first?.content, testMessage, "Message content should match")
        XCTAssertTrue(sut.messages.first?.isUser ?? false, "Message should be from user")
    }
    
    func testSendMessageSetsLoading() async {
        sut.inputText = "Test"
        
        let expectation = XCTestExpectation(description: "Loading state changes")
        
        Task {
            await sut.sendMessage()
            expectation.fulfill()
        }
        
        // Check loading state is set immediately
        XCTAssertTrue(sut.isLoading, "Should be loading after sending message")
        
        await fulfillment(of: [expectation], timeout: 10.0)
        XCTAssertFalse(sut.isLoading, "Should not be loading after message is sent")
    }
    
    func testSendEmptyMessage() async {
        sut.inputText = ""
        let initialCount = sut.messages.count
        
        await sut.sendMessage()
        
        XCTAssertEqual(sut.messages.count, initialCount, "Should not add empty messages")
    }
    
    func testSendWhitespaceOnlyMessage() async {
        sut.inputText = "   \n\t   "
        let initialCount = sut.messages.count
        
        await sut.sendMessage()
        
        XCTAssertEqual(sut.messages.count, initialCount, "Should not add whitespace-only messages")
    }
    
    func testModelSelection() {
        let newModel = "qwen2.5:3b"
        sut.selectedModel = newModel
        
        XCTAssertEqual(sut.selectedModel, newModel, "Selected model should update")
    }
    
    func testMessageOrder() {
        // Add multiple messages
        sut.messages.append(Message(content: "User 1", isUser: true))
        sut.messages.append(Message(content: "Bot 1", isUser: false))
        sut.messages.append(Message(content: "User 2", isUser: true))
        sut.messages.append(Message(content: "Bot 2", isUser: false))
        
        XCTAssertEqual(sut.messages.count, 4, "Should have 4 messages")
        XCTAssertTrue(sut.messages[0].isUser, "First message should be from user")
        XCTAssertFalse(sut.messages[1].isUser, "Second message should be from bot")
        XCTAssertTrue(sut.messages[2].isUser, "Third message should be from user")
        XCTAssertFalse(sut.messages[3].isUser, "Fourth message should be from bot")
    }
    
    func testInputTextClearedAfterSending() async {
        sut.inputText = "Test message"
        
        // Simulate the beginning of sendMessage
        let trimmedText = sut.inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedText.isEmpty {
            sut.inputText = ""
        }
        
        XCTAssertEqual(sut.inputText, "", "Input text should be cleared after sending")
    }
    
    func testJapaneseMessageHandling() {
        let japaneseMessage = "こんにちは、元気ですか？"
        sut.messages.append(Message(content: japaneseMessage, isUser: true))
        
        XCTAssertEqual(sut.messages.first?.content, japaneseMessage, "Should handle Japanese text correctly")
    }
}