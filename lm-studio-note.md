# LM Studio のメモ

## LM Studio は GGUF フォーマットのモデルしか読み込むことができませんか?

どうやらそうらしい。

で、GGUF はほぼ全部が量子化されたモデルなので、
非量子化(というのも変だけど)じゃない元のモデルは使えない。

誰かが量子化して Hugging Face Hub に置いたものをを使うことになる
(もちろん自分で変換しても OK)。

## ちょっと違うけど Transformers で GGUF を読むには?

[GGUF and interaction with Transformers](https://huggingface.co/docs/transformers/en/gguf#example-usage)

制限がいっぱいあってつらい。

しかも上記に載ってるサンプルコードも実行するとエラーになるので、
まあ使えないも同様だと思われる。
