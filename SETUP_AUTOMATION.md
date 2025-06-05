# 🚀 ChirAI 完全自動化セットアップガイド

## 🎯 概要

このガイドに従うことで、GitHub にマージしたら自動的に App Store に配布される完全自動化パイプラインが構築できます。

## 🔧 必要な準備

### 1. Apple Developer アカウント設定

#### App Store Connect API キー作成
1. [App Store Connect](https://appstoreconnect.apple.com) にログイン
2. ユーザーとアクセス > キー > 新規作成
3. 以下の権限を付与:
   - Admin (フルアクセス)
4. キーをダウンロード (.p8 ファイル)
5. 以下の情報をメモ:
   - Issuer ID
   - Key ID
   - .p8 ファイルの内容

### 2. GitHub Secrets 設定

GitHub リポジトリの Settings > Secrets and variables > Actions で以下を設定:

```yaml
# Apple 認証情報
APPLE_ID: your-apple-id@example.com
APPLE_PASSWORD: your-app-specific-password
APP_SPECIFIC_PASSWORD: xxxx-xxxx-xxxx-xxxx  # 2要素認証用
TEAM_ID: XXXXXXXXXX  # Apple Developer Team ID
ITC_TEAM_ID: XXXXXXXXXX  # App Store Connect Team ID

# App Store Connect API (推奨)
ASC_API_KEY_ID: XXXXXXXXXX
ASC_ISSUER_ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
ASC_API_KEY: |
  -----BEGIN PRIVATE KEY-----
  [.p8ファイルの内容]
  -----END PRIVATE KEY-----

# Fastlane Match (証明書管理)
MATCH_PASSWORD: strong-password
MATCH_GIT_URL: https://github.com/enablerdao/certificates
MATCH_KEYCHAIN_NAME: fastlane_keychain
MATCH_KEYCHAIN_PASSWORD: keychain-password

# Fastlane セッション
FASTLANE_SESSION: [fastlane spaceauth -u your-email の出力]

# 通知設定 (オプション)
SLACK_WEBHOOK: https://hooks.slack.com/services/XXX/XXX/XXX
TWITTER_CONSUMER_KEY: xxx
TWITTER_CONSUMER_SECRET: xxx
TWITTER_ACCESS_TOKEN: xxx
TWITTER_ACCESS_TOKEN_SECRET: xxx
```

### 3. 証明書リポジトリ準備

```bash
# プライベートリポジトリ作成
# https://github.com/new で "certificates" リポジトリを作成 (Private)

# Fastlane Match 初期設定
fastlane match init
fastlane match appstore --generate_apple_certs
```

### 4. アプリ固有設定

#### metadata フォルダ構造
```
fastlane/metadata/
├── ja/
│   ├── description.txt
│   ├── keywords.txt
│   ├── promotional_text.txt
│   └── release_notes.txt
└── en-US/
    ├── description.txt
    ├── keywords.txt
    ├── promotional_text.txt
    └── release_notes.txt
```

#### description.txt (日本語)
```
🌸 ChirAI - インテリジェントローカルAIチャット

【革新的プライバシー保護】
ChirAIは、完全にローカルでAI処理を行う革新的なチャットアプリです。あなたの会話データは一切外部に送信されず、デバイス上で安全に処理されます。

【美しい日本風デザイン】
• 桜をイメージしたピンクテーマ
• 日本の美学原則「間・簡素・考」を採用
• ミニマルで直感的なユーザーインターフェース
• iOS 17の最新機能を活用した滑らかなアニメーション

【強力なAI機能】
• 14種類以上のAIモデルに対応
• 日本語での自然な会話（qwen2.5:3b推奨）
• 高品質な英語サポート（gemma3:1b推奨）
• 平均応答時間5秒以下の高速処理
• プログラミング、学習、創作活動をサポート

【必要環境】
• iOS 17.0以上
• Ollama（https://ollama.ai）のインストール

GitHub: enablerdao/ChirAI
```

## 🎬 自動化の動作フロー

### 1. 開発フロー
```mermaid
graph LR
    A[コード変更] --> B[Pull Request]
    B --> C[自動テスト]
    C --> D[レビュー]
    D --> E[マージ]
    E --> F[自動デプロイ]
```

### 2. main ブランチへのプッシュ時
1. 自動テスト実行
2. ビルド作成
3. TestFlight 自動アップロード
4. 内部テスター通知

### 3. タグ作成時 (v1.x.x)
1. プロダクションビルド作成
2. スクリーンショット自動生成
3. App Store 自動提出
4. リリースノート生成
5. SNS 自動投稿

## 🚀 使い方

### TestFlight 配布 (毎日の開発)
```bash
# 通常の開発
git add .
git commit -m "feat: 新機能追加"
git push origin main

# → 自動的に TestFlight に配布される
```

### App Store リリース
```bash
# バージョンタグを作成
git tag v1.6.0
git push origin v1.6.0

# → 自動的に App Store に提出される
```

## 📊 モニタリング

### GitHub Actions
- https://github.com/enablerdao/ChirAI/actions でビルド状況確認

### App Store Connect
- https://appstoreconnect.apple.com で審査状況確認

### 通知
- Slack: #ios-releases チャンネル
- メール: Apple からの審査結果

## 🔍 トラブルシューティング

### よくある問題

#### 1. 証明書エラー
```bash
# Match をリセット
fastlane match nuke appstore
fastlane match appstore
```

#### 2. ビルドエラー
```bash
# ローカルで確認
fastlane beta
```

#### 3. API キーエラー
- App Store Connect でキーの有効期限確認
- 権限が Admin であることを確認

## 🎯 高度な設定

### A/B テスト
```yaml
# .github/workflows/ab-test.yml
- name: A/B テスト配布
  run: |
    fastlane beta groups:"Internal Testers,Beta Testers"
```

### 段階的リリース
```ruby
# Fastfile
upload_to_app_store(
  phased_release: true,  # 7日間で段階的リリース
  automatic_release: true,
  release_notes: {
    "ja" => "段階的リリース中",
    "en-US" => "Phased release in progress"
  }
)
```

## ✅ チェックリスト

- [ ] Apple Developer Program 加入済み
- [ ] App Store Connect でアプリ作成済み
- [ ] Bundle ID 設定済み (com.enablerdao.ChirAI)
- [ ] GitHub Secrets 全て設定済み
- [ ] 証明書リポジトリ作成済み
- [ ] Fastlane Match 初期設定済み
- [ ] metadata フォルダ作成済み

## 🌸 完了！

これで設定は完了です。以下のコマンドでテスト:

```bash
# ローカルテスト
fastlane beta

# 本番リリーステスト
git tag v1.6.0-test
git push origin v1.6.0-test
```

**🚀 マージするだけで自動的にアプリが配布される環境の完成です！**