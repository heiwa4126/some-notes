# Windows Defender のメモ

## 例外設定をCLI(pwsh)で

管理者権限で

```pwsh
Add-MpPreference -ExclusionPath <例外パス>
```

あと例外にしといたほうがいいパスを得るコマンド

```pwsh
uv cache dir
npm config get cache
pnpm store path
pnpm config get cache-dir
bun pm cache # これだけあやしい
```
