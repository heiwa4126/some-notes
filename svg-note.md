# SVG のメモ

## 基本要素はネスト出来ない

例えば`<rect>`に`<rect>`は書けない。

## ネストできるもの

(GPT-4o による生成)

SVG には、ネストできる要素もあります。例えば、以下の要素は他の要素の内部にネストして使用できるものです。

### 1. `<g>` (グループ) 要素

`<g>` 要素は、他の SVG 要素をグループ化するために使用され、グループ全体に対してスタイルや変形を適用できます。ほぼどんな要素でもネスト可能です。

**例:**

```html
<svg width="320" height="320">
  <g transform="translate(50, 50)">
    <rect width="100" height="100" fill="green" />
    <circle cx="50" cy="50" r="40" fill="red" />
  </g>
</svg>
```

この例では、`<rect>` と `<circle>` が `<g>` の中で一緒に配置され、グループ全体に座標変換が適用されています。

### 2. `<defs>` 要素

`<defs>` 要素は、再利用可能な定義を含む要素であり、これにネストされた要素は表示されず、後で参照できます。

**例:**

```html
<svg width="320" height="320">
  <defs>
    <circle id="myCircle" cx="50" cy="50" r="40" fill="blue" />
  </defs>
  <use href="#myCircle" x="100" y="100" />
</svg>
```

ここでは、`<defs>` 内の `<circle>` が定義され、それを `<use>` 要素で再利用しています。

### 3. `<svg>` 要素内に別の `<svg>` 要素

入れ子にした `<svg>` 要素を使用して、別の SVG を描画エリアの中に配置できます。

**例:**

```html
<svg width="320" height="320">
  <svg x="50" y="50" width="100" height="100">
    <circle cx="50" cy="50" r="40" fill="yellow" />
  </svg>
</svg>
```

この例では、外側の `<svg>` 要素内に小さな SVG をネストし、円を表示しています。

### 4. `<symbol>` 要素

`<symbol>` 要素は再利用可能な描画オブジェクトを定義するために使用され、`<use>` で参照できます。

**例:**

```html
<svg width="320" height="320">
  <symbol id="icon" viewBox="0 0 100 100">
    <rect width="100" height="100" fill="purple" />
  </symbol>
  <use href="#icon" x="50" y="50" width="50" height="50" />
</svg>
```

ここでは、`<symbol>` 要素内に定義した四角形を、`<use>` を使って複数回参照できます。

### 5. `<text>` 内の `<tspan>` 要素

`<text>` 要素内でテキストのスタイルや位置を個別に制御するために、`<tspan>` 要素を使用してネストできます。

**例:**

```html
<svg width="320" height="320">
  <text x="20" y="40" font-size="24" fill="black">
    Hello,
    <tspan x="20" y="80" fill="red">SVG!</tspan>
  </text>
</svg>
```

この例では、`<tspan>` 要素を使って、2 行目のテキストに異なる色と位置を適用しています。

---

これらは、SVG 内でネストできる要素の一部ですが、他にもコンテナやスタイルを制御する要素があり、さまざまなレイアウトや構造を作成できます。
