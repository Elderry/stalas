<#
.SYNOPSIS
Configure operation for Baidu Yun.
#>

$RemoveList = @(
    (Join-Path $Env:APPDATA 'baidu/BaiduNetdisk/YunOfficeAddin.dll'),
    (Join-Path $Env:APPDATA 'baidu/BaiduNetdisk/YunOfficeAddin64.dll')
)

$RemoveList.ForEach({
    Remove-Item $_
})
