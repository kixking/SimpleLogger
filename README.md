
# Log

**Swift Package Manager** で利用できるシンプルなログユーティリティです。
`Log.message(_:, level:file:function:line:)` を呼び出すだけで、タイムスタンプ付きでコンソールに出力します。
リリースビルドでは `debug` レベルのログは自動で除外されます。

---

## 📖 使い方

```swift
import SimpleLogger

// 何か処理
Log.message("ユーザーがログインしました")

// カスタムレベル
Log.message("データ取得に失敗しました", level: .error)

// ファイル名・行番号・関数名を自動取得
func fetchData() {
    Log.message("データ取得開始")
    // ...
}
```

### レベル一覧

| レベル | 表示文字列 | 目的 |
|--------|------------|------|
| `info` | `INFO` | 一般情報 |
| `warning` | `WARNING` | 警告 |
| `error` | `ERROR` | エラー |
| `debug` | `DEBUG` | デバッグ（リリースビルドでは除外） |

---

## 📄 ライセンス

MIT License
