Write-Host "A(Collect new Baseline?), B(Begin monitoring files with saved Baseline)"
$response = Read-Host -Prompt "[a/B]"

Function Calcualate-File-Hash($filePath) {
    $hash = Get-FileHash -path $filePath -Algorithm SHA512
    return $hash
}

$hash = Calcualate-File-Hash "C:\Users\Anthony\Pictures"

if ($response -eq "A".ToUpper()) {
    Write-Host "Calculating hashes and making new Baseline"

    $files = Get-ChildItem -Path ".\Files"
}
else {
    Write-Host "Monitoring files with Baseline"
}