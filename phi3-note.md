# Phi-3 メモ

けっこういい感じ。

- 量子化モデルはもちろん、
  GPU メモリが 8GB あれば非量子化モデルが動く (一番小さいやつ →
  [microsoft/Phi-3-mini-4k-instruct](https://huggingface.co/microsoft/Phi-3-mini-4k-instruct)
  )。
- 量子化モデルも Microsoft 自身が配布してる
  (例: [microsoft/Phi-3-mini-4k-instruct-gguf](https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf))。たぶんチューニングも適切にしてあると期待できる。
- で、この一番小さいモデルでも結構まともに日本語で predict する。
- system プロンプトに「あなたは親切な AI アシスタントです。日本語で答えて」等書かなくても日本語で答える。
- LM Studio で使う時でもプリセットのプロファイル Phi3 が自動で選択されて、そのままで十分動く
- 入力トークンサイズがでかい (4k と 128k)
- 日本語まわりは 1 文字 1 トークンらしい。英語は単語 (あとで確認)
- ライセンスが MIT
- **必読** [Microsoft Phi\-3 Cookbook](https://github.com/microsoft/Phi-3CookBook/) が親切。こんなモデルはじめて見た。

## Web 上ですぐさま試す

認証等不要でいきなり試せる。

[Model catalog - Azure AI Studio](https://ai.azure.com/explore/models?tid=e67df547-9d0d-4f4d-9161-51c6ed1f7d11&selectedCollection=phi&selectedTask=chat-completion&selectedLicense=mit)
で、モデルを選択してください。

「チャットの完了」と表示されてるのは "Chat complition" タスクのことらしい...

## モデルのレポジトリ

- [Phi-3 - a microsoft Collection - Hugging face](https://huggingface.co/collections/microsoft/phi-3-6626e15e9585a200d2d761e3)
- [Tags · phi3 - ollama](https://ollama.com/library/phi3/tags) - すべて量子化モデル

## 実行サンプル

[Microsoft Phi\-3 Cookbook](https://github.com/microsoft/Phi-3CookBook/?tab=readme-ov-file#microsoft-phi-3-cookbook)
にある。

Transformers と LM Studio, Ollama, Azure AI Studio の説明が載ってる。

## Fine-tuning のやりかたは?

[Microsoft Phi\-3 Cookbook](https://github.com/microsoft/Phi-3CookBook/?tab=readme-ov-file#microsoft-phi-3-cookbook)
にある。

## モデルの評価の方法は?

[Microsoft Phi\-3 Cookbook](https://github.com/microsoft/Phi-3CookBook/?tab=readme-ov-file#microsoft-phi-3-cookbook)
にある w。

## flash-attn パッケージ

> \`flash-attention\` package not found, consider installing for better performance: No module named 'flash_attn'.

と言われるので、
**[flash-attn · PyPI](https://pypi.org/project/flash-attn/)
に従って**
インストールする。

**注意: パッケージは `flash-attention` ではなく `flash-attn` のほう。**

[PyTorch](https://pytorch.org/)
の下のほう、"INSTALL PYTORCH" にあるセレクタで
CUDA 対応のパッケージをインストールすること。

確認は

```sh
python3 -c 'import flash_attn'
# または
python3 -c 'from transformers.utils import is_flash_attn_2_available; print(is_flash_attn_2_available())'
## "True"
```

### "You are not running the flash-attention implementation, expect numerical differences." って言われるんですけど?

Flash attention は
float16 か bfloat16 でしか動かないらしい。

こんな感じで使う? とりあえず警告は出ずに動くけど、あまり早くなったような気がしない。

```python
model = AutoModelForCausalLM.from_pretrained(
    model_id, device_map="cuda",
    trust_remote_code=True, use_cache=True,
    torch_dtype=torch.float16, attn_implementation="flash_attention_2"
)
```

参考: [ValueError: Flash Attention 2.0 only supports torch.float16 and torch.bfloat16 dtypes. You passed torch.float32, this might lead to unexpected behaviour. · Issue #28052 · huggingface/transformers](https://github.com/huggingface/transformers/issues/28052)

### fine-tuning はともかく推論ではあまり早くならないらしい

[【続】Flash Attention を使って LLM の推論を高速・軽量化できるか？ #Python - Qiita](https://qiita.com/jovyan/items/5716cd83e246df4a158e)
