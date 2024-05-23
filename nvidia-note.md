# NVidia のメモ

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
