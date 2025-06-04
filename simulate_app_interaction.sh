#!/bin/bash

echo "🤖 Simulating app interactions for screenshots..."

# Function to send chat message via API
send_message() {
    local message="$1"
    local model="${2:-gemma3:1b}"
    
    curl -s -X POST http://localhost:11434/v1/chat/completions \
        -H "Content-Type: application/json" \
        -d "{
            \"model\": \"$model\",
            \"messages\": [{\"role\": \"user\", \"content\": \"$message\"}],
            \"stream\": false
        }" | jq -r '.choices[0].message.content' || echo "Failed to send message"
}

# Take screenshots with different app states
echo "📸 Taking screenshots..."

# 1. Empty chat state
xcrun simctl io "iPhone 15" screenshot /Users/yuki/wisbee-iOS/screenshots/chat_empty.png
echo "✅ Empty chat screenshot"

# 2. Send English message
echo "Sending English message..."
send_message "Hello! Can you explain what Wisbee is?" "gemma3:1b"
sleep 3

xcrun simctl io "iPhone 15" screenshot /Users/yuki/wisbee-iOS/screenshots/chat_english.png
echo "✅ English conversation screenshot"

# 3. Send Japanese message
echo "Sending Japanese message..."
send_message "こんにちは！今日はいい天気ですね。" "qwen2.5:3b"
sleep 3

xcrun simctl io "iPhone 15" screenshot /Users/yuki/wisbee-iOS/screenshots/chat_japanese.png
echo "✅ Japanese conversation screenshot"

# 4. Dark theme with gradient
xcrun simctl io "iPhone 15" screenshot /Users/yuki/wisbee-iOS/screenshots/dark_theme.png
echo "✅ Dark theme screenshot"

# 5. Multiple messages
echo "Creating conversation flow..."
send_message "What programming languages do you support?" "gemma3:1b"
sleep 2
send_message "Can you write a simple Python hello world?" "gemma3:1b"
sleep 2

xcrun simctl io "iPhone 15" screenshot /Users/yuki/wisbee-iOS/screenshots/conversation_flow.png
echo "✅ Conversation flow screenshot"

# 6. Model switching demo
echo "Demonstrating model switching..."
send_message "Switching to Japanese model..." "gemma3:1b"
sleep 1
send_message "日本語でプログラミングについて教えてください。" "qwen2.5:3b"
sleep 3

xcrun simctl io "iPhone 15" screenshot /Users/yuki/wisbee-iOS/screenshots/model_switching.png
echo "✅ Model switching screenshot"

echo ""
echo "📱 Screenshots saved to /Users/yuki/wisbee-iOS/screenshots/"
echo "Total screenshots: $(ls /Users/yuki/wisbee-iOS/screenshots/*.png | wc -l)"
ls -la /Users/yuki/wisbee-iOS/screenshots/*.png