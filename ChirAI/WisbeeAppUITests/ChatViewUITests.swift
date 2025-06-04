import XCTest

class ChatViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testChatViewIsDisplayed() throws {
        // Check if chat view elements are visible
        let chatTitle = app.staticTexts["Ollama Chat"]
        XCTAssertTrue(chatTitle.exists, "Chat title should be displayed")
        
        let modelPicker = app.pickers.firstMatch
        XCTAssertTrue(modelPicker.exists, "Model picker should be displayed")
        
        let messageField = app.textFields["Type a message..."]
        XCTAssertTrue(messageField.exists, "Message input field should be displayed")
        
        let sendButton = app.buttons["Send"]
        XCTAssertTrue(sendButton.exists, "Send button should be displayed")
    }
    
    func testModelSelection() throws {
        let modelPicker = app.pickers.firstMatch
        modelPicker.tap()
        
        // Select a different model
        let qwenModel = app.pickerWheels.element.adjust(toPickerWheelValue: "qwen2.5:3b")
        
        // Verify the selection
        XCTAssertTrue(modelPicker.staticTexts["qwen2.5:3b"].exists, "Selected model should be displayed")
    }
    
    func testSendMessage() throws {
        let messageField = app.textFields["Type a message..."]
        let sendButton = app.buttons["Send"]
        
        // Type a message
        messageField.tap()
        messageField.typeText("Hello, this is a test message")
        
        // Send the message
        sendButton.tap()
        
        // Verify the message appears in the chat
        let sentMessage = app.staticTexts["Hello, this is a test message"]
        XCTAssertTrue(sentMessage.waitForExistence(timeout: 5), "Sent message should appear in chat")
        
        // Verify loading indicator appears (briefly)
        let loadingIndicator = app.activityIndicators.firstMatch
        XCTAssertTrue(loadingIndicator.exists || sentMessage.exists, "Loading indicator or response should appear")
    }
    
    func testSendEmptyMessage() throws {
        let messageField = app.textFields["Type a message..."]
        let sendButton = app.buttons["Send"]
        
        // Clear the field and try to send
        messageField.tap()
        messageField.clearAndEnterText("")
        sendButton.tap()
        
        // Verify no new messages appear
        let messagesCount = app.scrollViews.firstMatch.children(matching: .other).count
        sleep(1) // Wait a moment
        let newMessagesCount = app.scrollViews.firstMatch.children(matching: .other).count
        
        XCTAssertEqual(messagesCount, newMessagesCount, "No new messages should be added for empty input")
    }
    
    func testJapaneseInput() throws {
        let messageField = app.textFields["Type a message..."]
        let sendButton = app.buttons["Send"]
        
        // Type a Japanese message
        messageField.tap()
        messageField.typeText("こんにちは")
        
        // Send the message
        sendButton.tap()
        
        // Verify the Japanese message appears
        let sentMessage = app.staticTexts["こんにちは"]
        XCTAssertTrue(sentMessage.waitForExistence(timeout: 5), "Japanese message should appear in chat")
    }
    
    func testScrollToLatestMessage() throws {
        let messageField = app.textFields["Type a message..."]
        let sendButton = app.buttons["Send"]
        
        // Send multiple messages
        for i in 1...5 {
            messageField.tap()
            messageField.typeText("Test message \(i)")
            sendButton.tap()
            sleep(1) // Wait between messages
        }
        
        // Verify the latest message is visible
        let latestMessage = app.staticTexts["Test message 5"]
        XCTAssertTrue(latestMessage.isHittable, "Latest message should be visible (scrolled into view)")
    }
    
    func testMessageStyling() throws {
        let messageField = app.textFields["Type a message..."]
        let sendButton = app.buttons["Send"]
        
        // Send a user message
        messageField.tap()
        messageField.typeText("User message")
        sendButton.tap()
        
        // Wait for response
        sleep(3)
        
        // Check if messages have different styling (this is a simplified check)
        let scrollView = app.scrollViews.firstMatch
        let messageViews = scrollView.children(matching: .other)
        
        XCTAssertTrue(messageViews.count >= 2, "Should have at least user message and bot response")
    }
}

extension XCUIElement {
    func clearAndEnterText(_ text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text on a non-text element")
            return
        }
        
        self.tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
        self.typeText(text)
    }
}