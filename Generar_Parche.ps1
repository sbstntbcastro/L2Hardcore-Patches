$gameDir = $PSScriptRoot
$manifestFile = Join-Path $gameDir "files.json"
$excludeList = @("L2Hardcore_Launcher.exe", "config.json", "index.html", "files.json", ".git", ".github", ".WebView2", "L2_Hardcore.exe.WebView2")

Write-Host "--- Generador de Manifiesto L2 Hardcore ---" -ForegroundColor Cyan

$filesDict = @{}
$files = Get-ChildItem -Path $gameDir -Recurse -File

foreach ($file in $files) {
    $relativePath = $file.FullName.Replace($gameDir + "\", "")
    
    # Excluir archivos del launcher y carpetas de sistema
    $skip = $false
    foreach ($exclude in $excludeList) {
        if ($relativePath.StartsWith($exclude)) { $skip = $true; break }
    }
    if ($skip) { continue }

    # Calcular MD5 (la firma del archivo)
    $hash = (Get-FileHash -Path $file.FullName -Algorithm MD5).Hash.ToLower()
    $filesDict[$relativePath.Replace("\", "/")] = $hash
    Write-Host "Procesado: $relativePath"
}

# Guardar como JSON
$filesDict | ConvertTo-Json | Out-File -FilePath $manifestFile -Encoding utf8
Write-Host "`n¡ÉXITO! Se ha creado el archivo files.json con $($filesDict.Count) archivos." -ForegroundColor Green
Write-Host "Ahora sube los archivos y el files.json a tu repositorio de GitHub."
pause
