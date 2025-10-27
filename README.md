
# Log

`Log` は、Apple の [`os.Logger`](https://developer.apple.com/documentation/os/logger) をラップした軽量な Swift ロギングユーティリティです。

---

## 📖 使い方

```swift

Log.info("アプリの起動を開始しました")
Log.warning("低メモリ状態を検出しました")
Log.error("データの読み込みに失敗しました")
Log.debug("デバッグ情報を出力します")

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
