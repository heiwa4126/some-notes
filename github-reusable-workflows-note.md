# GitHub Actions の Reusable Workflows のメモ

## Reusable Workflows で使えないアクション

### pypa/gh-action-pypi-publish

v1.13.0 (2026-02) 現在

GitHub Actions のログの出力。

> Reusable workflows are **not currently supported** by PyPI's Trusted Publishing
> functionality, and are subject to breakage. Users are **strongly encouraged**
> to avoid using reusable workflows for Trusted Publishing until support
> becomes official. Please, do not report bugs if this breaks.
>
> For more information, see:
>
> - https://docs.pypi.org/trusted-publishers/troubleshooting/#reusable-workflows-on-github
> - https://github.com/pypa/gh-action-pypi-publish/issues/166 — subscribe to
>   this issue to watch the progress and learn when reusable workflows become
>   supported officially

- [Reusable workflows on GitHub](https://docs.pypi.org/trusted-publishers/troubleshooting/#reusable-workflows-on-github)
- [Trusted publishing: Support for GitHub reusable workflows · Issue #11096 · pypi/warehouse](https://github.com/pypi/warehouse/issues/11096)
- [⚠️ Reusable workflows are currently unsupported on the PyPI side (\`invalid-publisher\` error when using reusable workflow) · Issue #166 · pypa/gh-action-pypi-publish](https://github.com/pypa/gh-action-pypi-publish/issues/166)

> 再利用可能なワークフローは現在、PyPIのTrusted Publishing機能ではサポートされておらず、動作が不安定になる可能性があります。正式にサポートされるまでは、Trusted Publishingで再利用可能なワークフローを使用しないことを強くお勧めします。動作が不安定になった場合でも、バグ報告はご遠慮ください。
