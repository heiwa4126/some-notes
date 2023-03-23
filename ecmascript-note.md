# AST

visitImport、visitExportNamedDeclaration、visitExportSpecifier、visitExportDefaultDeclaration、visitExportAllDeclaration、visitExportBatchSpecifier、visitExportDeclaration、visitExportNamespaceSpecifier、visitExportDefaultSpecifierのそれぞれが呼び出されるECMAScriptの文を以下に示します。

```javascript
import 'module';
```

```javascript
export const foo = 'bar';
```

```javascript
export { foo } from 'module';
```

```javascript
export default foo;
```

```javascript
export * from 'module';
```

```javascript
export { foo, bar } from 'module';
```

```javascript
export { foo } from 'module';
```

```javascript
export * as foo from 'module';
```

```javascript
export { default as foo } from 'module';
```

以上のように、それぞれのvisitメソッドは、import/export文のASTノードを訪問するために使用されます。
