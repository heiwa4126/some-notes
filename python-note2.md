# Pythonメモ2

長くなったので第2部


# loggingモジュール経由でsyslog

NORMALレベルのlogがでなくて苦労した。
loggingはかなり難しいモジュール。
**初心者向きの記事読んでlogging使うと行き詰まる**。

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
loggingでsyslog handlerを使う例
"""
import logging


def get_syslogger():
    from logging.handlers import SysLogHandler

    log = logging.getLogger("syslog")
    # 名前はなんでもいいのだが、**loggerは名前が同一ならばPythonプロセス内を通して常に同一**
    log.setLevel(logging.INFO)
    # レベルフィルタはハンドラとログルートの2つ必要。
    # デフォルトがWARNING以上だから

    handler = SysLogHandler(address="/dev/log")
    # SysLogHandlerのデフォルトはlocalhostの514/UDPなので
    # unix socketを使うならaddressを明示する
    handler.setLevel(logging.INFO)
    # この場合レベルのフィルタはハンドラとログルートの2つ必要。
    # デフォルトがWARNING以上だから
    handler.setFormatter(
        logging.Formatter("appname[%(process)d]: %(levelname)s: %(message)s at %(filename)s(%(lineno)d)")
    )
    log.addHandler(handler)

    return log


if __name__ == r"__main__":
    lgr = get_syslogger()
    lgr.debug("debug") # <-これは出ない
    lgr.info("info")
    lgr.warning("warning")
    lgr.error("error")
    lgr.critical("critical")

    l2 = logging.getLogger("syslog")
    # l2とlgrは同じものになる。ハンドルを設定する必要がない。
    # 「loggerは名前が同一ならばPythonプロセス内を通して常に同一」の例
    l2.debug("debug2") # <-これは出ない
    l2.info("info2")
    l2.warning("warning2")
    l2.error("error2")
    l2.critical("critical2")
```

もし別モジュールがあるなら、そこでは`logging.getLogger("syslog")`でロガーを得ること。`get_syslogger()`を呼んだりしないこと。(またはlgrを引数で渡すとか)

参考:
- [Python の logging について - Qiita](https://qiita.com/kitsuyui/items/5a7484a09eeacb564649)
- [Logging HOWTO — Python 3.8.1 ドキュメント](https://docs.python.org/ja/3/howto/logging.html)
- [Logging クックブック — 複数のモジュールで logging を使う](https://docs.python.org/ja/3/howto/logging-cookbook.html#using-logging-in-multiple-modules)


# loggingモジュールでlog rotation

参考:
- [便利なハンドラ](https://docs.python.org/ja/3/howto/logging.html#useful-handlers)
- [Logging クックブック — Python 3.8.1 ドキュメント](https://docs.python.org/ja/3/howto/logging-cookbook.html#logging-cookbook)
- [RotatingFileHandler](https://docs.python.org/ja/3/library/logging.handlers.html#logging.handlers.RotatingFileHandler)
- [TimedRotatingFileHandler](https://docs.python.org/ja/3/library/logging.handlers.html#logging.handlers.TimedRotatingFileHandler)