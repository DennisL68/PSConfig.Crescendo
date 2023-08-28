# PSScriptAnalyzerSettings.psd1

@{
    'Rules' = @{
        'PSAvoidUsingCmdletAliases' = @{
            'allowlist' = @('foreach','select','where','group','compare','sort','sleep')
        }
    }
}
