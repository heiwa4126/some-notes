いまどきPerl? まあいろいろあって

# cpanmでローカルにモジュールをインストール

`pip --user`や`npm (-gなし)`みたいなことをcpanmで。

Perlのパッケージはディストリビューションのパッケージがあればそれを使うに越したことはないのだけど(アップデートが簡単だし)、さまざまざまな政治的理由でそういうことをせざるを得ない時にのノウハウ。

[cpanmによるPerlのローカル環境構築 - Perlゼミ(サンプルコードPerl入門)](http://d.hatena.ne.jp/perlcodesample/20101027/1278596435)

```
export PERL_CPANM_OPT="--local-lib=~/perl5"
export PATH=$HOME/perl5/bin:$PATH;
export PERL5LIB=$HOME/perl5/lib/perl5:$PERL5LIB;
```

肝は`PERL_CPANM_OPT`。これで普通にcpanmすれば$HOME/perl5以下に入る。XSでも(perl-devがあれば)OK。

package.jsonみたいな`cpanfile`というのもある。

```
perl cpanm -L extlibpath --installdeps .
```

カレントディレクトリにcpanfileを置いて、extlibpathにCAPNモジュールをインストール
(試してない)。