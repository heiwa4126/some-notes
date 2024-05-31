# LLM の text-generating モデルのメモ

## バッチ生成

基本 text-generating モデルは 1 トークンづつ生成するらしい。
ただ、API のオプションによっては複数トークンできるモデルもあるらしい。

それについて GPT-4o に聞いたのをメモ。
**以下嘘かもしれない。要検証**

---

Q.
text-generating モデルにバッチ生成を行わせるオプション引数を
Hugging Face や OpenAI API, AWS Bedlock API で示してください。

A.
テキスト生成モデルにバッチ生成を行わせるためのオプション引数を、Hugging Face Transformers、OpenAI API、AWS Bedrock API について説明します。

### Hugging Face Transformers

Hugging Face の Transformers ライブラリでは、バッチ生成を行うためには入力をバッチ形式で用意し、`generate`メソッドを使用します。

#### 使用例

```python
from transformers import GPT2LMHeadModel, GPT2Tokenizer

model_name = "gpt2"
model = GPT2LMHeadModel.from_pretrained(model_name)
tokenizer = GPT2Tokenizer.from_pretrained(model_name)

prompts = ["Hello, my name is", "What is the capital of"]
inputs = tokenizer(prompts, return_tensors="pt", padding=True)

output_sequences = model.generate(
    input_ids=inputs["input_ids"],
    attention_mask=inputs["attention_mask"],
    max_length=50,
    num_return_sequences=1
)

# デコードして出力を表示
for generated_sequence in output_sequences:
    print(tokenizer.decode(generated_sequence, skip_special_tokens=True))
```

### OpenAI API

OpenAI API では、`batch_size`のようなオプションはありませんが、バッチ処理を手動で行うことができます。複数のプロンプトを一度に送信して、それぞれに対して生成を行います。

#### 使用例

```python
import openai

openai.api_key = 'your-api-key'

prompts = ["Hello, my name is", "What is the capital of"]

responses = [openai.Completion.create(
    engine="text-davinci-003",
    prompt=prompt,
    max_tokens=50
) for prompt in prompts]

for response in responses:
    print(response['choices'][0]['text'])
```

### AWS Bedrock API

AWS Bedrock API を使用する際、具体的なバッチ生成のサポートは API のバージョンや仕様によって異なる場合があります。AWS SDK を用いてバッチ処理を行う方法の一例を示します。

#### 使用例(仮想的な例として、具体的なエンドポイントやパラメータは API ドキュメントを参照):

```python
import boto3

client = boto3.client('bedrock', region_name='us-west-2')

prompts = ["Hello, my name is", "What is the capital of"]

responses = []
for prompt in prompts:
    response = client.invoke_model(
        ModelId='your-model-id',
        Input={
            'prompt': prompt,
            'max_tokens': 50
        }
    )
    responses.append(response['GeneratedText'])

for response in responses:
    print(response)
```

### まとめ

- **Hugging Face Transformers**: バッチ形式の入力を`tokenizer`と`generate`メソッドで処理。
- **OpenAI API**: 明示的なバッチ生成オプションはないが、複数のプロンプトをリストで処理。
- **AWS Bedrock API**: 具体的なバッチ生成サポートは API 仕様に依存するが、ループを使用してバッチ処理を実装可能。

それぞれの API の詳細な使用方法やオプションについては、公式ドキュメントを参照すると良いでしょう。
