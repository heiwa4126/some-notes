# CDN で JS モジュールなどを配布してるサービスのメモ

## UNPKG、jsDelivr、cdnjs

(以下 GPT-4o が生成)

UNPKG、jsDelivr、そして CDNJS はすべて異なる目的と機能を持った CDN サービスですが、それぞれのアプローチにいくつかの違いがあります。これら 3 つを比較し、どのように minify 版(圧縮版)の配布が扱われているかに焦点を当てて説明します。

### 1. **UNPKG**

- **主な目的**: npm パッケージのファイルをそのまま提供するサービス。npm レジストリの内容をそのまま CDN 経由で提供。
- **minify 版の提供**: UNPKG 自体は minify(圧縮)処理を行いません。パッケージに minified バージョン(`*.min.js`など)が含まれている場合、それを提供しますが、含まれていない場合は非圧縮ファイルが配布されます。
- **ファイル提供の仕組み**: UNPKG は npm パッケージの内容を忠実に反映しており、ビルドや圧縮を行わずにそのまま提供。ビルドや minification は、npm パッケージのメンテナの責任です。

### 2. **jsDelivr**

- **主な目的**: 高速で柔軟な CDN サービスを提供し、複数のソース(npm、GitHub、WordPress など)からのファイルを配布。キャッシュや最適化機能が充実。
- **minify 版の提供**: jsDelivr は、パッケージに minified ファイルが含まれている場合はそれを提供し、含まれていない場合は自動的に minify 処理を行うこともあります。また、パッケージ内の任意のファイルを指定して取得できる機能もあります。
- **ファイル提供の仕組み**: jsDelivr は、ファイルを自動的に最適化したり、CDN 上で圧縮して効率的に配布します。また、プロダクション用の minified 版と開発用の unminified 版を明示的に使い分けることができ、URL 指定でバージョン管理も可能です。

### 3. **CDNJS**

- **主な目的**: Web 開発でよく使用される JavaScript ライブラリや CSS フレームワークなどを高速で提供する CDN サービス。特に人気の高いオープンソースライブラリを事前にホストしている。
- **minify 版の提供**: CDNJS では、多くのライブラリの minified バージョン(`*.min.js`や`*.min.css`)があらかじめホストされています。ライブラリの公式ビルドには、通常、minified 版と unminified 版の両方が含まれており、CDNJS はそれらを提供します。
- **ファイル提供の仕組み**: CDNJS は、事前に人気のあるライブラリをホスティングしており、ライブラリに付属する minified バージョンを提供しています。特定のライブラリが CDNJS にない場合、メンテナがリクエストして追加されることが多いです。

---

### **3 つのサービスの比較表**

| **項目**               | **UNPKG**                                          | **jsDelivr**                                             | **CDNJS**                                       |
| ---------------------- | -------------------------------------------------- | -------------------------------------------------------- | ----------------------------------------------- |
| **目的**               | npm パッケージをそのまま CDN 経由で配布            | npm、GitHub、WordPress からのファイル配布                | 人気のある Web ライブラリを事前にホストして配布 |
| **minify 版の提供**    | パッケージに含まれていれば提供するが、自動ではない | パッケージ内に minify 版があれば提供、ない場合は自動圧縮 | ほとんどのライブラリで minified 版を提供        |
| **ビルドや圧縮**       | なし(パッケージ内容に依存)                         | 自動圧縮やキャッシュ最適化をサポート                     | ライブラリに付属する minified 版を配布          |
| **柔軟なファイル指定** | npm パッケージ内の任意ファイルを指定可能           | 任意のバージョンやファイル指定が可能                     | ライブラリごとのファイルが事前にホスト          |
| **利用対象の範囲**     | npm のすべてのパッケージ                           | npm、GitHub、他のソースからも配布                        | 人気のあるライブラリに限定される                |

---

### 要点のまとめ

- **UNPKG** は、npm パッケージそのままのファイルを提供し、ビルドや minification は開発者の責任です。自動的な minify 処理は行いません。
- **jsDelivr** は、npm や GitHub などからのファイルを最適化して配布するため、minified 版を自動的に生成したり、パフォーマンスを向上させる機能があります。
- **CDNJS** は、多くの人気ライブラリをあらかじめホスティングしており、通常 minified 版が含まれているため、開発者は minified 版を簡単に利用できます。

それぞれのサービスは異なる目的と利便性を持っているため、プロジェクトのニーズに応じて使い分けるのが効果的です。

## それ以外

(以下 GPT-4o が生成)

UNPKG、jsDelivr、CDNJS のほかにも、いくつかの有名な CDN やライブラリ配布サイトがあります。以下は、よく使われている有名な CDN やライブラリ配布サービスです。

