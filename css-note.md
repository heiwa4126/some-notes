# CSS メモ

## 疑似セレクタでコロンが 1 つのと 2 つのがあるのは?

CSS の疑似セレクタには、疑似要素と疑似クラスがあります。

疑似要素は、要素内の特定の部分にスタイルを適用するもので、コロン 2 つで表します。例えば、::before や::after など
疑似クラスは、要素の特定の状態にスタイルを適用するもので、コロン 1 つで表します。例えば、:hover や:checked などです。

CSS3 より疑似要素と疑似クラスを明確に分けるため、疑似要素はコロン 2 つで表すようになっています。
以前の CSS2 ではコロン 1 つでしたが、現在では非推奨です。

## @layer カスケードレイヤー

- [@layer \- CSS: カスケーディングスタイルシート \| MDN](https://developer.mozilla.org/ja/docs/Web/CSS/@layer)
- [ブラウザーの互換性](https://developer.mozilla.org/ja/docs/Web/CSS/@layer#%E3%83%96%E3%83%A9%E3%82%A6%E3%82%B6%E3%83%BC%E3%81%AE%E4%BA%92%E6%8F%9B%E6%80%A7)
- [CSS カスケードレイヤー(@layer) - とほほの WWW 入門](https://www.tohoho-web.com/ex/css-cascade-layers.html)

いまいち使いどころがわからんのだけど、
@layer でまとめておくと、どこから染み出してきた CSS なのかインスペクターで調べるとき便利。

## 2025 年の font-family

**注意: monospace の記述はまだ怪しい。**

Windows 10/11 に Noto font (Noto Sans Mono を除く)が標準インストールされるようになったので、
日本語だったら

```css
.font-sans {
  font-family: 'Noto Sans JP', 'Hiragino Sans', 'Hiragino Kaku Gothic ProN', '游ゴシック体', 'Yu Gothic', YuGothic, 'Segoe UI', 'Meiryo UI', Meiryo, 'MS PGothic', sans-serif;
}
.font-serif {
  font-family: 'Noto Serif JP', 'Hiragino Mincho ProN', '游明朝', 'Yu Mincho', YuMincho, 'MS PMincho', serif;
}
.font-mono {
  font-family: 'BIZ UDGothic', 'BIZ UD ゴシック', 'SF Mono', Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', Courier, monospace;
}
```

が良さそう。

### 各フォントのざっくり解説

**sans-serif:**

いわゆる「ゴシック体」

- **`"Noto Sans JP"`:** まず、日本語の Noto Font を指定
- **`"Hiragino Sans"`, `"Hiragino Kaku Gothic ProN"`:** macOS で一般的なゴシック体フォント
- **`"游ゴシック体"`, `YuGothic`:** Windows で比較的新しいゴシック体フォント
- **`"Meiryo UI"`, `Meiryo`:** Windows で一般的なゴシック体フォント
- **`"MS PGothic"`:** 古い Windows 環境で一般的なゴシック体フォント
- **`sans-serif`:** 最後に、汎用フォントファミリーを指定。

**serif:**

いわゆる「明朝体」

- **`"Noto Serif JP"`:** まず、日本語の Noto Font を指定し
- **`"Hiragino Mincho ProN"`:** macOS で一般的な明朝体フォント
- **`"游明朝"` / `YuMincho`:** Windows で比較的新しい明朝体フォント
- **`"MS PMincho"`:** 古い Windows 環境で一般的な明朝体フォント
- **`serif`:** 最後に、汎用フォントファミリーを指定。

**monospace:**

いわゆる「等幅」

- **Noto Sans Mono CJK**: Google が開発した Noto フォントファミリーの一部。日本語・中国語・韓国語（CJK）の文字セットに対応した等幅フォント。Windows 10/11（2025 年以降）に標準搭載。
- **Source Han Mono**: 「Noto Sans Mono CJK」の別名バージョン。Adobe 主導で開発された Source Han シリーズの等幅バージョン。見た目と機能は基本的に Noto Sans Mono CJK と同じ。
- **BIZ UD ゴシック**: 日本政府が推奨するユニバーサルデザイン（UD）フォント。アクセシビリティに配慮した等幅フォントで、可読性に優れている。
- **SF Mono**: Apple が開発した macOS と iOS 用の等幅フォント。プログラミングやコード表示に最適化されているが、システムフォントとしてのみ利用可能。
- **Menlo**: macOS に標準搭載されている等幅フォント。iOS の Xcode などでも使用される。
- **Monaco**: 古い macOS 向けの等幅フォント。長い間 Apple の標準コードフォントだった。
- **Consolas**: Microsoft 開発の等幅フォント。Visual Studio などで使用され、Windows に標準搭載。
- **Liberation Mono**: Red Hat が開発したオープンソースの等幅フォント。多くの Linux ディストリビューションで標準搭載。
- **Courier New**: Microsoft の標準等幅フォント。ほぼすべての Windows 環境で利用可能。
- **Courier**: Courier New の前身となる古典的な等幅フォント。多くの OS に搭載されている。
- **monospace**: 最後のフォールバックとして指定される汎用的な等幅フォントファミリー。ブラウザや OS がこのカテゴリに分類する任意の等幅フォントが使用される。
