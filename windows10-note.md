# Windows 10 ノート

## Windows 10 の ms-settings: スキーム で 「設定」の特定ページを開く

`ms-settings:`は
「設定」の特定ページをいきなり開けるスキームです。
手順書書くときに便利。

例えば
⊞ Win+R で
「ファイル名を指定して実行」を開けて
`ms-settings:display` で 「システム」の「ディスプレイ」が開きます。

Explorer のアドレスに入れてもいいし、
ブラウザの URL に入れても OK。
もちろん HTML に書いてもいいけます、

```html
<!DOCTYPE html>
<html><head><body>
  <a href="ms-settings:display">「ディスプレイ」設定を開きます。</a>
</html>
```

「ショートカットを作成」でも使えます。

使える URI のリストはここにあります。
[Launch the Windows Settings app - UWP applications | Microsoft Learn](https://learn.microsoft.com/en-us/windows/uwp/launch-resume/launch-settings-app#ms-settings-uri-scheme-reference)

試してないけど Windows Server 2019 以上でも使えると思います。

たとえば

1. 「Windows マーク」をクリックするか、キーボードの「Windows キー」を押します。
2. 歯車アイコンをクリックして「設定」を表示。
3. 左ペインから「時刻と言語」
4. 「言語と地域」を選択
5. 「日本語」の右端の「...」をクリックして「言語のオプション」を選択
6. 「Microsoft IME」右端の「...」をクリックして「キーボードオプション」を選択

よりは

1. ⊞ Win+R で 「ファイル名を指定して実行」を開ける
2. ms-settings:regionlanguage-jpnime と入れてリターンキー

のほうが絶対楽
