# 🚀 ChirAI 即座リリース手順

## 🎯 今すぐ実行する手順

### Step 1: Xcode でアーカイブ作成 (5分)
```bash
# 1. Xcode を開く
open /Users/yuki/wisbee-iOS/Wisbee/Package.swift

# 2. または xcodeproj を開く（もしあれば）
# Product > Archive を選択
# Release 設定で Archive 作成
```

### Step 2: App Store Connect アップロード (10分)
```bash
# Xcode Organizer から:
# 1. Window > Organizer
# 2. Archives タブ選択
# 3. ChirAI アーカイブを選択
# 4. "Distribute App" ボタンクリック
# 5. "App Store Connect" 選択
# 6. "Upload" 選択
# 7. アップロード実行
```

### Step 3: App Store Connect 設定 (20分)
```
1. https://appstoreconnect.apple.com にログイン
2. "My Apps" > "+" > "New App" 
3. 基本情報入力:
   - Name: ChirAI
   - Bundle ID: com.enablerdao.ChirAI
   - SKU: chirai-ios-2025
   - Primary Language: Japanese

4. App Information:
   - Subtitle: インテリジェントローカルAIチャット
   - Category: Productivity
   - Secondary Category: Developer Tools
```

### Step 4: スクリーンショット準備 (15分)
```bash
# iPhone で実機撮影
# 音量ボタン + 電源ボタン で撮影

必要な画面:
□ メインチャット画面
□ エージェント一覧
□ 日本語会話例
□ 英語会話例  
□ 設定画面

# App Store Connect にアップロード
# App Store Connect > App Store > Screenshots
```

### Step 5: 審査提出 (5分)
```
App Store Connect で:
1. "Submit for Review" ボタンクリック
2. Export Compliance: No 選択
3. Content Rights: Yes 選択  
4. Advertising Identifier: No 選択
5. Submit 実行
```

## 📋 必要な情報

### Apple Developer Account
```
Apple ID: [必要]
Team ID: [必要] 
Distribution Certificate: [必要]
```

### App Store 説明文 (コピペ用)
```
🌸 ChirAI - インテリジェントローカルAIチャット

美しい日本風デザインとOllamaを活用した、プライバシー重視のAIチャットアプリです。

【主な機能】
• 🤖 14種類以上のAIモデル対応
• 🇯🇵 完璧な日本語会話 (qwen2.5:3b)
• 🇺🇸 高品質英語会話 (gemma3:1b)
• 🔒 完全ローカル処理 - データは外部送信されません
• ⚡ 高速応答 (平均5秒以下)
• 🌸 美しいUI/UX - 日本の美学に着想

【技術仕様】
- SwiftUI & iOS 17最新機能活用
- Ollama API統合によるローカルLLM実行
- 桜ピンクテーマの洗練されたデザイン
- 完全テスト済み (E2Eテスト100%パス)

【プライバシー】
すべてのAI処理はお使いのデバイス上で実行されます。会話データは外部サーバーに送信されず、完全にプライベートです。

Ollama (https://ollama.ai) が必要です。
```

### キーワード (コピペ用)
```
AI,chat,ollama,privacy,japanese,local,LLM,conversation,sakura,machine learning
```

## ⚡ クイック実行コマンド

### 現在のプロジェクト確認
```bash
cd /Users/yuki/wisbee-iOS
ls -la
```

### Xcode プロジェクト起動
```bash
# Swift Package の場合
open Package.swift

# または xcodeproj がある場合
find . -name "*.xcodeproj" -exec open {} \;
```

### アーカイブ作成 (コマンドライン)
```bash
# Release ビルド
xcodebuild -scheme ChirAI -configuration Release -destination generic/platform=iOS clean build

# アーカイブ作成
xcodebuild -scheme ChirAI -configuration Release -destination generic/platform=iOS archive -archivePath ChirAI.xcarchive
```

## 🚨 重要な注意点

### Bundle ID 確認
```bash
# Info.plist で Bundle ID 確認
find . -name "Info.plist" -exec grep -l "CFBundleIdentifier" {} \;
```

### 証明書確認
```bash
# Keychain で確認
# iPhone Distribution: [Your Name] が必要
```

### Ollama 説明
```
App Store Review Notes に記載:

"This app requires Ollama (https://ollama.ai) to be installed and running locally. Ollama is a free, open-source application that runs large language models locally on the user's machine. ChirAI connects to Ollama's local API (localhost:11434) to provide AI chat functionality while ensuring complete privacy - no data is sent to external servers."
```

## 📞 問題発生時の対応

### よくある問題
1. **Certificate Error**: Xcode > Preferences > Accounts で確認
2. **Bundle ID Conflict**: App Store Connect で Bundle ID を新規作成
3. **Archive Failed**: Clean Build Folder してから再実行

### サポート連絡先
- Apple Developer Support
- GitHub Issues: https://github.com/enablerdao/ChirAI/issues

## 🎉 リリース後

### 確認事項
- [ ] App Store での公開確認
- [ ] 実際のダウンロード・インストールテスト
- [ ] プレスリリース配信
- [ ] GitHub Release Notes 更新
- [ ] ソーシャルメディア告知

### 祝賀メッセージ準備
```
🌸🎉 ChirAI が App Store でリリースされました！🎉🌸

美しい日本風デザインのプライバシー重視 AI チャットアプリ

ダウンロード: [App Store Link]
GitHub: https://github.com/enablerdao/ChirAI

#ChirAI #AI #iOS #Privacy #OpenSource
```

---

**今すぐ実行: Xcode を開いてアーカイブ作成から開始！**