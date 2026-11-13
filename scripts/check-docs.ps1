$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$docs = @(Get-ChildItem -LiteralPath $repoRoot -Filter '*.md' -File)
$problems = [System.Collections.Generic.List[string]]::new()

function Get-HeadingAnchors([string] $Content) {
    $counts = @{}
    foreach ($line in ($Content -split '\r?\n')) {
        if ($line -match '^#{1,6}\s+(.+?)\s*#*\s*$') {
            $slug = $Matches[1].ToLowerInvariant() -replace '[^\p{L}\p{M}\p{N}_\-\s]', ''
            $slug = $slug -replace '\s', '-'
            if ($counts.ContainsKey($slug)) {
                $counts[$slug]++
                "$slug-$($counts[$slug])"
            } else {
                $counts[$slug] = 0
                $slug
            }
        }
    }
}

foreach ($doc in $docs) {
    $content = [System.IO.File]::ReadAllText($doc.FullName)
    if (!$content.EndsWith("`n")) {
        $problems.Add("$($doc.Name): missing final newline")
    }
    $lineNumber = 0
    foreach ($line in ($content -split '\r?\n')) {
        $lineNumber++
        if ($line -match '[\t ]+$') {
            $problems.Add("$($doc.Name):${lineNumber}: trailing whitespace")
        }
    }
    # Inline links with simple destinations, as used in this repository.
    foreach ($link in [regex]::Matches($content, '\[[^\]\r\n]+\]\(([^\s)]+)\)')) {
        $destination = $link.Groups[1].Value
        if ($destination -match '^[a-zA-Z][a-zA-Z0-9+.-]*:|^//') { continue }
        $parts = $destination -split '#', 2
        $target = $doc.FullName
        if ($parts[0]) {
            $target = Join-Path $doc.DirectoryName ([uri]::UnescapeDataString($parts[0]))
        }
        if (!(Test-Path -LiteralPath $target -PathType Leaf)) {
            $problems.Add("$($doc.Name): missing link target $destination")
            continue
        }
        if ($parts.Count -eq 2 -and $parts[1]) {
            $anchors = @(Get-HeadingAnchors ([System.IO.File]::ReadAllText($target)))
            if ([uri]::UnescapeDataString($parts[1]) -cnotin $anchors) {
                $problems.Add("$($doc.Name): missing heading $destination")
            }
        }
    }
}

if ($problems.Count) {
    $problems | ForEach-Object { Write-Output $_ }
    exit 1
}
Write-Output "Documentation checks passed ($($docs.Count) Markdown files)."
exit 0
