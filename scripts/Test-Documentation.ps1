[CmdletBinding()]
param(
    [string]$RepositoryRoot
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) {
    $RepositoryRoot = Split-Path -Parent $PSScriptRoot
}

$repositoryPath = [System.IO.Path]::GetFullPath($RepositoryRoot)
$markdownFiles = Get-ChildItem -LiteralPath $repositoryPath -Recurse -File -Filter '*.md' |
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' }
$errors = [System.Collections.Generic.List[string]]::new()

foreach ($file in $markdownFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    $fenceCount = ([regex]::Matches($content, '(?m)^\s*(```|~~~)')).Count

    if ($fenceCount % 2 -ne 0) {
        $errors.Add("$($file.FullName): unmatched fenced code block.")
    }

    $matches = [regex]::Matches($content, '(?<!\!)\[[^\]]+\]\((?<target><[^>]+>|[^)\s]+)(?:\s+"[^"]*")?\)')
    foreach ($match in $matches) {
        $target = $match.Groups['target'].Value.Trim('<>')
        if ([string]::IsNullOrWhiteSpace($target) -or $target.StartsWith('#')) {
            continue
        }

        if ($target -match '^[a-zA-Z][a-zA-Z0-9+.-]*:') {
            continue
        }

        $relativePath = ($target -split '[?#]', 2)[0]
        if ($relativePath -match '^\.\./\.\./(issues|pulls|discussions)(/|$)') {
            continue
        }

        $linkedPath = [System.IO.Path]::GetFullPath((Join-Path $file.DirectoryName $relativePath))
        if (-not (Test-Path -LiteralPath $linkedPath)) {
            $errors.Add("$($file.FullName): local link target '$target' does not exist.")
        }
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    throw "Documentation validation failed with $($errors.Count) error(s)."
}

Write-Output "Documentation validation passed for $($markdownFiles.Count) Markdown file(s)."
