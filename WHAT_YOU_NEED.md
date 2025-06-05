# 🌸 ChirAI を起動するために必要なもの

## ✅ すぐに起動できるもの（準備済み）

### 1. **シミュレーターでデモ版**
```bash
# 起動スクリプトを実行
./launch_chirai.sh

# オプション 1 を選択 → シミュレーターでデモ版が起動
```

これだけで ChirAI のデモが見れます！

## 🛠️ 実際のアプリをビルドする場合

### 必要なもの:
1. **Xcode 15.0 以上**
   - Mac App Store から無料でインストール
   
2. **Apple Developer Account**（App Store 配布の場合）
   - https://developer.apple.com
   - 年額 $99 または 11,800円

3. **Ollama**（AI機能を使う場合）
   ```bash
   # インストール
   curl -fsSL https://ollama.ai/install.sh | sh
   
   # モデルダウンロード
   ollama pull qwen2.5:3b  # 日本語用
   ollama pull gemma3:1b   # 英語用
   ```

## 🚀 起動方法まとめ

### 方法1: デモ版（最も簡単）
```bash
cd /Users/yuki/wisbee-iOS
./launch_chirai.sh
# → オプション 1 を選択
```

### 方法2: Xcode でビルド
```bash
cd /Users/yuki/wisbee-iOS/ChirAI-Production
open ChirAI.xcodeproj
# → Xcode で Command + R
```

### 方法3: スクリーンショットを見る
```bash
open /Users/yuki/wisbee-iOS/screenshots/simulator/
```

## 📱 App Store 配布に必要なもの

### 必須:
1. **Apple Developer Program** 登録（年額 $99）
2. **App Store Connect** アカウント
3. **証明書とプロビジョニングプロファイル**

### 自動化設定:
1. **GitHub Secrets** 設定
   - `APPLE_ID`
   - `APPLE_PASSWORD`
   - `TEAM_ID`
   - その他（[SETUP_AUTOMATION.md](SETUP_AUTOMATION.md) 参照）

2. **Fastlane** インストール
   ```bash
   gem install fastlane
   ```

## 🎯 今すぐ試すなら

**最も簡単な方法:**
```bash
./launch_chirai.sh
```

これで ChirAI のデモが起動します！

## 🔍 トラブルシューティング

### Q: シミュレーターが起動しない
A: Xcode がインストールされているか確認
```bash
xcode-select --install
```

### Q: Ollama が動かない
A: macOS 12.0 以上が必要です

### Q: スクリプトが実行できない
A: 実行権限を付与
```bash
chmod +x launch_chirai.sh
```

## 🌸 準備完了！

上記の `launch_chirai.sh` を実行すれば、すぐに ChirAI を体験できます！