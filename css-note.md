## 疑似セレクタでコロンが1つのと2つのがあるのは?

CSSの疑似セレクタには、疑似要素と疑似クラスがあります。

疑似要素は、要素内の特定の部分にスタイルを適用するもので、コロン2つで表します。例えば、::beforeや::afterなどです。
疑似クラスは、要素の特定の状態にスタイルを適用するもので、コロン1つで表します。例えば、:hoverや:checkedなどです。

CSS3より疑似要素と疑似クラスを明確に分けるため、疑似要素はコロン2つで表すようになっています。
以前のCSS2ではコロン1つでしたが、現在では非推奨です。


## @layer カスケードレイヤー

- [@layer \- CSS: カスケーディングスタイルシート \| MDN](https://developer.mozilla.org/ja/docs/Web/CSS/@layer)
- [ブラウザーの互換性](https://developer.mozilla.org/ja/docs/Web/CSS/@layer#%E3%83%96%E3%83%A9%E3%82%A6%E3%82%B6%E3%83%BC%E3%81%AE%E4%BA%92%E6%8F%9B%E6%80%A7)
- [CSSカスケードレイヤー(@layer) - とほほのWWW入門](https://www.tohoho-web.com/ex/css-cascade-layers.html)

いまいち使いどころがわからんのだけど、
@layerでまとめておくと、どこから染み出してきたCSSなのかインスペクターで調べるとき便利。
