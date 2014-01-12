function Format-Matches {
    begin {
        $currentPath = ""
        $lastLine = 0
    }

    process {
        $match = $_

        $lineNumber = $match.LineNumber - $match.Context.DisplayPreContext.Count

        if ($match.Path -ne $currentPath) {
            Write-Host
            Write-Host $match.Path -ForegroundColor Yellow
            $currentPath = $match.Path
            $lastLine = 0
        }
        elseif ($lastLine -lt $lineNumber - 1) {
            Write-Host "..."
        }

        if ($match.Context.DisplayPreContext.Length -gt 0) {
            foreach ($ctxLine in $match.Context.DisplayPreContext) {
                Write-Host "$($lineNumber): $ctxLine" -ForegroundColor DarkGray
                $lineNumber += 1
            }
        }
        

        Write-Host "$($match.LineNumber): " -NoNewLine -ForegroundColor Blue

        $line = $match.Line
        $start = 0

        foreach ($lineMatch in $match.Matches) {
            if ($lineMatch.Index -gt $start) {
                Write-Host -NoNewLine "$($line.Substring($start, $lineMatch.Index))"
            }

            Write-Host $lineMatch.Value -NoNewLine -BackgroundColor DarkBlue
            $start = $lineMatch.Index + $lineMatch.Length
        }

        Write-Host $line.Substring($start)
        
        if ($match.Context.DisplayPostContext.Length -gt 0) {
            foreach ($ctxLine in $match.Context.DisplayPostContext) {
                $lineNumber += 1
                Write-Host "$($lineNumber): $ctxLine" -ForegroundColor DarkGray
            }    
        }

        $lastLine = $lineNumber
    }

    end {
        Write-Host
    }
}

Export-ModuleMember -Function Format-Matches