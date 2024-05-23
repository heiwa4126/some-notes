# pyproject.toml のメモ

## pyproject.toml の project.urls に書いた内容が pip show で出てこない

「一向に修正されないバグ」らしい。

とりあえず `pip show -v package-name` を試してみて
`Project-URLs:` が表示されるなら
あなたは何も間違ってない。

- [project.urls pip show - Google Search](https://www.google.com/search?q=project.urls+pip+show&hl=en)
- [Include Project-URLs in `pip show` output · Issue #10799 · pypa/pip](https://github.com/pypa/pip/issues/10799)
- [Show 'home-page' project URL when Home-Page metadata value is not set · Issue #11221 · pypa/pip](https://github.com/pypa/pip/issues/11221)
