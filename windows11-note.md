# エクスプローラーのコンテキストメニューをWindows10と同じようにする

「その他のオプションを表示 (SHIFT+F10)」がめんどくさい。

- [Windows11の右クリックメニューを以前の仕様に戻す設定方法 - サムライ　コンピューター](https://samurai-computer.com/how-to-get-the-old-right-click-context-menu-on-windows11/)
- [How to Get the Old Context Menus Back in Windows 11](https://www.howtogeek.com/759449/how-to-get-full-context-menus-in-windows-11s-file-explorer/)


win11_classic_context_menu.reg

```
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}]
@=""

[HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32]
@=""
```

```powershell
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
```


Windows 11の元の状態に戻すには

```
Windows Registry Editor Version 5.00

[-HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}]
```

```powershell
reg.exe delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
```
