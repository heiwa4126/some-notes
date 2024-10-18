# リッチなエディタ slate のメモ

- [Introduction | Slate](https://docs.slatejs.org/)
- [ianstormtaylor/slate: A completely customizable framework for building rich text editors. (Currently in beta.)](https://github.com/ianstormtaylor/slate)
- [slate - npm](https://www.npmjs.com/package/slate)

## Object literal may only specify known properties, and 'type' does not exist in type 'Descendant'.

超 FAQ らしいんだけど...

- [The property 'type' does not exists on 'Node' type · Issue #5264 · ianstormtaylor/slate](https://github.com/ianstormtaylor/slate/issues/5264)
- [Property 'type' does not exist on type 'Node' when trying to apply custom formatting · Issue #4915 · ianstormtaylor/slate](https://github.com/ianstormtaylor/slate/issues/4915)

サンプルコード [slate/site/examples/ts/plaintext.tsx at main · ianstormtaylor/slate](https://github.com/ianstormtaylor/slate/blob/main/site/examples/ts/plaintext.tsx) の、

```typescript
import { type Descendant } from 'slate';
//...
const initialValue: Descendant[] = [
  {
    type: 'paragraph',
    children: [{ text: 'This is editable plain text, just like a <textarea>!' }]
  }
];
```

のところが

> オブジェクト リテラルは既知のプロパティのみ指定できます。'type' は型 'Descendant' に存在しません。ts(2353)

と言われて tsc を通らない、という問題。

このエラーは、Slate.js v0.71.0 以降のバージョンから顕著に現れるようになりました。[Release slate@0.71.0 · ianstormtaylor/slate](https://github.com/ianstormtaylor/slate/releases/tag/slate%400.71.0)

**解決法**

- [TypeScript | Slate](https://docs.slatejs.org/concepts/12-typescript)
- [Best Practices for Element and Text Types](https://docs.slatejs.org/concepts/12-typescript#best-practices-for-element-and-text-types)

```typescript
import { Descendant, Element } from 'slate';

// Paragraph型のカスタム定義
type ParagraphElement = {
  type: 'paragraph';
  children: Descendant[];
};
// または、Element型を継承してParagraphElement型を定義する
interface ParagraphElement extends Element {
  type: 'paragraph';
  children: Descendant[];
}
const initialValue: ParagraphElement[] = [
  {
    type: 'paragraph',
    children: [{ text: 'This is editable plain text, just like a <textarea>!' }]
  }
];
```

**カスタム型の推奨理由**

> Slate は様々な要素タイプ (見出し、段落、リストなど) をサポートしており、
> これらの要素ごとに異なる構造や振る舞いを持つことができます。
> そのため、開発者に独自の型(例えば ParagraphElement や HeadingElement)を定義させ、それに基づいて Element 型を細分化することを推奨しています。
> これにより、型安全性を維持しつつ、柔軟なデータ構造を実現できます。
