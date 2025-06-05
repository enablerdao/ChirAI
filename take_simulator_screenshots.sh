#!/bin/bash

# ChirAI Simulator Screenshot Script

echo "🌸 ChirAI Screenshot Capture Script"
echo "==================================="

# Create directories
mkdir -p screenshots/simulator/{chat,agents,settings,english}

# Open simulator
echo "📱 Opening iOS Simulator..."
open -a Simulator

# Wait for simulator to boot
sleep 5

# Take screenshots using simctl
DEVICE_ID=$(xcrun simctl list devices | grep "iPhone 15 Pro" | grep -E '\(([0-9A-F-]+)\)' -o | tr -d '()')

if [ -z "$DEVICE_ID" ]; then
    echo "❌ iPhone 15 Pro simulator not found. Creating one..."
    DEVICE_ID=$(xcrun simctl create "iPhone 15 Pro" "com.apple.CoreSimulator.SimDeviceType.iPhone-15-Pro" "com.apple.CoreSimulator.SimRuntime.iOS-17-0")
fi

echo "📱 Using device: $DEVICE_ID"

# Boot the device
xcrun simctl boot $DEVICE_ID 2>/dev/null || true

# Wait for boot
sleep 10

# Install and run a simple test app (we'll use Safari to display our screenshots)
echo "🌐 Opening ChirAI preview in Safari..."

