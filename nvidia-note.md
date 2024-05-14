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

## VSCode で Jupyter を使っているときに jupyter kernel を再起動して CUDA のメモリを開ける

F1 押して `Jupyter: restart kernel`
