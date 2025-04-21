# React Router のメモ

React Router v7 の framework モード (元 Remix) については別ページに。
[remix-note.md](remix-note.md)

- v7 の data モード [Installation | React Router](https://reactrouter.com/start/data/installation)

## RRv7 (の Declarative Mode)

以下の 2 つは同じ

- [react-router - npm](https://www.npmjs.com/package/react-router)
- [react-router-dom - npm](https://www.npmjs.com/package/react-router-dom)

ただし v7 を使う際は、

```diff
-import { useLocation } from "react-router-dom";
+import { useLocation } from "react-router";
```

from 先を変えること。
<https://reactrouter.com/upgrading/v6#upgrade-to-v7>

なので npm i するのも react-router のほうがいいかも。

## Remix 2 (or 3?)

React Router v7 の Framework モード。このへんから始める:

- [React Router Home | React Router](https://reactrouter.com/home)
- [Address Book | React Router](https://reactrouter.com/tutorials/address-book)
