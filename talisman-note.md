# talisman メモ

[talisman GitHub Repository](https://github.com/thoughtworks/talisman)

pre-commit hook を試してみる。

[pre-commit hook](https://github.com/thoughtworks/talisman?tab=readme-ov-file#installation-as-a-global-hook-template)

```console
 bash -c "$(curl --silent https://raw.githubusercontent.com/thoughtworks/talisman/main/global_install_scripts/install.bash)"
Downloading talisman binary
talisman_linux_amd64: OK


Setting up talisman binary and helper script in /home/heiwa/.talisman
Setting up TALISMAN_HOME in path


PLEASE CHOOSE WHERE YOU WISH TO SET TALISMAN_HOME VARIABLE AND talisman binary PATH (Enter option number):
1) Set TALISMAN_HOME in ~/.bashrc        3) Set TALISMAN_HOME in ~/.profile
2) Set TALISMAN_HOME in ~/.bash_profile  4) I will set it later
#? 1


Setting up interaction mode

DO YOU WANT TO BE PROMPTED WHEN ADDING EXCEPTIONS TO .talismanrc FILE?
Enter y to install in interactive mode. Press any key to continue without interactive mode (y/n):y
Setting up TALISMAN_HOME in /home/heiwa/.profile
After the installation is complete, you will need to manually restart the terminal or source /home/heiwa/.profile file
Press any key to continue ...
```

~/.bashrc に追加されたのはこんな感じ

```bash
# >>> talisman >>>
# Below environment variables should not be modified unless you know what you are doing
export TALISMAN_HOME=/home/heiwa/.talisman/bin
alias talisman=$TALISMAN_HOME/talisman_linux_amd64
export TALISMAN_INTERACTIVE=true
# <<< talisman <<<
```
