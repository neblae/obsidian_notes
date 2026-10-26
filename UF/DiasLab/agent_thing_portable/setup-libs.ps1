<#
.SYNOPSIS
  Enables the pl.* libs in a project by running setup.axon against it.
  Called by launch.bat after a project is created (and by "launch.bat setup").

.DESCRIPTION
  Starts the server on the project briefly with -noAuth (auth is disabled for
  loopback connections only), waits for its HTTP port, POSTs setup.axon to
  /api/sys/eval, then stops the server. Never fails the launcher: on any
  problem it prints why and exits 0 so the caller carries on; the setup line
  can always be pasted into the Shell by hand.
#>
param(
  [Parameter(Mandatory)][string]$Java,
  [Parameter(Mandatory)][string]$Here,
  [Parameter(Mandatory)][string]$ProjectDir
)

$ErrorActionPreference = 'Stop'

$setupFile = Join-Path $Here 'setup.axon'
if (-not (Test-Path -LiteralPath $setupFile)) {
  Write-Host 'setup.axon not found - skipping pl.* library setup.'
  exit 0
}
# each non-blank line is its own expression (a later line may call a lib the
# earlier one enabled), sent as its own request in order
$exprs = @([IO.File]::ReadAllLines($setupFile) | ForEach-Object { $_.Trim() } | Where-Object { $_ })

# The default theme's stylesheet (make.ps1 packages it as themes\pl-dark.css): give
# the project a copy in io\ so setup.axon's themeSeedDefault() can point a Theme at
# it. Never overwrites, so a project's own edits to it survive a re-run.
try {
  $cssSrc = Join-Path $Here 'themes\pl-dark.css'
  $cssDst = Join-Path (Join-Path $ProjectDir 'io') 'pl-dark.css'
  if ((Test-Path -LiteralPath $cssSrc) -and -not (Test-Path -LiteralPath $cssDst)) {
    New-Item -ItemType Directory -Path (Split-Path $cssDst -Parent) -Force | Out-Null
    Copy-Item -LiteralPath $cssSrc -Destination $cssDst
  }
} catch {
  Write-Host "WARNING: could not copy the default theme stylesheet: $($_.Exception.Message)"
}

$jar     = Join-Path $Here 'fantom\lib\java\sys.jar'
$fanHome = Join-Path $Here 'fantom'
$argStr  = "$env:JAVA_OPTS --enable-native-access=ALL-UNNAMED -cp `"$jar`" `"-Dfan.home=$fanHome`" fanx.tools.Fan hx::Main run `"$ProjectDir`" -noAuth"

$log = Join-Path ([IO.Path]::GetTempPath()) ("plsetup_" + [guid]::NewGuid().ToString('N'))
$p = $null
try {
  Write-Host 'Enabling pl.* libs (starting the server briefly)...'
  $p = Start-Process -FilePath $Java -ArgumentList $argStr -WorkingDirectory (Join-Path $Here 'haxall') `
         -RedirectStandardOutput "$log.out" -RedirectStandardError "$log.err" -PassThru -WindowStyle Hidden

  # wait for "http started on port N" in the server log
  $port = $null
  for ($i = 0; $i -lt 240; $i++) {
    if ($p.HasExited) { break }
    if (Test-Path "$log.out") {
      $txt = Get-Content -LiteralPath "$log.out" -Raw -ErrorAction SilentlyContinue
      if ($txt) {
        $m = [regex]::Match($txt, 'http started on port (\d+)')
        if ($m.Success) { $port = $m.Groups[1].Value; break }
      }
    }
    Start-Sleep -Milliseconds 500
  }
  if (-not $port) {
    Write-Host 'WARNING: the server did not report an HTTP port (is it already running, or the port in use?).'
    Write-Host '         Skipping pl.* library setup - paste setup.axon into the Shell instead.'
    exit 0
  }

  $failed = $false
  foreach ($expr in $exprs) {
    $esc  = $expr.Replace('\', '\\').Replace('"', '\"')
    $body = "ver:`"3.0`"`nexpr`n`"$esc`"`n"
    $resp = $null
    try {
      $resp = (Invoke-WebRequest -Uri "http://localhost:$port/api/sys/eval" -Method Post -Body $body `
                -ContentType 'text/zinc; charset=utf-8' -UseBasicParsing -TimeoutSec 300).Content
    } catch {
      $resp = "errType: $($_.Exception.Message) $($_.ErrorDetails.Message)"
    }

    if ($resp -match 'errType|\berr\b') {
      Write-Host 'WARNING: pl.* library setup failed:'
      Write-Host ($resp.Substring(0, [Math]::Min(600, $resp.Length)))
      Write-Host 'Paste the lines of setup.axon into the Shell to retry.'
      $failed = $true
      break
    }
  }
  if (-not $failed) { Write-Host 'pl.* libs enabled.' }
} catch {
  Write-Host "WARNING: pl.* library setup failed: $($_.Exception.Message)"
} finally {
  # "java" on PATH is often a launcher shim that starts the real JVM as a child
  # (e.g. Oracle's javapath), so stop the whole tree, then whatever still owns
  # the port, or the temporary server would keep running.
  if ($p) {
    & taskkill.exe /PID $p.Id /T /F 2>&1 | Out-Null
    [void]$p.WaitForExit(15000)
  }
  if ($port) {
    Get-NetTCPConnection -LocalPort ([int]$port) -State Listen -ErrorAction SilentlyContinue |
      ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }
  }
  Remove-Item "$log.out", "$log.err" -Force -ErrorAction SilentlyContinue
}
exit 0
