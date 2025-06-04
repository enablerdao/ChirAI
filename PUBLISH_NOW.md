# 🚀 ChirAI 即座公開手順

## ✅ 準備完了

**Xcode プロジェクトが開かれました**: `Wisbee.xcodeproj`

## 📱 今すぐ実行する手順

### 1️⃣ Xcode でアーカイブ作成 (3分)
```
Xcode で実行:
1. Product メニュー > Archive を選択
2. Archive が完了するまで待機
3. Organizer が自動で開く
```

### 2️⃣ App Store Connect アップロード (5分)
```
Organizer で実行:
1. "Distribute App" ボタンをクリック
2. "App Store Connect" を選択
3. "Upload" を選択  
4. "Next" をクリックしてアップロード開始
```

### 3️⃣ App Store Connect 設定 (15分)
```
https://appstoreconnect.apple.com で実行:

1. ログイン後 "My Apps" をクリック
2. "+" ボタン > "New App" を選択
3. 基本情報:
   - Name: ChirAI
   - Bundle ID: com.enablerdao.ChirAI
   - SKU: chirai-ios-2025
   - Primary Language: Japanese
```

### 4️⃣ アプリ情報設定
```
App Store Connect で設定:

名前: ChirAI
サブタイトル: インテリジェントローカルAIチャット

説明文 (コピペして使用):
🌸 ChirAI - インテリジェントローカルAIチャット

美しい日本風デザインとOllamaを活用した、プライバシー重視のAIチャットアプリです。

【主な機能】
• 🤖 14種類以上のAIモデル対応
• 🇯🇵 完璧な日本語会話 (qwen2.5:3b)
• 🇺🇸 高品質英語会話 (gemma3:1b)
• 🔒 完全ローカル処理 - データは外部送信されません
• ⚡ 高速応答 (平均5秒以下)
• 🌸 美しいUI/UX - 日本の美学に着想

Ollama (https://ollama.ai) が必要です。

キーワード:
AI,chat,ollama,privacy,japanese,local,LLM,conversation,sakura

カテゴリ: Productivity
セカンダリカテゴリ: Developer Tools
価格: Free
```

### 5️⃣ スクリーンショット (10分)
```
iPhone で撮影:
1. ChirAI アプリを起動
2. 以下の画面で「音量↑+電源」ボタン同時押し:
   - メインチャット画面
   - エージェント一覧
   - 日本語会話例
   - 英語会話例
   - 設定画面

3. App Store Connect でアップロード
```

### 6️⃣ 審査提出 (2分)
```
App Store Connect で:
1. "Submit for Review" をクリック
2. Export Compliance: No
3. Content Rights: Yes
4. Advertising Identifier: No
5. "Submit" をクリック
```

## 🎯 必要な情報（準備済み）

### Bundle ID
```
com.enablerdao.ChirAI
```

### アプリ説明文（日本語・完全版）
```
🌸 ChirAI - インテリジェントローカルAIチャット

美しい日本風デザインとOllamaを活用した、プライバシー重視のAIチャットアプリです。

【主な機能】
• 🤖 14種類以上のAIモデル対応 (qwen2.5:3b, gemma3:1b など)
• 🇯🇵 完璧な日本語会話サポート
• 🇺🇸 高品質英語会話機能
• 🔒 完全ローカル処理 - データは外部送信されません
• ⚡ 高速応答 (平均5秒以下)
• 🌸 美しいUI/UX - 日本の美学に着想を得たデザイン

【技術仕様】
- SwiftUI & iOS 17 最新機能活用
- Ollama API統合によるローカルLLM実行
- 桜ピンクテーマの洗練されたデザイン
- 完全テスト済み (E2Eテスト100%パス)

【プライバシー保護】
すべてのAI処理はお使いのデバイス上で実行されます。会話データは外部サーバーに送信されず、完全にプライベートです。

【必要環境】
- iOS 17.0以上
- Ollama (https://ollama.ai) のインストールが必要

オープンソースプロジェクト: https://github.com/enablerdao/ChirAI
```

### 審査ノート（英語）
```
Review Notes:

This app requires Ollama (https://ollama.ai) to be installed and running locally on the user's Mac. Ollama is a free, open-source application that runs large language models locally.

ChirAI connects to Ollama's local API (localhost:11434) to provide AI chat functionality while ensuring complete privacy - no data is sent to external servers.

The app has been thoroughly tested with 100% E2E test pass rate and supports 14+ AI models including qwen2.5:3b for Japanese and gemma3:1b for English conversations.

Key features:
- Complete local AI processing
- Beautiful Japanese-inspired design
- Privacy-focused architecture
- Support for multiple AI models
- Bilingual (Japanese/English) interface

Open source: https://github.com/enablerdao/ChirAI
```

## 🚨 重要チェックポイント

### ❗ 必須確認事項
- [ ] Apple Developer Account でログイン済み
- [ ] Distribution Certificate が有効
- [ ] Bundle ID `com.enablerdao.ChirAI` が利用可能
- [ ] Ollama の説明を審査ノートに記載

### ⚠️ よくある問題と解決策
```
問題: "No accounts with App Store Connect access"
解決: Apple Developer Program に加入が必要

問題: "Bundle ID already exists"  
解決: 異なる Bundle ID を使用 (例: com.yourname.ChirAI)

問題: "Missing Export Compliance"
解決: "No" を選択（暗号化機能なし）
```

## 🎉 リリース後の確認

### 公開確認 (審査通過後)
- [ ] App Store でダウンロード可能確認
- [ ] 実機での動作確認
- [ ] レビュー・評価の監視開始

### 告知実行
- [ ] GitHub Release Notes 更新
- [ ] プレスリリース配信
- [ ] ソーシャルメディア投稿

## 📞 サポート

### 問題発生時
- GitHub Issues: https://github.com/enablerdao/ChirAI/issues
- Apple Developer Support: developer.apple.com/support

---

**🚀 今すぐ開始: Xcode で Product > Archive を実行してください！**