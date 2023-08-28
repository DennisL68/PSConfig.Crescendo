Rename-Item "$PSScriptRoot\output" -NewName "PSConfig.Crescendo"
Publish-Module -Path "$PSScriptRoot\PSConfig.Crescendo" -NuGetApiKey $Env:NUGETAPIKEY
