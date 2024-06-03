# Drupal メモ

## markdown 非対応の drupal 用 markdown 変換

[Markdown | Drupal.org](https://www.drupal.org/project/markdown)が入っていない Drupal 用に
markdown を HTML にして貼り付けるネタ。

- [[Solved] How to convert markdown into Drupal forum/issue compatible format? | Drupal.org](https://www.drupal.org/forum/general/general-discussion/2024-02-20/solved-how-to-convert-markdown-into-drupal-forumissue-compatible-format)
- [[Solved] How to convert markdown into Drupal forum/issue compatible format? | Drupal.org](https://www.drupal.org/forum/general/general-discussion/2024-02-20/solved-how-to-convert-markdown-into-drupal-forumissue-compatible-format#comment-15456853)

```bash
pandoc -r markdown-task_lists-auto_identifiers+autolink_bare_uris --no-highlight --wrap=none -w html input.md | sed -E 's/<pre class="([a-z]*)"><code>/<pre><code class="language-\1">/g' | sed -E 's/<code>/<code class="language-text">/g' | sed -E 's;<a href="(https://www\.drupal\.org/project/[^/]+/issues/([0-9]+))" class="uri">\1</a>;[#\2];g' > output.html
```

若干問題はあるけど、とりあえず使える。
