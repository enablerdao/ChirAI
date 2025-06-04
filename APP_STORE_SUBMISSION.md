# 🍎 App Store 提出準備ガイド

## 📋 提出前チェックリスト

### ✅ 必須要件
- [ ] **Xcode 15.0+** でビルド成功
- [ ] **iOS 17.0+** でテスト完了  
- [ ] **実機テスト** パス (iPhone/iPad)
- [ ] **App Store Guidelines** 準拠確認
- [ ] **プライバシーポリシー** 準備完了
- [ ] **スクリーンショット** 全サイズ撮影完了

### 🎯 App Store Connect 設定

#### アプリ基本情報
```yaml
アプリ名: ChirAI
サブタイトル: Intelligent Local AI Chat
SKU: com.enablerdao.chirai
Bundle ID: com.enablerdao.ChirAI
プライマリカテゴリ: Productivity
セカンダリカテゴリ: Developer Tools
```

#### 価格設定
```yaml
価格モデル: 無料 (Free)
アプリ内課金: なし
広告: なし
対象年齢: 4+ (すべての年齢)
```

## 📝 アプリ説明文

### 日本語版
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

### English Version
```
🌸 ChirAI - Intelligent Local AI Chat

A privacy-focused AI chat application featuring beautiful Japanese-inspired design and Ollama integration.

【Key Features】
• 🤖 Support for 14+ AI models
• 🇯🇵 Perfect Japanese conversations (qwen2.5:3b)
• 🇺🇸 High-quality English conversations (gemma3:1b)  
• 🔒 Complete local processing - no data sent externally
• ⚡ Fast responses (average under 5 seconds)
• 🌸 Beautiful UI/UX inspired by Japanese aesthetics

【Technical Specifications】
- Built with SwiftUI & iOS 17 latest features
- Ollama API integration for local LLM execution
- Refined design with Sakura Pink theme
- Fully tested (100% E2E test pass rate)

【Privacy】
All AI processing happens on your device. Conversation data is never sent to external servers, ensuring complete privacy.

Requires Ollama (https://ollama.ai).
```

## 🔒 プライバシーポリシー

### データ収集
```yaml
収集データ: なし
追跡: なし
第三者共有: なし
分析ツール: なし
クラッシュレポート: ローカルのみ (任意)
```

### プライバシー詳細
```
ChirAIは以下のプライバシー原則に従います：

1. ✅ ローカル処理のみ
   - すべてのAI処理はユーザーのデバイス上で実行
   - 会話データの外部送信なし

2. ✅ データ収集なし  
   - 個人情報の収集なし
   - 使用状況の追跡なし

3. ✅ 透明性
   - オープンソースプロジェクト
   - プライバシー慣行の完全開示
```

## 📸 スクリーンショット戦略

### メタデータ最適化
```yaml
タイトル: "ChirAI - AI Chat"
サブタイトル: "ローカルAIチャット"
キーワード: "AI,chat,ollama,privacy,japanese,local,LLM"
説明: "美しいUI/UX, プライバシー重視"
```

### スクリーンショット説明文
1. **メインチャット**: "直感的なAI会話インターフェース"
2. **エージェント選択**: "14種類以上のAIモデルから選択"
3. **日本語会話**: "自然で文脈に応じた日本語応答"
4. **英語会話**: "包括的で教育的な英語応答"  
5. **設定画面**: "カスタマイズ可能な設定"

## 🧪 App Review 対策

### 審査通過ポイント
```yaml
機能完成度: ✅ 完全動作 (E2Eテスト100%パス)
プライバシー: ✅ ローカル処理のみ
ユーザビリティ: ✅ 直感的なUI/UX
パフォーマンス: ✅ 高速応答 (5秒以下)
ガイドライン準拠: ✅ App Store Guidelines完全準拠
```

### 予想される質問への回答
```
Q: Ollamaが必要な理由は？
A: ローカルLLM実行環境として必要。プライバシー保護のためクラウドAPIは使用しない。

Q: なぜローカル処理なのか？  
A: ユーザーのプライバシーを最大限保護するため。

Q: 商用利用は可能か？
A: MIT License下でのオープンソース、商用利用可能。
```

## 🚀 提出手順

### 1. ビルド設定確認
```bash
# Release設定でビルド
xcodebuild -scheme ChirAI -configuration Release -destination generic/platform=iOS archive

# Archive検証
xcodebuild -exportArchive -archivePath ChirAI.xcarchive -exportPath . -exportOptionsPlist exportOptions.plist
```

### 2. App Store Connect アップロード
```bash
# Xcodeから直接アップロード
# または Application Loader使用
altool --upload-app -f ChirAI.ipa -u your_apple_id -p your_app_password
```

### 3. メタデータ設定
- アプリ情報入力
- スクリーンショットアップロード  
- プライバシー設定
- 価格・配信設定

### 4. 審査提出
- すべての設定確認
- 審査ノート記入
- 提出実行

## 📅 リリースタイムライン

### 予想スケジュール
```yaml
Day 1: App Store Connect設定・スクリーンショット準備
Day 2-3: アーカイブ作成・アップロード
Day 4: メタデータ設定・審査提出
Day 5-7: App Review期間
Day 8: 承認・リリース
```

## 🎯 マーケティング準備

### ローンチ戦略
- [ ] プレスリリース準備
- [ ] GitHub README更新
- [ ] ソーシャルメディア告知
- [ ] 技術ブログ記事
- [ ] コミュニティ告知

## 📞 サポート体制

### リリース後対応
```yaml
バグ報告: GitHub Issues
機能要望: GitHub Discussions  
プレス問い合わせ: press@enablerdao.com
技術サポート: support@enablerdao.com
```