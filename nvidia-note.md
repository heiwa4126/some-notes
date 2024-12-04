# NVIDIA のメモ

## メモリ使用量だけ表示

基本はこんな感じ

```sh
nvidia-smi --query-gpu=index,memory.used,memory.total --format=csv,noheader,nounits
```

アレンジしたのがこう。

```sh
nvidia-smi --query-gpu=index,memory.used,memory.free,memory.total --format=csv,noheader,nounits | \
awk '{used_percentage=($2/$4)*100; printf "GPU ID %d: %.2f%% (Used), %d/%d MiB (Used/Total), %d MiB Free\n", $1, used_percentage, $2, $4, $3}'
```

こんな結果が出る

```console
GPU ID 0: 27.04% (Used), 3023/11178 MiB (Used/Total), 8155 MiB Free
GPU ID 1: 18.40% (Used), 2056/11178 MiB (Used/Total), 9122 MiB Free
```

PowerShell 版:

```powershell
$nvidiaSmiOutput = nvidia-smi --query-gpu=index,memory.used,memory.free,memory.total --format=csv,noheader,nounits

$nvidiaSmiOutput -split "`n" | ForEach-Object {
    if ($_ -ne "") {
        $fields = $_ -split ", "
        $gpuId = [int]$fields[0]
        $memoryUsed = [int]$fields[1]
        $memoryFree = [int]$fields[2]
        $memoryTotal = [int]$fields[3]
        $usedPercentage = ($memoryUsed / $memoryTotal) * 100

        [PSCustomObject]@{
            'GPU ID' = $gpuId
            'Used Percentage' = "{0:N2}" -f $usedPercentage + '%'
            'Memory Used / Total' = "$memoryUsed/$memoryTotal MiB"
            'Memory Free' = "$memoryFree MiB"
        }
    }
} | Format-Table -AutoSize
```

## VSCode で Jupyter を使っているときに Jupyter kernel を再起動して CUDA のメモリを開ける

F1 押して `Jupyter: restart kernel`

## Ubuntu 22.04 LTS に新しい CUDA ToolKit をインストールする

### 古いのがあったら削除

Ubuntu 22.04 LTS の配布版は古い。

```console
$ nvcc -V
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2021 NVIDIA Corporation
Built on Thu_Nov_18_09:45:30_PST_2021
Cuda compilation tools, release 11.5, V11.5.119
Build cuda_11.5.r11.5/compiler.30672275_0
```

こんな感じだったら古い。削除しておく

```sh
sudo apt remove nvidia-cuda-toolkit -y
sudo apt autoremove -y
```

で削除

### 新しい CUDA ToolKit をインストール

[CUDA Toolkit 12.5 Downloads | NVIDIA Developer](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_local)

(表示されるまでちょっと待つ)

"Base Installer" のところに、こんな ↓ コマンドが表示されるので実行。

```sh
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.5.0/local_installers/cuda-repo-ubuntu2204-12-5-local_12.5.0-555.42.02-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-12-5-local_12.5.0-555.42.02-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-12-5-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-5
```

nvcc などは普通でないパスにインストールされる
`/usr/local/cuda-12.5`。

で、

```console
$ LANG=C ls /usr/local/cuda -ld
lrwxrwxrwx 1 root root 22 May 23 14:06 /usr/local/cuda -> /etc/alternatives/cuda

$ LANG=C ls -ld /etc/alternatives/cuda
lrwxrwxrwx 1 root root 20 May 23 14:06 /etc/alternatives/cuda -> /usr/local/cuda-12.5
```

なので
`export PATH="/usr/local/cuda/bin:$PATH"`
的なことをする。(~/.profile に書く等)

LD_LIBRARY_PATH のほうは
パッケージ cuda-toolkit-config-common が
`/etc/ld.so.conf.d/000_cuda.conf`
を置いてくれてるので、特に作業の必要なし。

確認:

```console
$ which nvcc
/usr/local/cuda/bin/nvcc

$ nvcc -V
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2024 NVIDIA Corporation
Built on Wed_Apr_17_19:19:55_PDT_2024
Cuda compilation tools, release 12.5, V12.5.40
Build cuda_12.5.r12.5/compiler.34177558_0
```

## CUDA のバージョンを知る

`nvidia-smi` で表示される CUDA のバージョンと、
`nvcc` で表示される CUDA のバージョンと、
どちらが正しい CUDA のバージョンですか?

以下例:

```console
> nvcc -V
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2024 NVIDIA Corporation
Built on Wed_Apr_17_19:36:51_Pacific_Daylight_Time_2024
Cuda compilation tools, release 12.5, V12.5.40
Build cuda_12.5.r12.5/compiler.34177558_0

> nvidia-smi
Wed Dec  4 10:19:56 2024
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 566.03                 Driver Version: 566.03         CUDA Version: 12.7     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                  Driver-Model | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA GeForce RTX 3070 ...  WDDM  |   00000000:01:00.0  On |                  N/A |
| N/A   45C    P8             15W /   85W |     711MiB /   8192MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+
(略)
```

- `nvidia-smi` -
  NVIDIA ドライバーが対応している最大の CUDA バージョンを示します。このため、最新のドライバーがインストールされている場合でも、表示される CUDA バージョンはドライバーに依存します。
- `nvcc` -
  CUDA Toolkit に含まれるコンパイラのバージョンを表示。 これは CUDA プログラムをコンパイルするために必要なバージョンです。

### PyTorch はどの CUDA のバージョンのやつをインストールするべき?

- [Start Locally | PyTorch](https://pytorch.org/get-started/locally/)
- [Previous PyTorch Versions | PyTorch](https://pytorch.org/get-started/previous-versions/#wheel-1)

**`nvidia-smi` に表示される CUDA バージョンを確認してください。**

PyTorch の公式サイト（例: Previous Versions）で提供される CUDA バージョンは、「PyTorch がビルドされた CUDA ランタイムバージョン」を指します。

PyTorch を動かすだけなら、nvcc のバージョン（インストール済みの CUDA ツールキット）は直接関係ありません。

PyTorch には CUDA ランタイムが同梱されており、**通常は**独自に CUDA をインストールする必要がありません
(ただし、カスタム CUDA カーネルや独自のコンパイルが必要な場合、nvcc のバージョンも考慮する必要があります。この場合、PyTorch と同じ CUDA バージョンのツールキットをインストールするのが推奨されます)。

## 便利ツール `nvitop`

TUI 版の NVIDIA の top (「タスクマネージャのパフォーマンス」みたいなやつ)

[nvitop · PyPI](https://pypi.org/project/nvitop/)
