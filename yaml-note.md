YAMLメモ

- [リンク](#リンク)
- [フロースタイル / ブロックスタイル](#フロースタイル--ブロックスタイル)
- [literal style (“|”) / folded style (“>”)](#literal-style---folded-style-)

# リンク

* [The Official YAML Web Site](https://yaml.org/)
* [YAML Ain’t Markup Language (YAML™) Version 1.2](https://yaml.org/spec/1.2/spec.html)
* [プログラマーのための YAML 入門 (初級編)](https://magazine.rubyist.net/articles/0009/0009-YAML.html)
* [Language-Independent Types for YAML™ Version 1.1](https://yaml.org/type/index.html)

# フロースタイル / ブロックスタイル

- [Chapter 7. Flow Styles](https://yaml.org/spec/1.2/spec.html#Flow)
- [Chapter 8. Block Styles](https://yaml.org/spec/1.2/spec.html#Block)


# literal style (“|”) / folded style (“>”)

スカラー値のブロック表記ができる。

* [2.3. Scalars](https://yaml.org/spec/1.0/#id2490752)
* [複数行の文字列](https://magazine.rubyist.net/articles/0009/0009-YAML.html#%E8%A4%87%E6%95%B0%E8%A1%8C%E3%81%AE%E6%96%87%E5%AD%97%E5%88%97)

[上記](https://magazine.rubyist.net/articles/0009/0009-YAML.html#%E8%A4%87%E6%95%B0%E8%A1%8C%E3%81%AE%E6%96%87%E5%AD%97%E5%88%97)のサンプルから引用:
```
## 各行の改行を保存する
text1: |
  aaa
  bbb
  ccc


## 各行の改行と、最終行に続く改行を保存する
text2: |+
  aaa
  bbb
  ccc


## 各行の改行は保存するが、最終行の改行は取り除く
text3: |-
  aaa
  bbb
  ccc


## 改行を半角スペースに置き換える、ただし最終行の改行は保存される
text4: >
  aaa
  bbb
  ccc


## 改行を半角スペースに置き換え、最終行に続く改行を保存する
text5: >+
  aaa
  bbb
  ccc


## 改行を半角スペースに置き換え、最終行の改行を取り除く
text6: >-
  aaa
  bbb
  ccc
```

yaml2json (`python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=2)'`)すると
以下のような出力が得られる(手動で並べ替えた)

```
{
  "text1": "aaa\nbbb\nccc\n",
  "text2": "aaa\nbbb\nccc\n\n\n",
  "text3": "aaa\nbbb\nccc",
  "text4": "aaa bbb ccc\n",
  "text5": "aaa bbb ccc\n\n\n"
  "text6": "aaa bbb ccc",
}
```

詳しくは
[YAML Ain’t Markup Language (YAML™) Version 1.2](https://yaml.org/spec/1.2/spec.html)を`c-chomping-indicator`で検索。