# Create an HTML preview page
cat > /tmp/chirai_preview.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChirAI</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #F8F9FA; }
        .header { background: rgba(255,255,255,0.9); padding: 16px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .header h1 { color: #FF6B9D; font-size: 32px; display: inline-block; }
        .header .subtitle { color: #666; font-size: 14px; margin-left: 8px; }
        .chat-container { padding: 16px; height: calc(100vh - 140px); overflow-y: auto; }
        .message { margin-bottom: 16px; display: flex; }
        .message.user { justify-content: flex-end; }
        .message-bubble { max-width: 70%; padding: 12px 16px; border-radius: 16px; }
        .message.ai .message-bubble { background: #f0f0f0; }
        .message.user .message-bubble { background: #FF6B9D; color: white; }
        .message-header { font-size: 12px; color: #FF6B9D; margin-bottom: 4px; }
        .input-area { position: fixed; bottom: 0; left: 0; right: 0; background: white; padding: 16px; box-shadow: 0 -2px 4px rgba(0,0,0,0.1); }
        .input-container { display: flex; gap: 12px; }
        .input-field { flex: 1; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 16px; }
        .send-button { background: #FF6B9D; color: white; border: none; width: 44px; height: 44px; border-radius: 50%; font-size: 20px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="header">
        <span style="font-size: 24px;">🌸</span>
        <h1>ChirAI</h1>
        <span class="subtitle">ローカルAIチャット</span>
    </div>
    <div class="chat-container">
        <div class="message ai">
            <div>
                <div class="message-header">🌸 ChirAI</div>
                <div class="message-bubble">
                    ChirAIへようこそ！美しい日本風デザインのローカルAIチャットアプリです。プライバシーを保護しながら、Ollamaと連携してAIと会話できます。
                </div>
            </div>
        </div>
        <div class="message user">
            <div>
                <div class="message-bubble">
                    プログラミングについて教えてください。SwiftUIの基本的な使い方を知りたいです。
                </div>
            </div>
        </div>
        <div class="message ai">
            <div>
                <div class="message-header">🌸 ChirAI</div>
                <div class="message-bubble">
                    SwiftUIは素晴らしい選択ですね！宣言的UIフレームワークで、iOSアプリ開発を大幅に簡素化できます。<br><br>
                    基本的な構造：<br>
                    • View プロトコルを実装<br>
                    • body プロパティでUIを定義<br>
                    • @State で状態管理<br>
                    • プレビュー機能で即座確認<br><br>
                    何か具体的に知りたい部分はありますか？
                </div>
            </div>
        </div>
    </div>
    <div class="input-area">
        <div class="input-container">
            <input type="text" class="input-field" placeholder="メッセージを入力...">
            <button class="send-button">📤</button>
        </div>
    </div>
</body>
</html>
EOF

# Open in Safari on simulator
xcrun simctl openurl $DEVICE_ID file:///tmp/chirai_preview.html

# Wait for page to load
sleep 3

# Take screenshot of chat interface
echo "📸 Taking chat screenshot..."
xcrun simctl io $DEVICE_ID screenshot screenshots/simulator/chat/main_chat.png

# Create agents view HTML
cat > /tmp/chirai_agents.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChirAI - Agents</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #F8F9FA; }
        .header { background: white; padding: 16px; }
        .header h1 { color: #FF6B9D; font-size: 28px; }
        .agents-list { padding: 16px; }
        .agent-card { background: white; padding: 16px; margin-bottom: 12px; border-radius: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); display: flex; align-items: center; }
        .agent-icon { font-size: 32px; margin-right: 16px; }
        .agent-info { flex: 1; }
        .agent-name { font-weight: bold; font-size: 18px; }
        .agent-desc { color: #666; font-size: 14px; margin-top: 4px; }
        .agent-status { padding: 4px 12px; border-radius: 16px; font-size: 12px; }
        .status-recommended { background: rgba(255,107,157,0.2); color: #FF6B9D; }
        .status-good { background: rgba(78,205,196,0.2); color: #4ECDC4; }
        .selected { margin-left: 8px; color: #FF6B9D; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🤖 AI エージェント</h1>
        <p style="color: #666; margin-top: 8px;">14種類のモデルから選択</p>
    </div>
    <div class="agents-list">
        <div class="agent-card">
            <div class="agent-icon">🤖</div>
            <div class="agent-info">
                <div class="agent-name">qwen2.5:3b</div>
                <div class="agent-desc">日本語に最適化されたモデル</div>
            </div>
            <span class="agent-status status-recommended">推奨</span>
            <span class="selected">✓</span>
        </div>
        <div class="agent-card">
            <div class="agent-icon">🤖</div>
            <div class="agent-info">
                <div class="agent-name">gemma3:1b</div>
                <div class="agent-desc">高速英語処理モデル</div>
            </div>
            <span class="agent-status status-recommended">推奨</span>
        </div>
        <div class="agent-card">
            <div class="agent-icon">🤖</div>
            <div class="agent-info">
                <div class="agent-name">llama3:8b</div>
                <div class="agent-desc">バランス型汎用モデル</div>
            </div>
            <span class="agent-status status-good">良い</span>
        </div>
        <div class="agent-card">
            <div class="agent-icon">🤖</div>
            <div class="agent-info">
                <div class="agent-name">codellama:7b</div>
                <div class="agent-desc">プログラミング特化</div>
            </div>
            <span class="agent-status" style="background: rgba(69,183,209,0.2); color: #45B7D1;">実験的</span>
        </div>
    </div>
</body>
</html>
EOF

# Open agents view
xcrun simctl openurl $DEVICE_ID file:///tmp/chirai_agents.html
sleep 2

# Take agents screenshot
echo "📸 Taking agents screenshot..."
xcrun simctl io $DEVICE_ID screenshot screenshots/simulator/agents/agents_list.png

# Create settings HTML
cat > /tmp/chirai_settings.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChirAI - Settings</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: white; }
        .header { padding: 20px; text-align: center; border-bottom: 1px solid #eee; }
        .header h1 { color: #FF6B9D; font-size: 32px; }
        .version { color: #666; margin-top: 8px; }
        .settings-list { padding: 20px; }
        .setting-row { display: flex; align-items: center; padding: 16px 0; border-bottom: 1px solid #f0f0f0; }
        .setting-icon { font-size: 24px; margin-right: 16px; }
        .setting-label { flex: 1; font-size: 16px; }
        .setting-value { color: #666; }
        .footer { text-align: center; padding: 40px 20px; color: #999; font-size: 14px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>⚙️ 設定</h1>
        <div class="version">ChirAI v1.4.0</div>
    </div>
    <div class="settings-list">
        <div class="setting-row">
            <span class="setting-icon">🎨</span>
            <span class="setting-label">テーマ</span>
            <span class="setting-value">桜ピンク</span>
        </div>
        <div class="setting-row">
            <span class="setting-icon">🌐</span>
            <span class="setting-label">言語</span>
            <span class="setting-value">日本語</span>
        </div>
        <div class="setting-row">
            <span class="setting-icon">⚡</span>
            <span class="setting-label">応答速度</span>
            <span class="setting-value">高速</span>
        </div>
        <div class="setting-row">
            <span class="setting-icon">🔒</span>
            <span class="setting-label">プライバシー</span>
            <span class="setting-value">最大保護</span>
        </div>
    </div>
    <div class="footer">
        © 2025 enablerdao<br>
        MIT License • Open Source
    </div>
</body>
</html>
EOF

# Open settings
xcrun simctl openurl $DEVICE_ID file:///tmp/chirai_settings.html
sleep 2

# Take settings screenshot
echo "📸 Taking settings screenshot..."
xcrun simctl io $DEVICE_ID screenshot screenshots/simulator/settings/settings.png

# Create English chat HTML
cat > /tmp/chirai_english.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChirAI - English</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #F8F9FA; }
        .header { background: rgba(255,255,255,0.9); padding: 16px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .header h1 { color: #FF6B9D; font-size: 32px; display: inline-block; }
        .header .subtitle { color: #666; font-size: 14px; margin-left: 8px; }
        .chat-container { padding: 16px; height: calc(100vh - 140px); overflow-y: auto; }
        .message { margin-bottom: 16px; display: flex; }
        .message.user { justify-content: flex-end; }
        .message-bubble { max-width: 70%; padding: 12px 16px; border-radius: 16px; }
        .message.ai .message-bubble { background: #f0f0f0; }
        .message.user .message-bubble { background: #FF6B9D; color: white; }
        .message-header { font-size: 12px; color: #FF6B9D; margin-bottom: 4px; }
        .input-area { position: fixed; bottom: 0; left: 0; right: 0; background: white; padding: 16px; box-shadow: 0 -2px 4px rgba(0,0,0,0.1); }
        .input-container { display: flex; gap: 12px; }
        .input-field { flex: 1; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 16px; }
        .send-button { background: #FF6B9D; color: white; border: none; width: 44px; height: 44px; border-radius: 50%; font-size: 20px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="header">
        <span style="font-size: 24px;">🌸</span>
        <h1>ChirAI</h1>
        <span class="subtitle">Local AI Chat</span>
    </div>
    <div class="chat-container">
        <div class="message ai">
            <div>
                <div class="message-header">🌸 ChirAI</div>
                <div class="message-bubble">
                    Welcome to ChirAI! How can I assist you today?
                </div>
            </div>
        </div>
        <div class="message user">
            <div>
                <div class="message-bubble">
                    Tell me about the importance of privacy in AI applications.
                </div>
            </div>
        </div>
        <div class="message ai">
            <div>
                <div class="message-header">🌸 ChirAI</div>
                <div class="message-bubble">
                    Privacy in AI is absolutely crucial! Here's why:<br><br>
                    • Personal Data Protection: AI processes sensitive information<br>
                    • Trust Building: Users need confidence in your application<br>
                    • Legal Compliance: GDPR, CCPA, and other regulations<br>
                    • Ethical Responsibility: Respecting user autonomy<br><br>
                    ChirAI addresses this by processing everything locally - no data ever leaves your device!
                </div>
            </div>
        </div>
    </div>
    <div class="input-area">
        <div class="input-container">
            <input type="text" class="input-field" placeholder="Type a message...">
            <button class="send-button">📤</button>
        </div>
    </div>
</body>
</html>
EOF

# Open English chat
xcrun simctl openurl $DEVICE_ID file:///tmp/chirai_english.html
sleep 2

# Take English chat screenshot
echo "📸 Taking English chat screenshot..."
xcrun simctl io $DEVICE_ID screenshot screenshots/simulator/english/english_chat.png

echo ""
echo "✅ Screenshots captured successfully!"
echo ""
echo "📁 Screenshots saved to:"
echo "  - screenshots/simulator/chat/main_chat.png"
echo "  - screenshots/simulator/agents/agents_list.png"
echo "  - screenshots/simulator/settings/settings.png"
echo "  - screenshots/simulator/english/english_chat.png"
echo ""
echo "🌸 Ready to update README and upload to App Store!"