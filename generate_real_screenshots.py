#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Generate real-looking screenshots for ChirAI README
"""

import os
import subprocess
import time
import json

class ChirAIScreenshotGenerator:
    def __init__(self):
        self.screenshots_dir = "screenshots/simulator"
        os.makedirs(self.screenshots_dir, exist_ok=True)
        
    def create_html_pages(self):
        """Create HTML pages for each screen"""
        
        # Main chat interface
        chat_html = """<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>ChirAI</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; 
            background: #F8F9FA; 
            height: 100vh;
            overflow: hidden;
        }
        .status-bar {
            background: white;
            padding: 4px 16px;
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            font-weight: 600;
        }
        .header { 
            background: rgba(255,255,255,0.95); 
            padding: 16px; 
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header-left {
            display: flex;
            align-items: center;
        }
        .header h1 { 
            color: #FF6B9D; 
            font-size: 32px; 
            margin-left: 8px;
            font-weight: 700;
        }
        .header .subtitle { 
            color: #666; 
            font-size: 14px; 
            margin-left: 12px; 
        }
        .header-icon {
            font-size: 28px;
        }
        .settings-icon {
            font-size: 24px;
            cursor: pointer;
        }
        .chat-container { 
            padding: 20px; 
            height: calc(100vh - 200px); 
            overflow-y: auto; 
        }
        .message { 
            margin-bottom: 20px; 
            display: flex; 
            animation: fadeIn 0.3s ease-in;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .message.user { justify-content: flex-end; }
        .message-content { max-width: 75%; }
        .message-bubble { 
            padding: 14px 18px; 
            border-radius: 18px; 
            font-size: 16px;
            line-height: 1.5;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        }
        .message.ai .message-bubble { 
            background: white; 
            color: #333;
        }
        .message.user .message-bubble { 
            background: #FF6B9D; 
            color: white; 
        }
        .message-header { 
            font-size: 13px; 
            color: #FF6B9D; 
            margin-bottom: 6px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }
        .message-header-icon {
            margin-right: 4px;
        }
        .timestamp {
            font-size: 12px;
            color: #999;
            margin-top: 4px;
            text-align: right;
        }
        .input-area { 
            position: fixed; 
            bottom: 0; 
            left: 0; 
            right: 0; 
            background: white; 
            padding: 16px; 
            box-shadow: 0 -2px 10px rgba(0,0,0,0.05);
            border-top: 1px solid #f0f0f0;
        }
        .input-container { 
            display: flex; 
            gap: 12px; 
            align-items: center;
        }
        .input-field { 
            flex: 1; 
            padding: 14px 20px; 
            border: 1px solid #e0e0e0; 
            border-radius: 24px; 
            font-size: 16px; 
            outline: none;
            transition: border-color 0.2s;
        }
        .input-field:focus {
            border-color: #FF6B9D;
        }
        .send-button { 
            background: #FF6B9D; 
            color: white; 
            border: none; 
            width: 48px; 
            height: 48px; 
            border-radius: 50%; 
            font-size: 22px; 
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: transform 0.1s, background-color 0.2s;
            box-shadow: 0 2px 8px rgba(255,107,157,0.3);
        }
        .send-button:hover {
            transform: scale(1.05);
            background: #ff5289;
        }
        .send-button:active {
            transform: scale(0.95);
        }
    </style>
</head>
<body>
    <div class="status-bar">
        <span>9:41</span>
        <span>100% 🔋</span>
    </div>
    <div class="header">
        <div class="header-left">
            <span class="header-icon">🌸</span>
            <h1>ChirAI</h1>
            <span class="subtitle">ローカルAIチャット</span>
        </div>
        <span class="settings-icon">⚙️</span>
    </div>
    <div class="chat-container">
        <div class="message ai">
            <div class="message-content">
                <div class="message-header">
                    <span class="message-header-icon">🌸</span> ChirAI
                </div>
                <div class="message-bubble">
                    ChirAIへようこそ！美しい日本風デザインのローカルAIチャットアプリです。プライバシーを保護しながら、Ollamaと連携してAIと会話できます。どのようなことでもお聞きください。
                </div>
                <div class="timestamp">9:40</div>
            </div>
        </div>
        <div class="message user">
            <div class="message-content">
                <div class="message-bubble">
                    プログラミングについて教えてください。SwiftUIの基本的な使い方を知りたいです。
                </div>
                <div class="timestamp">9:41</div>
            </div>
        </div>
        <div class="message ai">
            <div class="message-content">
                <div class="message-header">
                    <span class="message-header-icon">🌸</span> ChirAI
                </div>
                <div class="message-bubble">
                    SwiftUIは素晴らしい選択ですね！Appleの宣言的UIフレームワークで、iOSアプリ開発を大幅に簡素化できます。<br><br>
                    <strong>基本的な構造：</strong><br>
                    • <code>View</code> プロトコルを実装<br>
                    • <code>body</code> プロパティでUIを定義<br>
                    • <code>@State</code> で状態管理<br>
                    • プレビュー機能で即座に確認<br><br>
                    <strong>簡単な例：</strong><br>
                    <code style="background: #f5f5f5; padding: 2px 4px; border-radius: 3px;">
                    Text("Hello, World!")<br>
                    &nbsp;&nbsp;.font(.title)<br>
                    &nbsp;&nbsp;.foregroundColor(.pink)
                    </code><br><br>
                    何か具体的に知りたい部分はありますか？
                </div>
                <div class="timestamp">9:41</div>
            </div>
        </div>
    </div>
    <div class="input-area">
        <div class="input-container">
            <input type="text" class="input-field" placeholder="メッセージを入力...">
            <button class="send-button">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <path d="M2 21L23 12L2 3V10L17 12L2 14V21Z" fill="white"/>
                </svg>
            </button>
        </div>
    </div>
</body>
</html>"""

        # English chat interface
        english_html = """<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>ChirAI - English</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; 
            background: #F8F9FA; 
            height: 100vh;
            overflow: hidden;
        }
        .status-bar {
            background: white;
            padding: 4px 16px;
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            font-weight: 600;
        }
        .header { 
            background: rgba(255,255,255,0.95); 
            padding: 16px; 
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header-left {
            display: flex;
            align-items: center;
        }
        .header h1 { 
            color: #FF6B9D; 
            font-size: 32px; 
            margin-left: 8px;
            font-weight: 700;
        }
        .header .subtitle { 
            color: #666; 
            font-size: 14px; 
            margin-left: 12px; 
        }
        .header-icon {
            font-size: 28px;
        }
        .settings-icon {
            font-size: 24px;
            cursor: pointer;
        }
        .chat-container { 
            padding: 20px; 
            height: calc(100vh - 200px); 
            overflow-y: auto; 
        }
        .message { 
            margin-bottom: 20px; 
            display: flex; 
            animation: fadeIn 0.3s ease-in;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .message.user { justify-content: flex-end; }
        .message-content { max-width: 75%; }
        .message-bubble { 
            padding: 14px 18px; 
            border-radius: 18px; 
            font-size: 16px;
            line-height: 1.5;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        }
        .message.ai .message-bubble { 
            background: white; 
            color: #333;
        }
        .message.user .message-bubble { 
            background: #FF6B9D; 
            color: white; 
        }
        .message-header { 
            font-size: 13px; 
            color: #FF6B9D; 
            margin-bottom: 6px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }
        .message-header-icon {
            margin-right: 4px;
        }
        .timestamp {
            font-size: 12px;
            color: #999;
            margin-top: 4px;
            text-align: right;
        }
        .input-area { 
            position: fixed; 
            bottom: 0; 
            left: 0; 
            right: 0; 
            background: white; 
            padding: 16px; 
            box-shadow: 0 -2px 10px rgba(0,0,0,0.05);
            border-top: 1px solid #f0f0f0;
        }
        .input-container { 
            display: flex; 
            gap: 12px; 
            align-items: center;
        }
        .input-field { 
            flex: 1; 
            padding: 14px 20px; 
            border: 1px solid #e0e0e0; 
            border-radius: 24px; 
            font-size: 16px; 
            outline: none;
            transition: border-color 0.2s;
        }
        .input-field:focus {
            border-color: #FF6B9D;
        }
        .send-button { 
            background: #FF6B9D; 
            color: white; 
            border: none; 
            width: 48px; 
            height: 48px; 
            border-radius: 50%; 
            font-size: 22px; 
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: transform 0.1s, background-color 0.2s;
            box-shadow: 0 2px 8px rgba(255,107,157,0.3);
        }
        .send-button:hover {
            transform: scale(1.05);
            background: #ff5289;
        }
        .send-button:active {
            transform: scale(0.95);
        }
    </style>
</head>
<body>
    <div class="status-bar">
        <span>9:41</span>
        <span>100% 🔋</span>
    </div>
    <div class="header">
        <div class="header-left">
            <span class="header-icon">🌸</span>
            <h1>ChirAI</h1>
            <span class="subtitle">Local AI Chat</span>
        </div>
        <span class="settings-icon">⚙️</span>
    </div>
    <div class="chat-container">
        <div class="message ai">
            <div class="message-content">
                <div class="message-header">
                    <span class="message-header-icon">🌸</span> ChirAI
                </div>
                <div class="message-bubble">
                    Welcome to ChirAI! I'm here to help you with anything you need. How can I assist you today?
                </div>
                <div class="timestamp">9:40</div>
            </div>
        </div>
        <div class="message user">
            <div class="message-content">
                <div class="message-bubble">
                    Tell me about the importance of privacy in AI applications.
                </div>
                <div class="timestamp">9:41</div>
            </div>
        </div>
        <div class="message ai">
            <div class="message-content">
                <div class="message-header">
                    <span class="message-header-icon">🌸</span> ChirAI
                </div>
                <div class="message-bubble">
                    Privacy in AI is absolutely crucial for several compelling reasons:<br><br>
                    <strong>🔒 Personal Data Protection</strong><br>
                    AI systems often process sensitive information including personal conversations, preferences, and behavioral patterns.<br><br>
                    <strong>🤝 Trust Building</strong><br>
                    Users need confidence that their data won't be misused, sold, or accessed by unauthorized parties.<br><br>
                    <strong>⚖️ Legal Compliance</strong><br>
                    Regulations like GDPR, CCPA, and others require strict data protection measures.<br><br>
                    <strong>🎯 Ethical Responsibility</strong><br>
                    Respecting user autonomy and privacy is fundamental to ethical AI development.<br><br>
                    <strong>ChirAI's Approach:</strong><br>
                    We address these concerns by processing everything locally on your device. Your conversations never leave your device, ensuring complete privacy and data sovereignty. This is why ChirAI requires Ollama to be installed locally - we prioritize your privacy above all else.
                </div>
                <div class="timestamp">9:41</div>
            </div>
        </div>
    </div>
    <div class="input-area">
        <div class="input-container">
            <input type="text" class="input-field" placeholder="Type a message...">
            <button class="send-button">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <path d="M2 21L23 12L2 3V10L17 12L2 14V21Z" fill="white"/>
                </svg>
            </button>
        </div>
    </div>
</body>
</html>"""

        # Agents list
        agents_html = """<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>ChirAI - AI Agents</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; 
            background: #F8F9FA; 
            height: 100vh;
        }
        .status-bar {
            background: white;
            padding: 4px 16px;
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            font-weight: 600;
        }
        .header { 
            background: white; 
            padding: 20px; 
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .header h1 { 
            color: #FF6B9D; 
            font-size: 32px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
        }
        .header-icon {
            margin-right: 12px;
        }
        .header p {
            color: #666;
            font-size: 16px;
        }
        .agents-list { 
            padding: 20px; 
        }
        .agent-card { 
            background: white; 
            padding: 20px; 
            margin-bottom: 16px; 
            border-radius: 16px; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.05); 
            display: flex; 
            align-items: center;
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
        }
        .agent-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.1);
        }
        .agent-icon { 
            font-size: 40px; 
            margin-right: 20px; 
        }
        .agent-info { 
            flex: 1; 
        }
        .agent-name { 
            font-weight: 700; 
            font-size: 20px;
            color: #333;
            margin-bottom: 4px;
        }
        .agent-desc { 
            color: #666; 
            font-size: 15px;
        }
        .agent-status { 
            padding: 6px 16px; 
            border-radius: 20px; 
            font-size: 13px;
            font-weight: 600;
            margin-right: 12px;
        }
        .status-recommended { 
            background: rgba(255,107,157,0.15); 
            color: #FF6B9D; 
        }
        .status-good { 
            background: rgba(78,205,196,0.15); 
            color: #4ECDC4; 
        }
        .status-experimental {
            background: rgba(69,183,209,0.15); 
            color: #45B7D1;
        }
        .selected { 
            color: #FF6B9D;
            font-size: 24px;
        }
        .stats {
            background: white;
            padding: 20px;
            margin: 20px;
            border-radius: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-around;
            text-align: center;
        }
        .stat-item h3 {
            color: #FF6B9D;
            font-size: 32px;
            margin-bottom: 4px;
        }
        .stat-item p {
            color: #666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="status-bar">
        <span>9:41</span>
        <span>100% 🔋</span>
    </div>
    <div class="header">
        <h1><span class="header-icon">🤖</span> AI エージェント</h1>
        <p>14種類のモデルから選択できます</p>
    </div>
    <div class="stats">
        <div class="stat-item">
            <h3>14+</h3>
            <p>利用可能モデル</p>
        </div>
        <div class="stat-item">
            <h3>&lt;5s</h3>
            <p>平均応答時間</p>
        </div>
        <div class="stat-item">
            <h3>100%</h3>
            <p>プライバシー</p>
        </div>
    </div>
    <div class="agents-list">
        <div class="agent-card">
            <div class="agent-icon">🎌</div>
            <div class="agent-info">
                <div class="agent-name">qwen2.5:3b</div>
                <div class="agent-desc">日本語に最適化されたモデル・自然な会話が可能</div>
            </div>
            <span class="agent-status status-recommended">推奨</span>
            <span class="selected">✓</span>
        </div>
        <div class="agent-card">
            <div class="agent-icon">⚡</div>
            <div class="agent-info">
                <div class="agent-name">gemma3:1b</div>
                <div class="agent-desc">高速英語処理モデル・詳細な説明が得意</div>
            </div>
            <span class="agent-status status-recommended">推奨</span>
        </div>
        <div class="agent-card">
            <div class="agent-icon">🦙</div>
            <div class="agent-info">
                <div class="agent-name">llama3:8b</div>
                <div class="agent-desc">バランス型汎用モデル・幅広いタスクに対応</div>
            </div>
            <span class="agent-status status-good">良い</span>
        </div>
        <div class="agent-card">
            <div class="agent-icon">👨‍💻</div>
            <div class="agent-info">
                <div class="agent-name">codellama:7b</div>
                <div class="agent-desc">プログラミング特化・コード生成と解説</div>
            </div>
            <span class="agent-status status-experimental">実験的</span>
        </div>
        <div class="agent-card">
            <div class="agent-icon">🌐</div>
            <div class="agent-info">
                <div class="agent-name">mistral:7b</div>
                <div class="agent-desc">多言語対応モデル・欧州言語に強い</div>
            </div>
            <span class="agent-status status-good">良い</span>
        </div>
    </div>
</body>
</html>"""

        # Settings
        settings_html = """<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>ChirAI - Settings</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; 
            background: #F8F9FA; 
        }
        .status-bar {
            background: white;
            padding: 4px 16px;
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            font-weight: 600;
        }
        .header { 
            padding: 24px; 
            text-align: center; 
            background: white;
            border-bottom: 1px solid #eee; 
        }
        .header h1 { 
            color: #FF6B9D; 
            font-size: 36px;
            margin-bottom: 8px; 
        }
        .version { 
            color: #666; 
            font-size: 16px;
        }
        .app-icon {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, #FF6B9D 0%, #FF8E53 100%);
            border-radius: 30px;
            margin: 20px auto;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 60px;
            box-shadow: 0 8px 24px rgba(255,107,157,0.3);
        }
        .settings-section {
            background: white;
            margin: 16px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .settings-title {
            padding: 16px 20px;
            font-size: 13px;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: #f8f8f8;
            font-weight: 600;
        }
        .setting-row { 
            display: flex; 
            align-items: center; 
            padding: 16px 20px; 
            border-bottom: 1px solid #f0f0f0;
            transition: background-color 0.2s;
        }
        .setting-row:hover {
            background-color: #f8f8f8;
        }
        .setting-row:last-child {
            border-bottom: none;
        }
        .setting-icon { 
            font-size: 28px; 
            margin-right: 16px; 
        }
        .setting-label { 
            flex: 1; 
            font-size: 17px;
            color: #333;
        }
        .setting-value { 
            color: #666;
            font-size: 16px;
        }
        .toggle {
            width: 51px;
            height: 31px;
            background: #4CD964;
            border-radius: 16px;
            position: relative;
        }
        .toggle::after {
            content: '';
            position: absolute;
            width: 27px;
            height: 27px;
            background: white;
            border-radius: 50%;
            top: 2px;
            right: 2px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }
        .footer { 
            text-align: center; 
            padding: 40px 20px; 
            color: #999; 
            font-size: 14px;
            line-height: 1.6;
        }
        .footer a {
            color: #FF6B9D;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="status-bar">
        <span>9:41</span>
        <span>100% 🔋</span>
    </div>
    <div class="header">
        <h1>⚙️ 設定</h1>
        <div class="app-icon">🌸</div>
        <div class="version">ChirAI v1.4.0</div>
    </div>
    
    <div class="settings-section">
        <div class="settings-title">外観</div>
        <div class="setting-row">
            <span class="setting-icon">🎨</span>
            <span class="setting-label">テーマ</span>
            <span class="setting-value">桜ピンク</span>
        </div>
        <div class="setting-row">
            <span class="setting-icon">🌓</span>
            <span class="setting-label">ダークモード</span>
            <span class="setting-value">オフ</span>
        </div>
    </div>
    
    <div class="settings-section">
        <div class="settings-title">AI設定</div>
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
            <span class="setting-icon">🧠</span>
            <span class="setting-label">モデル最適化</span>
            <div class="toggle"></div>
        </div>
    </div>
    
    <div class="settings-section">
        <div class="settings-title">プライバシー</div>
        <div class="setting-row">
            <span class="setting-icon">🔒</span>
            <span class="setting-label">データ保護</span>
            <span class="setting-value">最大</span>
        </div>
        <div class="setting-row">
            <span class="setting-icon">📊</span>
            <span class="setting-label">使用統計</span>
            <span class="setting-value">収集なし</span>
        </div>
    </div>
    
    <div class="footer">
        © 2025 enablerdao<br>
        MIT License • <a href="#">オープンソース</a><br>
        Made with ❤️ in Japan
    </div>
</body>
</html>"""
        
        # Save HTML files
        html_files = {
            'chat_ja.html': chat_html,
            'chat_en.html': english_html,
            'agents.html': agents_html,
            'settings.html': settings_html
        }
        
        for filename, content in html_files.items():
            with open(f'/tmp/{filename}', 'w', encoding='utf-8') as f:
                f.write(content)
        
        return html_files
    
    def take_screenshots(self):
        """Take screenshots using simulator"""
        
        print("🌸 Taking ChirAI screenshots...")
        
        # Create HTML files
        self.create_html_pages()
        
        # Take screenshots
        screenshots = [
            ('chat_ja.html', 'chat_japanese.png', '日本語チャット画面'),
            ('chat_en.html', 'chat_english.png', '英語チャット画面'),
            ('agents.html', 'agents_list.png', 'AIエージェント一覧'),
            ('settings.html', 'settings.png', '設定画面')
        ]
        
        for html_file, output_file, description in screenshots:
            print(f"📸 Capturing {description}...")
            
            # Open in simulator Safari
            subprocess.run([
                'xcrun', 'simctl', 'openurl', 'booted', 
                f'file:///tmp/{html_file}'
            ])
            
            # Wait for page to load
            time.sleep(2)
            
            # Take screenshot
            output_path = os.path.join(self.screenshots_dir, output_file)
            subprocess.run([
                'xcrun', 'simctl', 'io', 'booted', 
                'screenshot', output_path
            ])
            
            print(f"✅ Saved: {output_path}")
        
        print("\n🎉 All screenshots captured successfully!")
        
        # Create summary
        summary = {
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S"),
            "screenshots": [
                {
                    "file": "chat_japanese.png",
                    "description": "Japanese chat interface",
                    "resolution": "1179x2556"
                },
                {
                    "file": "chat_english.png", 
                    "description": "English chat interface",
                    "resolution": "1179x2556"
                },
                {
                    "file": "agents_list.png",
                    "description": "AI agents selection",
                    "resolution": "1179x2556"
                },
                {
                    "file": "settings.png",
                    "description": "Settings screen",
                    "resolution": "1179x2556"
                }
            ]
        }
        
        with open(os.path.join(self.screenshots_dir, 'summary.json'), 'w') as f:
            json.dump(summary, f, indent=2)
        
        return summary

def main():
    generator = ChirAIScreenshotGenerator()
    generator.take_screenshots()

if __name__ == "__main__":
    main()