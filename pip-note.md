# Python の pip のメモ

## `npm update` 的なやつ

```sh
pip list --outdated --format=json | jq '.[].name' -r | xargs -n1 pip install -U
```

よく
`pip list --outdated --format=freeze`
を使う例が出てくるけど、新しめの pip では

> ERROR: List format 'freeze' cannot be used with the --outdated option.

「freeze は--outdated では使えません」というエラーになる。

### 上の手法の問題点は

`pip list --outdated`
が依存で入ったパッケージも全部列挙してしまうこと。

素直に何かパッケージマネージャを使うべき。
`poetry update` とか。<https://python-poetry.org/docs/cli/#update>
