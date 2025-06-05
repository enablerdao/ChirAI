#!/bin/bash

# 🌸 ChirAI 起動スクリプト

echo "🌸 ChirAI 起動スクリプト"
echo "======================="
echo ""

# Ollama チェック
check_ollama() {
    echo "🔍 Ollama の状態を確認中..."
    
    if ! command -v ollama &> /dev/null; then
        echo "❌ Ollama がインストールされていません"
        echo ""
        echo "📥 Ollama をインストールしますか？ (y/n)"
        read -r response
        if [[ "$response" == "y" ]]; then
            echo "🌐 Ollama をインストール中..."
            curl -fsSL https://ollama.ai/install.sh | sh
        else
            echo "⚠️  Ollama なしでも ChirAI は起動できますが、AI機能は使用できません"
        fi
    else
        echo "✅ Ollama インストール済み"
    fi
    
    # Ollama サービス起動
    if ! pgrep -x "ollama" > /dev/null; then
        echo "🚀 Ollama サービスを起動中..."
        ollama serve &
        sleep 3
    else
        echo "✅ Ollama サービス実行中"
    fi
    
    # モデル確認
    echo ""
    echo "📦 利用可能なモデル:"
    ollama list 2>/dev/null || echo "   (モデルなし)"
    
    # 推奨モデルのダウンロード提案
    if ! ollama list 2>/dev/null | grep -q "qwen2.5:3b"; then
        echo ""
        echo "💡 推奨: 日本語モデル qwen2.5:3b をダウンロードしますか？ (y/n)"
        read -r response
        if [[ "$response" == "y" ]]; then
            echo "📥 qwen2.5:3b をダウンロード中... (約2GB)"
            ollama pull qwen2.5:3b
        fi
    fi
    
    if ! ollama list 2>/dev/null | grep -q "gemma3:1b"; then
        echo ""
        echo "💡 推奨: 英語モデル gemma3:1b をダウンロードしますか？ (y/n)"
        read -r response
        if [[ "$response" == "y" ]]; then
            echo "📥 gemma3:1b をダウンロード中... (約1GB)"
            ollama pull gemma3:1b
        fi
    fi
}

# シミュレーター起動
launch_simulator() {
    echo ""
    echo "📱 iOS シミュレーターを起動中..."
    
    # シミュレーターを開く
    open -a Simulator
    
    # iPhone 15 Pro を起動
    echo "🔄 iPhone 15 Pro を起動中..."
    xcrun simctl boot "iPhone 15 Pro" 2>/dev/null || true
    
    # 起動を待つ
    sleep 5
    
    echo "✅ シミュレーター起動完了"
}

