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

// エラーログ（Error型を直接渡せます。String(describing:) で詳細を記録します）
Log.error(someError)
// またはメッセージ
Log.error("データの読み込みに失敗しました")

// デバッグ（リリースビルドでは除外されます）
Log.debug("デバッグ情報を出力します")

// クリティカルな障害（クラッシュ前後の診断に使用）
Log.fault("重大なシステム障害が発生しました")

// 関数入退場トレース（#if DEBUG のみ有効）
Log.trace()
```

### 3. カテゴリ別ロガー

機能ごとにカテゴリを分けたい場合は、インスタンスを作成できます。

```swift
let networkLog = Log(category: "Network")
networkLog.info("リクエストを開始しました")

// サブシステムも個別に指定可能
let dbLog = Log(subsystem: "com.example.MyApp", category: "Database")
```

### 4. パフォーマンス

`Log` はデフォルトロガーをキャッシュするため、複数回のログ呼び出しでも効率的です。
内部状態はロックで保護されており、Swift 6 の strict concurrency にも対応しています。

### 5. プライバシーについて

ログメッセージは `privacy: .public` で記録されるため、リリースビルドでも Console.app で `<private>` にならず内容を確認できます。
そのため、個人情報やトークンなどの機密情報をログメッセージに含めないよう注意してください。

### レベル一覧

| レベル    | メソッド       | 目的                           |
| --------- | -------------- | ------------------------------ |
| `info`    | `info(...)`    | 一般情報                       |
| `warning` | `warning(...)` | 警告                           |
| `error`   | `error(...)`   | エラー                         |
| `debug`   | `debug(...)`   | デバッグ（#if DEBUG のみ有効） |
| `fault`   | `fault(...)`   | 重大障害（常に記録）           |
| `trace`   | `trace()`      | 関数トレース（#if DEBUG のみ） |

---

## 📄 ライセンス

MIT License
