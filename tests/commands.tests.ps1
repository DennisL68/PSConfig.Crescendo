Import-Module "$PSScriptRoot\..\output\PSConfig.Crescendo.psd1" -Force

Describe "- Check that module was generated" {
    It "Should have at least one command" {
        Get-Command -Module PSConfig.Crescendo | Should -Not -Be $null
    }
}
