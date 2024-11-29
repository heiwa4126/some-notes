# date-fns メモ

date-fns は多機能で使いやすいですが、性能やバンドルサイズが懸念される場合、以下の代替パッケージを検討できます。

## [Day.js](https://day.js.org/)

- **特徴**: Moment.js 互換の API を持つ軽量な日付操作ライブラリ。
- **利点**:
  - 小さなバンドルサイズ(約 2KB)。
  - プラグインで機能拡張が可能。
  - ES モジュール対応でツリーシェイキングも可能。
  - 性能が比較的高速。

## [Luxon](https://moment.github.io/luxon/)

- **特徴**: Moment.js の後継者と見なされるライブラリで、タイムゾーンや国際化に強い。
- **利点**:
  - タイムゾーンやロケール対応が標準で組み込まれている。
  - ISO 8601 形式の操作に強い。
  - モダンな Date API(`Intl.DateTimeFormat`など)を活用。

## [date-fns-tz](https://github.com/marnusw/date-fns-tz)

- **特徴**: date-fns の代替というより補完的な存在で、タイムゾーンの操作に特化。
- **利点**:
  - date-fns ユーザーにとって使いやすい。
  - タイムゾーン関連の機能だけを取り入れられる。

## [TinyDatePicker](https://github.com/chrisdavies/tiny-date-picker)

- **特徴**: 日付ピッカーを提供する超軽量なライブラリ。
- **利点**:
  - 非常に軽量(1KB 以下)。
  - 日付選択の UI が必要な場合に最適。

## ネイティブ API

- **特徴**: JavaScript の`Date`オブジェクトや`Intl.DateTimeFormat`を直接利用。
- **利点**:
  - パフォーマンス面で最適。
  - 追加の依存関係が不要。
  - タイムゾーンやロケールの機能を標準でサポート。

**例**:

```typescript
const date = new Date();
console.log(date.toLocaleDateString('ja-JP', { year: 'numeric', month: 'long', day: 'numeric' }));
```

## [Temporal API (提案中)](https://tc39.es/proposal-temporal/)

- **特徴**: TC39(JavaScript の標準化団体)が提案している新しい日付と時刻の API。
- **利点**:
  - 一貫性があり、タイムゾーンやロケールに強い。
  - 日付・時刻操作のすべてをカバーする予定。

**注意**: 現時点ではブラウザサポートが限定的なので、ポリフィルが必要。

- [Date - JavaScript | MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date)
- [Temporal documentation](https://tc39.es/proposal-temporal/docs/index.html)
- [Dates and Times in JavaScript](https://blogs.igalia.com/compilers/2020/06/23/dates-and-times-in-javascript/)

## どのライブラリを選ぶか?

以下を基に判断してください:

- 必要な機能の範囲(単純な日付操作 vs タイムゾーン操作)。
- バンドルサイズやパフォーマンスへの影響。
- プロジェクトの他の技術スタックとの互換性。

## 各ライブラリでの置き換え例

### date-fns (オリジナル)

```typescript
import { format } from 'date-fns';
//...
const s = format(today, 'M/d');
```

### Day.js

```typescript
import dayjs from 'dayjs';
//...
const s = dayjs(today).format('M/D');
```

### Luxon

```typescript
import { DateTime } from 'luxon';
//...
const s = DateTime.fromJSDate(today).toFormat('M/d');
```

### date-fns-tz (タイムゾーンを考慮する場合に使用)

```typescript
import { format } from 'date-fns-tz';
//...
const timeZone = 'Asia/Tokyo';
const s = format(today, 'M/d', { timeZone });
```

### TinyDatePicker (主に UI コンポーネント用なので置き換えが若干異なります)

```html
<!-- HTML -->
<div id="datepicker"></div>
```

```typescript
import tinyDatePicker from 'tiny-date-picker';
//...
const picker = tinyDatePicker('#datepicker');
picker.on('select', (date: Date) => {
  const s = `${date.getMonth() + 1}/${date.getDate()}`;
  console.log(s);
});
```

### ネイティブ API 例

```typescript
const s = today.toLocaleDateString('en-US', { month: 'numeric', day: 'numeric' });
```

### Temporal API

(ポリフィル使用)

```typescript
import { Temporal } from '@js-temporal/polyfill';
//...
const s = Temporal.PlainDate.from(today).toString({ calendar: 'iso8601' }).slice(5).replace('-', '/');
```

### 特記事項

- **フォーマット指定の違い**: ライブラリごとにフォーマット指定の構文が異なるため、用途に応じて調整が必要です。
- **タイムゾーンやロケール対応**: 特に`Luxon`や`date-fns-tz`は、これらの機能を意識する場合に優れています。
- **軽量化目的**: 単純な日付操作の場合、`Day.js`や`ネイティブAPI`が適しています。

必要な機能に応じて適切なライブラリを選択してください!

## おまけ: Git のコミットメッセージ

"Replace date-fns with Day.js"
