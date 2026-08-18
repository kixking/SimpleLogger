# SimpleLogger (Log)

`Log` は、Apple の [`os.Logger`](https://developer.apple.com/documentation/os/logger) をラップした軽量かつ堅牢な Swift ロギングユーティリティです。

> **Swift 6 Ready / Strict Concurrency 適合**  
> 本ライブラリは `Sendable` に適合しており、Swift 6 の厳格な並行処理チェックに対応しています。

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

// デバッグ（リリースビルドではコンパイル段階で完全に除外されます）
Log.debug("デバッグ情報を出力します")

// クリティカルな障害（クラッシュ前後の診断に使用）
Log.fault("重大なシステム障害が発生しました")

// 関数入退場トレース（#if DEBUG のみ有効。リリースビルドでは完全に除外されます）
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

### 4. プロジェクト全体から呼び出せる設計（推奨）

各 Swift ファイルで毎回 `import SimpleLogger` を記述する手間を省くため、アプリターゲットの共通設定ファイル（例: `App.swift` や `Exports.swift` など）で **`@_exported import`** を宣言することを強く推奨します。

```swift
// Exports.swift
@_exported import SimpleLogger
```

これにより、そのモジュール内のすべてのファイルから `import` なしで直接 `Log.info(...)` を呼び出せるようになります。

> [!WARNING]
> **独自のグローバルラップ関数を作成しないでください**  
> 以下のように独自のラップ関数を作ると、ログに記録されるファイル名や行番号がすべてそのラップ関数の位置に固定されてしまい、実際のログ発生場所が判別できなくなります。
> ```swift
> // ❌ 非推奨（ファイル名・行番号がズレる原因になります）
> func myLogInfo(_ msg: String) {
>     Log.info(msg) // 常にこのファイルの行番号が記録されてしまいます
> }
> ```
> 呼び出し元の情報を正しく取得するため、`@_exported import` を用いて `Log.info` 自体を直接呼び出してください。

### 5. パフォーマンスと最適化

* **`@inlinable` 最適化**: ログAPI全体に `@inlinable` 最適化を施しています。これによりモジュール境界を越えた呼び出しのオーバーヘッドを削減し、特にリリースビルド時には `#if DEBUG` に指定された `Log.debug` や `Log.trace` への呼び出し自体がコンパイラによって完全に削除（インライン消去）されます。
* **低アロケーション・低レイテンシロック**: ログ出力時に一時配列を生成しないようパス解析（`Substring` 抽出）を最適化し、さらに低オーバーヘッドな排他制御機構（`os_unfair_lock`）を採用することで、マルチスレッド環境下でも最小限のレイテンシで動作します。

### 6. プライバシーについて

> [!IMPORTANT]
> 本ライブラリを通じて出力されるログメッセージは、コンソールでの視認性を考慮して一律 `privacy: .public` として `os.Logger` に渡されます。
> リリースビルドの Console.app でも `<private>` にマスクされずに内容を確認できる利点がありますが、**個人情報、アクセストークン、パスワードなどの機密情報をログメッセージ内に直接含めないよう十分に注意してください。**

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
