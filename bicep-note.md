# bicepメモ

VSCode(と拡張機能)がないと書けない。いや頑張ればできるけど死ぬ。

エラーメッセージが不親切。
ARM テンプレートに変換しないとわからんエラーがある。

教材にバグが有る。
[演習-Bicep テンプレートでリソースを定義する - Learn | Microsoft Docs](https://docs.microsoft.com/ja-jp/learn/modules/build-first-bicep-template/4-exercise-define-resources-bicep-template?pivots=powershell)


[Microsoft.Web/serverfarms](https://docs.microsoft.com/en-us/azure/templates/microsoft.web/serverfarms?pivots=deployment-language-bicep#skudescription)
は `propaties:` が必須なので
```bicep
resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: 'toy-product-launch-plan-starter'
  location: 'westus3'
  sku: {
    name: 'F1'
  }
  properties: {}
}
```
にしないとデプロイできない。

bicep.exeはlinterも兼ねている(と [Bicep リンターの使用方法 - Azure Resource Manager | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-resource-manager/bicep/linter) による)らしいが、
上の問題を検出できない。 `bicep build`で一旦ARMテンプレートに変換して、
そのJSONをVSCodeで開くと、警告が見える。
