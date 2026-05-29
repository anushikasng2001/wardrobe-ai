$env:GRADLE_USER_HOME = "C:\gradle-home"
$env:GRADLE_OPTS = "-Dorg.gradle.daemon=false"
$watchPaths = @("C:\gradle-home\caches\8.13\transforms","C:\Users\anushika.singh\.gradle\caches\8.13\transforms")
$alreadyFixed = @{}
$job = Start-Job -ScriptBlock {
    Set-Location "C:\FlutterProjects\wardrobe_ai"
    $env:GRADLE_USER_HOME = "C:\gradle-home"
    $env:GRADLE_OPTS = "-Dorg.gradle.daemon=false"
    flutter run -d ZA222LW37T 2>&1
}
while ($job.State -eq "Running") {
    foreach ($transforms in $watchPaths) {
        Get-ChildItem $transforms -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '-[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' } |
        ForEach-Object {
            $key = "$transforms\$($_.Name)"
            if ($alreadyFixed[$key]) { return }
            $target = $_.Name -replace '-[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', ''
            $targetPath = Join-Path $transforms $target
            $srcMeta = Join-Path $_.FullName "metadata.bin"
            if ((Test-Path $srcMeta) -and ((Get-Item $srcMeta -ErrorAction SilentlyContinue).Length -gt 0) -and (Test-Path (Join-Path $_.FullName "transformed"))) {
                Start-Sleep -Milliseconds 500
                if (!(Test-Path $targetPath)) { Copy-Item $_.FullName $targetPath -Recurse -Force -ErrorAction SilentlyContinue }
                else {
                    $dstSize = if (Test-Path "$targetPath\metadata.bin") { (Get-Item "$targetPath\metadata.bin").Length } else { -1 }
                    if ($dstSize -le 0) { Copy-Item "$($_.FullName)\*" "$targetPath\" -Recurse -Force -ErrorAction SilentlyContinue }
                }
                $alreadyFixed[$key] = $true
            }
        }
    }
    Start-Sleep -Milliseconds 100
}
Receive-Job $job | Write-Host
Remove-Job $job -Force



# PowerShell -ExecutionPolicy Bypass -File "C:\FlutterProjects\run.ps1"