# ChirAI デモ起動
launch_chirai_demo() {
    echo ""
    echo "🌸 ChirAI デモを起動中..."
    
    # HTML デモページ作成
    cat > /tmp/chirai_launch.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChirAI - Launch</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, sans-serif; 
            background: linear-gradient(135deg, #FF6B9D 0%, #FFC0CB 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        .launch-container {
            text-align: center;
            animation: fadeIn 1s ease-in;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .logo {
            font-size: 120px;
            margin-bottom: 20px;
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        h1 {
            font-size: 48px;
            margin-bottom: 10px;
            font-weight: 700;
        }
        .subtitle {
            font-size: 24px;
            opacity: 0.9;
            margin-bottom: 40px;
        }
        .status {
            font-size: 18px;
            opacity: 0.8;
            margin-bottom: 20px;
        }
        .button {
            display: inline-block;
            padding: 16px 32px;
            background: white;
            color: #FF6B9D;
            text-decoration: none;
            border-radius: 30px;
            font-size: 18px;
            font-weight: 600;
            transition: transform 0.2s;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .button:hover {
            transform: scale(1.05);
        }
        .features {
            margin-top: 60px;
            display: flex;
            gap: 40px;
            justify-content: center;
        }
        .feature {
            text-align: center;
        }
        .feature-icon {
            font-size: 40px;
            margin-bottom: 10px;
        }
        .feature-text {
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="launch-container">
        <div class="logo">🌸</div>
        <h1>ChirAI</h1>
        <div class="subtitle">インテリジェントローカルAIチャット</div>
        <div class="status">✅ 起動準備完了</div>
        <a href="/tmp/chirai_demo.html" class="button">ChirAI を開く</a>
        
        <div class="features">
            <div class="feature">
                <div class="feature-icon">🔒</div>
                <div class="feature-text">完全プライバシー</div>
            </div>
            <div class="feature">
                <div class="feature-icon">🤖</div>
                <div class="feature-text">14+ AIモデル</div>
            </div>
            <div class="feature">
                <div class="feature-icon">🇯🇵</div>
                <div class="feature-text">日本語対応</div>
            </div>
        </div>
    </div>
    <script>
        // メインアプリへ自動遷移
        setTimeout(() => {
            window.location.href = 'file:///tmp/chat_ja.html';
        }, 3000);
    </script>
</body>
</html>
EOF

    # メインアプリページ作成（前回のスクリーンショット用HTMLを再利用）
    python3 generate_real_screenshots.py 2>/dev/null || true
    
    # シミュレーターで開く
    xcrun simctl openurl booted file:///tmp/chirai_launch.html
    
    echo "✅ ChirAI デモ起動完了！"
    echo ""
    echo "📱 シミュレーターで ChirAI が表示されます"
    echo "🌸 3秒後に自動的にチャット画面に遷移します"
}

# Xcode プロジェクト情報
show_xcode_info() {
    echo ""
    echo "📂 Xcode プロジェクト情報:"
    echo "   パス: /Users/yuki/wisbee-iOS/ChirAI-Production/ChirAI.xcodeproj"
    echo ""
    echo "🔨 実際のアプリをビルドする場合:"
    echo "   1. cd /Users/yuki/wisbee-iOS/ChirAI-Production"
    echo "   2. open ChirAI.xcodeproj"
    echo "   3. Command + R でビルド・実行"
}

# メインメニュー
show_menu() {
    echo ""
    echo "🌸 ChirAI 起動オプション"
    echo "======================="
    echo "1) 📱 シミュレーターでデモ版を起動（推奨）"
    echo "2) 🔨 Xcode でプロジェクトを開く"
    echo "3) 🧪 E2E テストを実行"
    echo "4) 📸 スクリーンショットを再生成"
    echo "5) 🚀 TestFlight 配布（要設定）"
    echo "6) ❌ 終了"
    echo ""
    echo -n "選択してください (1-6): "
}

# メイン処理
main() {
    clear
    
    # Ollama チェック
    check_ollama
    
    while true; do
        show_menu
        read -r choice
        
        case $choice in
            1)
                launch_simulator
                launch_chirai_demo
                ;;
            2)
                echo "🔨 Xcode でプロジェクトを開いています..."
                cd /Users/yuki/wisbee-iOS/ChirAI-Production
                open ChirAI.xcodeproj
                echo "✅ Xcode が起動しました"
                ;;
            3)
                echo "🧪 E2E テストを実行中..."
                cd /Users/yuki/wisbee-iOS
                swift quick_e2e_test.swift
                ;;
            4)
                echo "📸 スクリーンショットを生成中..."
                cd /Users/yuki/wisbee-iOS
                python3 generate_real_screenshots.py
                ;;
            5)
                echo "🚀 TestFlight 配布を開始..."
                echo "⚠️  事前に SETUP_AUTOMATION.md の設定が必要です"
                cd /Users/yuki/wisbee-iOS
                if command -v fastlane &> /dev/null; then
                    fastlane beta
                else
                    echo "❌ Fastlane がインストールされていません"
                    echo "   gem install fastlane でインストールしてください"
                fi
                ;;
            6)
                echo "👋 ChirAI を終了します"
                break
                ;;
            *)
                echo "❌ 無効な選択です"
                ;;
        esac
        
        echo ""
        echo "続けるには Enter キーを押してください..."
        read -r
    done
}

# 実行
main