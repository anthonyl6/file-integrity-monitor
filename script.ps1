Write-Host "A(Collect new Baseline?), B(Begin monitoring files with saved Baseline)"
$response = Read-Host -Prompt "[a/B]"

Function Calcualate-File-Hash($filePath) {
    $hash = Get-FileHash -path $filePath -Algorithm SHA512
    return $hash
}

if ($response -eq "A".ToUpper()) {
    Write-Host "Calculating hashes and making new Baseline"

    $files = Get-ChildItem -Path .\Files

    foreach ($a in $files) {
        $hash = Calcualate-File-Hash $a.FullName
        "$($hash.Path) | $($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
    }
}
else {
    Write-Host "Monitoring files with Baseline"

    $fileHashTable = @{}
    $fileData = Get-Content -Path .\baseline.txt

    foreach($a in $fileData) {
        $pair = $a.Split(" | ")
        $path = $pair[0]
        $hash = $pair[1]
        if(!$fileHashTable.ContainsKey($path)) {
            $fileHashTable.Add($path, $hash)
            Write-Host "Entering new pair"
        }
        elseif ($fileHashTable.ContainsKey($path)) {
            Write-Host "Pair already exists"
            if(!$fileHashTable[$hash] -eq $hash) {
                Write-Host "Hashes are different... updating..."
                $fileHashTable.Remove($path)
                $fileHashTable.Add($path, $hash) 
            }
        }
    }
    $fileHashTable

    while ($true) {
        Start-Sleep -Seconds 1

        # copying code change this
        $files = Get-ChildItem -Path .\Files

        foreach ($a in $files) {
            $hash = Calcualate-File-Hash $a.FullName

            # Notify new file being created
            if(!$fileHashTable.Contains($hash.Path)) {
                Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
            }
        }
    }
}