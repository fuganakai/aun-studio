# Aun Kitchen 投稿づくりを入れる（Windows用）。2回目以降に実行すると最新版に入れ替わる（作った投稿は残る）。
# 使い方: PowerShellに次の1行を貼る
#   irm https://raw.githubusercontent.com/fuganakai/aun-studio/main/install.ps1 | iex
& {
  $ErrorActionPreference = 'Stop'
  $ProgressPreference = 'SilentlyContinue'
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $url = 'https://github.com/fuganakai/aun-studio/releases/latest/download/aun-studio.zip'
  $dest = Join-Path $env:USERPROFILE 'AunKitchen'
  $tmp = Join-Path $env:TEMP ('aun-' + [guid]::NewGuid())
  New-Item -ItemType Directory $tmp | Out-Null
  Write-Host 'ダウンロードしています…'
  Invoke-WebRequest $url -OutFile (Join-Path $tmp 'a.zip') -UseBasicParsing
  Expand-Archive (Join-Path $tmp 'a.zip') (Join-Path $tmp 'x')
  # 上書きで入れる（studio\jobs の作った投稿と .venv は消さない）
  robocopy (Join-Path $tmp 'x\Aun投稿づくり') $dest /E /NFL /NDL /NJH /NJS /NP | Out-Null
  if ($LASTEXITCODE -ge 8) { throw 'ファイルをコピーできませんでした。' }
  Remove-Item $tmp -Recurse -Force
  $bat = Join-Path $dest 'はじめる.bat'
  $lnk = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) 'Aun投稿づくり.lnk'))
  $lnk.TargetPath = $bat; $lnk.WorkingDirectory = $dest; $lnk.Save()
  Write-Host '入れました。次からはデスクトップの「Aun投稿づくり」をダブルクリックすると開けます。'
  Start-Process $bat -WorkingDirectory $dest
}
