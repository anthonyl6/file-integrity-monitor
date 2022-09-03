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
        $fileHashTable.Add($a.Split("|")[0], $a.Split("|")[1])
    }
    $fileHashTable.Values
}