### 1. **Google Hosted Libraries**

- **概要**: Google が提供するオープンソースのライブラリ CDN です。特に、jQuery や AngularJS、Bootstrap などの人気のあるライブラリがホスティングされています。
- **特徴**:
  - Google のインフラを利用しているため、高速で信頼性のあるサービス。
  - jQuery、AngularJS、Dojo、Prototype など、いくつかの特定のライブラリに特化。
  - 最新バージョンや特定のバージョンを簡単に取得可能。
- **URL**: [https://developers.google.com/speed/libraries](https://developers.google.com/speed/libraries)

### 2. **Microsoft Ajax CDN**

- **概要**: Microsoft が提供する Ajax ライブラリ用の CDN で、主に jQuery や Bootstrap、Knockout などの JavaScript フレームワークをホスティングしています。
- **特徴**:
  - jQuery や jQuery UI、jQuery Mobile、Bootstrap などをサポート。
  - ASP.NET の開発者向けに提供されていることが多い。
- **URL**: [https://docs.microsoft.com/en-us/aspnet/ajax/cdn/overview](https://docs.microsoft.com/en-us/aspnet/ajax/cdn/overview)

### 3. **Cloudflare CDN (cdnjs の親会社)**

- **概要**: Cloudflare は、世界中に分散した CDN を提供している大手プロバイダーであり、cdnjs をサポートしています。Cloudflare 自体もサイトのパフォーマンス向上のためのキャッシュ機能を提供しますが、cdnjs はそのライブラリホスティングサービスです。
- **特徴**:
  - グローバルなネットワークに分散しているため、高速で信頼性が高い。
  - サイトのパフォーマンスを向上させるためのツールとして人気。
- **URL**: [https://www.cloudflare.com/cdn/](https://www.cloudflare.com/cdn/)

### 4. **BootstrapCDN (MaxCDN)**

- **概要**: Bootstrap や Font Awesome など、フロントエンド開発でよく使われるライブラリに特化した CDN です。MaxCDN(現在は StackPath に統合)が提供しています。
- **特徴**:
  - Bootstrap や Font Awesome、Bootswatch などのフロントエンドライブラリを簡単に使える。
  - 主要なフロントエンドライブラリの最新バージョンを素早く取得可能。
- **URL**: [https://www.bootstrapcdn.com/](https://www.bootstrapcdn.com/)

### 5. **jsdelivr + GitHub**

- **概要**: jsDelivr は、GitHub のリポジトリから直接ファイルを CDN として配布する機能を提供しています。npm だけでなく、GitHub リポジトリをそのまま CDN として利用できることが特徴です。
- **特徴**:
  - GitHub のリポジトリにホスティングされている任意のファイルやバージョンを直接取得可能。
  - npm や WordPress プラグインのファイルも利用できるため、幅広いユースケースに対応。
- **URL**: [https://www.jsdelivr.com/github](https://www.jsdelivr.com/github)

### 6. **SRI Hash CDN**

- **概要**: Subresource Integrity(SRI)に対応した CDN で、ライブラリの配布とともに SRI 用のハッシュを提供します。SRI ハッシュを使うことで、CDN から読み込んだファイルの完全性を検証することができます。
- **特徴**:
  - Subresource Integrity(SRI)をサポートしており、セキュリティ面での利点がある。
  - 利用するファイルが改変されていないかをチェックできる。
- **URL**: [https://www.srihash.org/](https://www.srihash.org/)

### 7. **Skypack**

- **概要**: Skypack は、最新の ES モジュール(ESM)を利用するための CDN サービスで、ブラウザ上で直接モジュールをインポートできるようにしたものです。npm パッケージを ES モジュールとして提供することに特化しています。
- **特徴**:
  - npm のパッケージを ES モジュール形式で直接ブラウザに配信。
  - 開発者がモダンなブラウザ環境で簡単にモジュールをインポート可能。
  - 自動的に古いブラウザ向けのトランスパイルを行い、互換性を保つ。
- **URL**: [https://www.skypack.dev/](https://www.skypack.dev/)

---

### **その他の CDN や配布サイト**

- **jsHub**: JavaScript 関連のスクリプトやライブラリを中心に配布。
- **Google Fonts**: フォントファイルを配布するための CDN。特に Web フォントの利用に特化。
- **Netlify**: 静的サイトをホスティングするサービスで、CDN 機能を提供している。

---

### **まとめ**

これらの CDN サービスやライブラリ配布サイトは、それぞれ異なる特徴や強みを持っています。プロジェクトの要件に応じて、最適な CDN を選択することで、Web サイトのパフォーマンスやセキュリティを向上させることができます。
