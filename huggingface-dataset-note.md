# Hugging Face Hub のデータセット

## データセットのアップロード

[AutoTrain](https://huggingface.co/autotrain)の `--data-path` が Hugging Face Hub しか対応していない...
ローカルパスを指定するとこんなエラーになる。

> ValueError: You are trying to load a dataset that was saved using `save_to_disk`. Please use `load_from_disk` instead.

まぁもともと Space で動かす用だから...

しょうがないので
[Share a dataset to the Hub](https://huggingface.co/docs/datasets/upload_dataset)を読む。

token は [Hugging Face – The AI community building the future.](https://huggingface.co/settings/tokens) で。多分 Write 権限。

あとは

```sh
pip install huggingface_hub
huggingface-cli login
```

でトークンをコピペして、以下のようにやる

```python
import unicodedata

from datasets import Dataset, DatasetDict, load_dataset

original_dataset_id = "kun432/databricks-dolly-15k-ja-gozaru-simple"
# ↑ 元ネタの「ござる。」データセット
dataset_id = "heiwa4126/test1"

dataset = load_dataset(original_dataset_id).shuffle(seed=2983)
# 元データをシャッフル

def transform_text(example):
    text = example["text"]

    nfkc_text = unicodedata.normalize("NFKC", text)
    return {"text": nfkc_text}

transformed_dataset = dataset.map(transform_text)
transformed_dataset.push_to_hub(dataset_id)

# 実験用ミニセット
transformed_dataset["train"] = transformed_dataset["train"].select(range(100))
transformed_dataset.push_to_hub(dataset_id + "-small")
```

データセットカードはどうするのか? git pull して README.md を編集

1. 各データのページの右ペインに「︙」のボタンがあるので、"Clone repository" 選ぶ。
2. 説明が出るので、それに従う。今回は https で、"without large files" のでクローンした
3. `git config --global credential.helper store`
4. `huggingface-cli login` で write の token 入れて　"Add token as git credential? (Y/n) Y"
5. あとは編集, commit, push

パラメータは README.md の
