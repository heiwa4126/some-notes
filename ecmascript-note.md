# AST

visitImport、visitExportNamedDeclaration、visitExportSpecifier、visitExportDefaultDeclaration、visitExportAllDeclaration、visitExportBatchSpecifier、visitExportDeclaration、visitExportNamespaceSpecifier、visitExportDefaultSpecifier のそれぞれが呼び出される ECMAScript の文を以下に示します。

```javascript
import "module";
```

```javascript
export const foo = "bar";
```

```javascript
export { foo } from "module";
```

```javascript
export default foo;
```

```javascript
export * from "module";
```

```javascript
export { bar, foo } from "module";
```

```javascript
export { foo } from "module";
```

```javascript
export * as foo from "module";
```

```javascript
export { default as foo } from "module";
```

以上のように、それぞれの visit メソッドは、import/export 文の AST ノードを訪問するために使用されます。
