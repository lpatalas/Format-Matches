function Format-Matches {

    begin {
        $currentPath = ""
        $lastPrintedLineNumber = 0
    }

    end {
        Write-Host
    }

    process {
        function Write-FileHeader($filePath) {
            Write-Host
            Write-Host $filePath -ForegroundColor Yellow
        }

        function Write-Context($context, $lineNumber) {
            if ($context.Length -gt 0) {
                foreach ($line in $context) {
                    Write-Host "$($lineNumber): $line" -ForegroundColor DarkGray
                    $lineNumber++
                }
            }
        }

        function Write-Match($match) {
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
        }

        $match = $_
        $firstVisibleLineNumber = $match.LineNumber - $match.Context.DisplayPreContext.Length

        if ($match.Path -ne $currentPath) {
            Write-FileHeader $match.Path
            $currentPath = $match.Path
            $lastPrintedLineNumber = 0
        }
        elseif ($lastPrintedLineNumber -lt $firstVisibleLineNumber - 1) {
            Write-Host "..." -ForegroundColor DarkGray
        }

        Write-Context $match.Context.DisplayPreContext ($match.LineNumber - $match.Context.DisplayPreContext.Count)
        Write-Match $match
        Write-Context $match.Context.DisplayPostContext ($match.LineNumber + 1)

        $lastPrintedLineNumber = $match.LineNumber + $match.Context.DisplayPostContext.Length
    }
}

Export-ModuleMember -Function Format-Matches