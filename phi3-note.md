# Phi-3 メモ

けっこういい感じ。

- 量子化モデルはもちろん、
  CUDA メモリが 8GB あれば非量子化モデルが動く(一番小さいやつ →
  [microsoft/Phi-3-mini-4k-instruct](https://huggingface.co/microsoft/Phi-3-mini-4k-instruct)
  )。
- 量子化モデルも Microsoft 自身が配布してる
  ([microsoft/Phi-3-mini-4k-instruct-gguf](https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf))。
- 一番小さいモデルでも結構まともに日本語で predict する。
- system プロンプトに「あなたは親切な AI アシスタントです。日本語で答えて」等書かなくても日本語で答える。
- トークンサイズがでかい (4k と 128k)
- [Microsoft Phi\-3 Cookbook](https://github.com/microsoft/Phi-3CookBook/tree/2128eac55763eecf284c2f3138e019feb1dc2a10) が親切 ← **必読**

## レポジトリ

- [Phi-3 - a microsoft Collection - Huggingface](https://huggingface.co/collections/microsoft/phi-3-6626e15e9585a200d2d761e3)
- [Tags · phi3 - ollama](https://ollama.com/library/phi3/tags) - すべて量子化モデル
