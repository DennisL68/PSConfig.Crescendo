function Invoke-ParseError {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]$InputString
    )
<#
    $logs = $InputString -like '*located*' | # get all lines containing a log file location
        foreach {# and extract the log file path
            $_ -replace "`n",'' -replace "`r",'' -split 'located' | select -index 1
            } |
                foreach {
                    $_ -split ' ' | select -Index 2
                }
#>
    $InputString -match 'error|exception|throw|invalid|fail|diagnostic|missing' |
        where {$_ -notlike '*success*'} |
            foreach {
                write-error -Message $_
            }

}
