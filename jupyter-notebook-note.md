# notebook のメモ

## コマンドラインで.ipynb のすべての出力を消す

たまに.ipynb ファイルを開くと VScode が死ぬようなときの対処

```bash
jupyter nbconvert --to notebook --inplace --ClearOutputPreprocessor.enabled=True your_notebook.ipynb
```
