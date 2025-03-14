# poe (Poe the Poet)メモ

## 補完

[Enable tab completion for your shell](https://poethepoet.natn.io/installation.html#enable-tab-completion-for-your-shell)

bash だったら上記には

```sh
poe _bash_completion > /etc/bash_completion.d/poe.bash-completion
```

とあるけれど
普通は `/etc/bash_completion.d` に書き込み権限がないので

```sh
poe _bash_completion > poe.bash-completion
sudo mv poe.bash-completion /etc/bash_completion.d/
```

で、シェル再起動または `source /etc/bash_completion.d/poe.bash-completion`
