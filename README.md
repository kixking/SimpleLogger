# Log

`Log` は、Apple の [`os.Logger`](https://developer.apple.com/documentation/os/logger) をラップした軽量な Swift ロギングユーティリティです。

---

## 📖 使い方

### 1. 初期設定（オプション）

デフォルトでは `Bundle Identifier` がサブシステム名、 `"General"` がカテゴリ名として使用されますが、カスタマイズも可能です。

```swift
Log.configure(subsystem: "com.example.MyApp", category: "Networking")
```

### 2. ログ出力

```swift
// 通常のログ
Log.info("アプリの起動を開始しました")
Log.warning("低メモリ状態を検出しました")

// エラーログ（Error型を直接渡せます）
Log.error(someError)
// またはメッセージ
Log.error("データの読み込みに失敗しました")

// デバッグ（リリースビルドでは除外されます）
Log.debug("デバッグ情報を出力します")
```

### 3. プライバシーについて

セキュリティのため、動的な文字列（変数など）はデフォルトで `<private>` と表示される場合があります。
開発中はデバッガを接続するか、コンソールアプリの設定で表示を有効にしてください。

### レベル一覧

| レベル    | メソッド       | 目的                           |
| --------- | -------------- | ------------------------------ |
| `info`    | `info(...)`    | 一般情報                       |
| `warning` | `warning(...)` | 警告                           |
| `error`   | `error(...)`   | エラー                         |
| `debug`   | `debug(...)`   | デバッグ（#if DEBUG のみ有効） |

---

## 📄 ライセンス

MIT License
