param(
    [string]$path
)

$files = Get-ChildItem -Path $path
$files | ForEach-Object {
    $file = $_.FullName
    sh $file
}