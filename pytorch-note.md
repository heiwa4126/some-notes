# PyTorch のメモ

## CUDA へ tensor を移動する

```python
tensor = tensor.to('cuda')
```

正確には

```python
if torch.cuda.is_available():
    tensor = tensor.to('cuda')
```

みたいに CUDA の存在を確認してから、になる。

## 最初から CUDA に tensor を作る

例:

```python
cuda_tensor = torch.cuda.FloatTensor(3, 4)  # 3行4列の行列を作成
```

まあこのへん気をつかうよりは PyTorch Lightning を使った方がいいみたい。調べる

[PyTorch Lightning の GPU 訓練で「RuntimeError: Input type …」と怒られた場合](https://blog.shikoan.com/pytorch-lightning-runtime-error/)
