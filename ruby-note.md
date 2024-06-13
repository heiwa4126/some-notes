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

## bundler と bundle

bundler の UI が bundle
