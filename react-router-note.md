# React Router のメモ

## v7

この 2 つは同じ

- [react-router - npm](https://www.npmjs.com/package/react-router)
- [react-router-dom - npm](https://www.npmjs.com/package/react-router-dom)

ただし v7 を使う際は、

```diff
-import { useLocation } from "react-router-dom";
+import { useLocation } from "react-router";
```

from 先を変えること。
<https://reactrouter.com/upgrading/v6#upgrade-to-v7>
