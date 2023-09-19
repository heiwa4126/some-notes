YAMLメモ

YAML関連メモ

- [リンク](#リンク)
- [フロースタイル / ブロックスタイル](#フロースタイル--ブロックスタイル)
- [literal style (“|”) / folded style (“>”)](#literal-style---folded-style-)
- [エスケープ](#エスケープ)
- [yq](#yq)
- [構造化データ(structured data)](#構造化データstructured-data)
- [YAMLの先進的記述](#yamlの先進的記述)
- [汎用YAML lint](#汎用yaml-lint)
- [YAMLにはincludeがない](#yamlにはincludeがない)
- [yqの出力をcolorでless](#yqの出力をcolorでless)
- [YAMLのフォーマッタ](#yamlのフォーマッタ)

# リンク

- [The Official YAML Web Site](https://yaml.org/)
- [YAML Ain’t Markup Language (YAML™) Version 1.2](https://yaml.org/spec/1.2/spec.html)
- [プログラマーのための YAML 入門 (初級編)](https://magazine.rubyist.net/articles/0009/0009-YAML.html)
- [Language-Independent Types for YAML™ Version 1.1](https://yaml.org/type/index.html)

# フロースタイル / ブロックスタイル

- [Chapter 7. Flow Styles](https://yaml.org/spec/1.2/spec.html#Flow)
- [Chapter 8. Block Styles](https://yaml.org/spec/1.2/spec.html#Block)

# literal style (“|”) / folded style (“>”)

スカラー値のブロック表記ができる。

- [2.3. Scalars](https://yaml.org/spec/1.0/#id2490752)
- [複数行の文字列](https://magazine.rubyist.net/articles/0009/0009-YAML.html#%E8%A4%87%E6%95%B0%E8%A1%8C%E3%81%AE%E6%96%87%E5%AD%97%E5%88%97)

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

# エスケープ

- [4.1.6. Escape Sequences](https://yaml.org/spec/current.html#id2517668)
- [Ansible 2.6 | 不可能なWindowsの使用 - CODE Q&A 問題解決](https://code.i-harness.com/ja/docs/ansible~2.6/user_guide/windows_usage#path-formatting-for-windows)
- [Ansible 2.6 | Using Ansible and Windows - CODE Q&A Solved](https://code.i-harness.com/en/docs/ansible~2.6/user_guide/windows_usage)

> 二重引用符"を使用する場合、バックスラッシュはエスケープ文字とみなされ、別のバックスラッシュでエスケープする必要があります。

# yq

jqならぬyqが便利。

- [yq: Command-line YAML/XML processor - jq wrapper for YAML and XML documents — yq documentation](https://kislyuk.github.io/yq/)
- [jqのYAML/XMLラッパー yq でJSONとYAMLを自在に操る | Developers.IO](https://dev.classmethod.jp/articles/yq/)

jqのwrapperとして実装されているのでjqが必要。

```sh
pip3 install yq --user -U
```

# 構造化データ(structured data)

XML,YAML,JSONなどのデータ構造をそう呼ぶみたいだけど、厳密な定義が見つからない。

# YAMLの先進的記述

see
[Advanced_components - YAML - Wikipedia](https://en.wikipedia.org/wiki/YAML#Advanced_components)

# 汎用YAML lint

[GitHub - adrienverge/yamllint: A linter for YAML files.](https://github.com/adrienverge/yamllint)

```sh
pip install --user -U yamllint
```

# YAMLにはincludeがない

YAML書いてると

- インデントが深くなりがち
- 巨大になりがち

でもYAMLの仕様上includeはない。そこでプリプロセッサーを使う。

これがいちばん有名らしい。
[javanile/yamlinc: Compose multiple YAML files into one with $include tag. Split Swagger/OpenAPI into multiple YAML files.](https://github.com/javanile/yamlinc)

ただ古いので

```
$ npm install yamlinc
(略)
found 212 vulnerabilities (31 low, 111 moderate, 70 high)
  run `npm audit fix` to fix them, or `npm audit` for details
```

とか言われるのが辛い。

nodeなので

```sh
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bash_profile
```

みたいのを忘れないこと。

欠点は:

- 不要なシンタックスチェックがついてる。`!Ref`みたいのをエラーにするので困る。

他:

- [birchb1024/yamp: Yet Another Macro Processor - for YAML - Superseded by Goyamp](https://github.com/birchb1024/yamp)
- [dakusui/jq-front: A tool to empower your JSON](https://github.com/dakusui/jq-front)
- [monken/cfn-include: Preprocessor for CloudFormation templates with support for loops and flexible include statements](https://github.com/monken/cfn-include) - CloudFormation用で便利かも

# yqの出力をcolorでless

jqだと

```sh
jq -C . hoge.json | less -R
```

yq にはカラー出力がない。batを使え。

- [sharkdp/bat: A cat\(1\) clone with wings\.](https://github.com/sharkdp/bat)
- [kislyuk/yq: Command-line YAML, XML, TOML processor - jq wrapper for YAML/XML/TOML documents](https://github.com/kislyuk/yq)
  - [Color output of keys and values like jq · Issue \#17 · kislyuk/yq](https://github.com/kislyuk/yq/issues/17)

```sh
bat hoge.yaml
# or
bat --color always -p hoge.yaml | less -R
```

batはYAMLに限らず便利。詳しくはgithubのREADME参照。
[bat/README-ja.md at master · sharkdp/bat](https://github.com/sharkdp/bat/blob/master/doc/README-ja.md)

# YAMLのフォーマッタ

[google/yamlfmt: An extensible command line tool or library to format yaml files.](https://github.com/google/yamlfmt)

まあまあ使える。細かいところで変。
