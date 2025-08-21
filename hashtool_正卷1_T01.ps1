
$csvFile = "E:\deepseekfor20190120\SHA256\2024年11月5日在贵州省贵阳市云岩区人民法院档案室获取《正卷1》的SHA256哈希结果T001.csv"
$ignoreDir = "E:\deepseekfor20190120\SHA256"

$files = Get-ChildItem -File -Recurse | Where-Object {
    $_.FullName -ne $csvFile -and ($_.FullName -notlike "$ignoreDir*" -and $_.DirectoryName -notlike "$ignoreDir*")
}

function Convert-Size {
    param([long]$bytes)
    if ($bytes -lt 8) {
        return "$bytes Bit"
    }
    elseif ($bytes -lt 1024) {
        return "$bytes B"
    }
    elseif ($bytes -lt 1024*1024) {
        return "{0:N2} KB" -f ($bytes/1024)
    }
    elseif ($bytes -lt 1024*1024*1024) {
        return "{0:N2} MB" -f ($bytes/1024/1024)
    }
    else {
        return "{0:N2} GB" -f ($bytes/1024/1024/1024)
    }
}

$fileList = @()
foreach ($file in $files) {
    $hash = Get-FileHash $file.FullName -Algorithm SHA256
    $creationTimeBJ = $file.CreationTimeUtc.AddHours(8)
    $creationTimeStr = $creationTimeBJ.ToString('yyyy年M月d日  HH:mm:ss')
    $lastWriteTimeBJ = $file.LastWriteTimeUtc.AddHours(8)
    $lastWriteTimeStr = $lastWriteTimeBJ.ToString('yyyy年M月d日  HH:mm:ss')
    $verifier = "王贵平"
    $verifyTime = (Get-Date).ToUniversalTime().AddHours(8).ToString('yyyy年M月d日  HH:mm:ss')
    $gpgPublicID = "55A6823C7A7F5CF17C5557311ABAF6CC3118F4BD"
    $gpgCreateTime = (Get-Date "2025/8/18 00:00:03").ToString('yyyy年M月d日  HH:mm:ss')
    $gpgPubKeyUrl = "https://github.com/deepseekfor20190120/deepseekfor20190120.github.io/blob/main/gpg_pub/%E7%8E%8B%E8%B4%B5%E5%B9%B3_0x3118F4BD_public.asc"
    $fileList += [PSCustomObject]@{
        "序号"         = 0
        "算法"         = $hash.Algorithm
        "来源"         = "贵州省贵阳市云岩区人民法院档案室"
        "来源单位负责人" = "该法院档案相关负责人及其管理人"
        "文件名"       = $file.Name
        "创建时间"     = $creationTimeStr
        "修改时间"     = $lastWriteTimeStr
        "修改时间原始" = $lastWriteTimeBJ
        "哈希值"       = $hash.Hash
        "文件大小"     = Convert-Size $file.Length
        "校验人"       = $verifier
        "校验时间"     = $verifyTime
        "校验人GPG公钥ID" = $gpgPublicID
        "校验人GPG密钥创建时间" = $gpgCreateTime
        "获取公钥路径" = $gpgPubKeyUrl
    }
}

$sortedFiles = $fileList | Sort-Object "修改时间原始"

$i = 1
$result = foreach ($file in $sortedFiles) {
    $file.序号 = $i
    [PSCustomObject]@{
        "序号"         = $file.序号
        "算法"         = $file.算法
        "来源"         = $file.来源
        "来源单位负责人" = $file.来源单位负责人
        "文件名"       = $file.文件名
        "创建时间"     = $file.创建时间
        "修改时间"     = $file.修改时间
        "哈希值"       = $file.哈希值
        "文件大小"     = $file.文件大小
        "校验人"       = $file.校验人
        "校验时间"     = $file.校验时间
        "校验人GPG公钥ID" = $file.校验人GPG公钥ID
        "校验人GPG密钥创建时间" = $file.校验人GPG密钥创建时间
        "获取公钥路径" = $file.获取公钥路径
    }
    $i++
}

$result | Export-Csv $csvFile -NoTypeInformation -Encoding UTF8
