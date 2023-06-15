#Requires -Version 7.2

$Output = "$PSScriptRoot\output"
$obj = "$PSScriptRoot\obj"
$Version = (Get-Content $PSScriptRoot\version.txt)
Remove-Item $Output -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $obj -Recurse -Force -ErrorAction SilentlyContinue

$Modules = @(
    @{Name = 'Microsoft.PowerShell.Crescendo'; Version = '1.1.0'}
    @{Name = 'Pester'; Version = '4.10.1'}
    @{Name = 'PSScriptAnalyzer'; Version = '1.21.0'}
)

foreach ($Module in $Modules) {
    $ModuleExist = Import-Module `
        -Name $Module.Name `
        -RequiredVersion $Module.Version `
        -PassThru `
        -ErrorAction SilentlyContinue

    if (-not $ModuleExist) {
        Install-Module $Module.Name -RequiredVersion $Mdoule.Version -AllowPrerelease -Force -Scope CurrentUser
    }
}

New-Item $Output -ItemType Directory
New-Item $obj -ItemType Directory

. .\src\*.ps1
<# 
$Commands = Get-ChildItem "$PSScriptRoot\src\*.json" | foreach { 
    $Definition = Get-Content $_.FullName | ConvertFrom-Json | Select -ExpandProperty Commands
    $Command = New-CrescendoCommand -Verb $Definition.Verb -Noun $Definition.Noun -OriginalName $Definition.OriginalName
    $Command.OriginalCommandElements = $Definition.OriginalCommandElements
    $Command.Platform = "Windows"

    if ($Definition.Parameters) {
        $Command.Parameters = $Definition.Parameters | ForEach-Object {
            $Parameter = New-ParameterInfo -Name $_.Name -OriginalName $_.OriginalName 
            $Parameter.OriginalName = $_.OriginalName
            $Parameter.OriginalPosition = $_.OriginalPosition
            $Parameter.ParameterType = $_.ParameterType
            $Parameter
        }
    }

    if ($Definition.OutputHandlers) {
        $Command.OutputHandlers = $Definition.OutputHandlers | ForEach-Object {
            $Handler = New-OutputHandler 
            $Handler.ParameterSetName = $_.ParameterSetName
            $Handler.Handler = $_.Handler
            $Handler.HandlerType = $_.HandlerType
            $Handler.StreamOutput = $_.StreamOutput
            $Handler
        }
    }

    $Command 
}

@{
    '$schema' = 'https://aka.ms/PowerShell/Crescendo/Schemas/2022-06'
    Commands  = $Commands
} | ConvertTo-Json -Depth 5 | Out-File "$obj\Commands.json"

Export-CrescendoModule -ConfigurationFile (Get-ChildItem "$obj\*.json") -ModuleName (Join-Path $Output 'PSConfig.Crescendo') -Force 
 #>

 Export-CrescendoModule `
    -ConfigurationFile $PSScriptRoot\src\PSConfig.Crescendo.json `
    -ModuleName (Join-Path $Output 'PSConfig.Crescendo') `
    -Force 

 $ManifestInfo = @{
    ModuleVersion   = $Version
    Author          = 'Dennis Lindvist'
    Company         = '-'
    Copyright       = 'Dennis Lindqvist'
    Description     = 'PowerShell cmdlets for SharePoint PSConfig tool wrapped with MS Crescendo.'
    LicenseUri      = 'https://github.com/DennisL68/PSConfig.Crescendo/blob/main/LICENSEE'
    ProjectUri      = 'https://github.com/DennisL68/PSConfig.Crescendo'
    Tags            = @('SharePoint','PSConfig','CrescendoBuilt','SharePoint-On-Prem','SharePoint-Product-Configuration-Wizard')
    #A URL to an icon representing this module.
    #IconUri = ''
    #ReleaseNotes of this module
    #ReleaseNotes = '' 
}

Update-ModuleManifest -Path (Join-Path $Output 'PSConfig.Crescendo.psd1') @ManifestInfo 

Invoke-ScriptAnalyzer "$PSScriptRoot\output\PSConfig.Crescendo.psd1" -ExcludeRule PSAvoidTrailingWhitespace

Invoke-Pester -Path "$PSScriptRoot\tests"
