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

        function Write-Match($matchInfo) {
            Write-Host "$($matchInfo.LineNumber): " -NoNewLine -ForegroundColor Blue

            $line = $matchInfo.Line
            $start = 0

            foreach ($match in $matchInfo.Matches) {
                if ($match.Index -gt $start) {
                    Write-Host -NoNewLine "$($line.Substring($start, $match.Index - $start))"
                }

                Write-Host $match.Value -NoNewLine -BackgroundColor DarkBlue
                $start = $match.Index + $match.Length
            }

            Write-Host $line.Substring($start)
        }

        $match = $_
        $preContext = $match.Context.DisplayPreContext
        $postContext = $match.Context.DisplayPostContext
        $firstVisibleLineNumber = $match.LineNumber - $preContext.Length

        if ($match.Path -ne $currentPath) {
            Write-FileHeader $match.Path
            $currentPath = $match.Path
            $lastPrintedLineNumber = 0
        }
        elseif ($lastPrintedLineNumber -lt $firstVisibleLineNumber - 1) {
            Write-Host "..." -ForegroundColor DarkGray
        }

        Write-Context $preContext ($match.LineNumber - $preContext.Length)
        Write-Match $match
        Write-Context $postContext ($match.LineNumber + 1)

        $lastPrintedLineNumber = $match.LineNumber + $postContext.Length
    }
}

Export-ModuleMember -Function Format-Matches