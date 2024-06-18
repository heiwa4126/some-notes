# ruby ノート

ruby ぜんぜんわからん

## formatter と linter

[RuboCop | The Ruby Linter/Formatter that Serves and Protects](https://rubocop.org/)
がいいみたい。開発続いてるし。

設定がけっこうめんどい

## per-home に gem をインストールする

`pip install --user` や `npm i -g` みたいなやつ。

```sh
gem install rubocop --user
```

パスを追加

```sh
# for ruby
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin"
```

## for develop

`npm i -d` みたいなやつ。

```ruby
# Gemfile

source 'https://rubygems.org'

gem 'rspec', group: :development
gem 'pry', group: :development
```

で `bundle install --with development`

## プロジェクトの始め方

```sh
mkdir hello-ruby
cd hello-ruby
bundle init
```

Gemfile に依存書く

```ruby
# Gemfile

source 'https://rubygems.org'

gem 'rackup', '~> 2.1'
gem 'sinatra', '~> 4.0.0'
```

```sh
bundle config set --local path vendor/bundle
bundle install
```

めんどくさいから rake に書くといい。

## hello-ruby

書きました。
[heiwa4126/hello-ruby: Ruby ぜんぜんわからん](https://github.com/heiwa4126/hello-ruby)

## bundle install と gem install の違い

- `gem install` は `Gemfile.lock` を作らない。びっくり
- `bundle install` は ./vendor/bundle とかにインストールできる。

## bundler と bundle

bundler の UI が bundle

はい、その理解は正しいです。

`bundle` は、RubyGems の一部である Bundler という gem のコマンドラインインターフェース(CLI)ツールです。

Bundler は Ruby の依存関係管理ツールで、`Gemfile`と`Gemfile.lock`を用いてアプリケーションが必要とする gem とそのバージョンを管理します。

`bundle`コマンドは、Bundler の機能を呼び出す CLI ツールです。主な使い方は以下の通りです:

- `bundle install`: `Gemfile`に記載された gem をインストールし、`Gemfile.lock`を作成/更新します。
- `bundle update`: gem を最新バージョンに更新し、`Gemfile.lock`を更新します。
- `bundle exec`: 対象 gem の実行環境でコマンドを実行します。
- `bundle outdated`: インストール済みの gem が最新でない場合に通知します。
- `bundle show`: インストール済みの gem の情報を表示します。

つまり、`bundle`は Bundlergem の CLI であり、Ruby アプリケーションの gem 依存関係管理に利用されるツールです。Bundler が gem の依存関係解決や`Gemfile.lock`の作成/更新を行う中核の機能を持っています。
