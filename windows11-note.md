# Windows 11 メモ

## エクスプローラーのコンテキストメニューを Windows 10 と同じようにする

「その他のオプションを表示 (SHIFT+F10)」がめんどくさい。

- [Windows11 の右クリックメニューを以前の仕様に戻す設定方法 - サムライ コンピューター](https://samurai-computer.com/how-to-get-the-old-right-click-context-menu-on-windows11/)
- [How to Get the Old Context Menus Back in Windows 11](https://www.howtogeek.com/759449/how-to-get-full-context-menus-in-windows-11s-file-explorer/)

win11_classic_context_menu.reg

```regstory
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}]
@=""

[HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32]
@=""
```

```powershell
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
```

Windows 11 の元の状態に戻すには

```regstory
Windows Registry Editor Version 5.00

[-HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}]
```

```powershell
reg.exe delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
```

## Windows 11 23H2 の目玉機能 : 「結合しない」が帰ってきた

[Windows 11 Version 22H2 の累積更新プログラム (KB5030310)](https://www.catalog.update.microsoft.com/Search.aspx?q=KB5030310) で
23H2 の新機能がほぼ提供されいて、「結合しない」もその 1 つ。

個人用設定 \> タスクバー で

- タスクバーのボタンをまとめラベルを非表示にする
- タスクバーのボタンをまとめ他のタスクバーでラベルを非表示にする

で設定できるのだが、日本語が難しくて意味がわからん。

詳細: [Windows 11 タスクバー ボタンの結合の解除とラベルの設定-パソブル](https://www.pasoble.jp/windows/11/taskbar-setting-button-aikon.html)

要は

- メインディスプレイ用の結合しないオプションが上で
- メインディスプレイ以外が下

ということらしい。自分はしばらく

- 上: なし (Never)
- 下: 常時 (Always)

で使います。

なお上記オプションの英語表記は
“Combine Taskbar buttons and hide labels”

参考:

- [How to show Taskbar labels on Windows 11 23H2 \- Pureinfotech](https://pureinfotech.com/show-taskbar-labels-never-combine-windows-11/)
- [Windows 11 のタスクバーに待望の「結合しない」モードが導入へ。有効にする方法はこちら | ソフトアンテナ](https://softantenna.com/blog/windows-11-taskbar-neber-combine-mode/)

## Shift+Space

Windows11 の日本語 MS-IME で、IME オンオフトグルを Shift+SPACE に割り当てる手順

1. **IME 設定画面を開く**

   - タスクバー右下の **IME アイコン（「あ」または「A」）を右クリック**
   - メニューから **「設定」** を選択
   - または、**Windows キー →「ime」と入力 →「日本語 IME 設定」** を選択

2. **キーとタッチのカスタマイズを有効化**

   - 「Microsoft IME」設定画面で **キーとタッチのカスタマイズ** をクリック
   - 「キーの割り当て」を **オン** にします

3. **Shift + Space に機能を割り当てる**

   - 割り当て可能なキー一覧に **Shift + Space**があります
   - その右側のドロップダウンから **IME-オン/オフ**を選択
     - これで「Shift + Space」を押すたびに IME がオン/オフ切り替わります

4. **設定を保存して閉じる**
   - 設定画面を閉じるとすぐに反映されます
