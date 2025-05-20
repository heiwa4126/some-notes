# Nodejs の Buffer のメモ

- [Uint8Array や ArraryBuffer や Buffer とか](https://zenn.dev/porokyu32/articles/79b81a46cbba2e)
- [Buffer | Node.js v24.0.2 Documentation](https://nodejs.org/api/buffer.html#buffer)

Buffer は Nodejs のオブジェクトでブラウザでは動かない。

ブラウザ用ポリフィルは [buffer - npm](https://www.npmjs.com/package/buffer)。
Nodejs の公式ポリフィルらしい。

## Base64url

BASE64 にして置換してパディング、はめんどくさい。パッケージがいくつかある。

- [base64url - npm](https://www.npmjs.com/package/base64url)
- [@cross/base64 - JSR](https://jsr.io/@cross/base64) よさそうなんだけど JSR にしかない
- [@hexagon/base64 - npm](https://www.npmjs.com/package/@hexagon/base64) @cross/base64 の元らしい

## ArrayBuffer

ArrayBuffer と Uint8Array は Nodejs でもブラウザでも使える。
ただし ArrayBuffer にはほとんどメソッドが無い。

Buffer は内部では ArrayBuffer を使っている。
Node 用コード:

```javascript
const buf = Buffer.from([1, 2, 3]);
// BufferからArrayBufferを取得
const arrayBuffer = buf.buffer;
```
