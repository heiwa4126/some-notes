# Perl のメモ

いまどき Perl? まあいろいろあって

- [cpanm でローカルにモジュールをインストール](#cpanm-でローカルにモジュールをインストール)
- [Perl formatter](#perl-formatter)

## cpanm でローカルにモジュールをインストール

`pip --user`や`npm (-gなし)`みたいなことを cpanm で。

Perl のパッケージはディストリビューションのパッケージがあればそれを使うに越したことはないのだけど(アップデートが簡単だし)、さまざまざまな政治的理由でそういうことをせざるを得ない時にのノウハウ。

[cpanm による Perl のローカル環境構築 - Perl ゼミ(サンプルコード Perl 入門)](http://d.hatena.ne.jp/perlcodesample/20101027/1278596435)

```sh
export PERL_CPANM_OPT="--local-lib=~/perl5"
export PATH=$HOME/perl5/bin:$PATH;
export PERL5LIB=$HOME/perl5/lib/perl5:$PERL5LIB;
```

肝は`PERL_CPANM_OPT`。これで普通に cpanm すれば$HOME/perl5 以下に入る。XS でも(perl-dev があれば)OK。

package.json みたいな`cpanfile`というのもある。

```sh
perl cpanm -L extlibpath --installdeps .
```

カレントディレクトリに cpanfile を置いて、extlibpath に CAPN モジュールをインストール
(試してない)。

## Perl formatter

perltidy

- [The Perltidy Home Page](http://perltidy.sourceforge.net/)
- [perltidy - a perl script indenter and reformatter - metacpan.org](https://metacpan.org/pod/perltidy)

よくある使い方

```sh
perltidy -b -i=2 *.pl
```

~/.perltidyrc をちゃんと書くとよい。

サンプル:

- [.perltidyrc Perl Best Practices](https://gist.github.com/kimmel/1305940)
