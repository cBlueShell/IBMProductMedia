Using Module ..\IBMProductMedia\IBMProductMedia.psm1
$PSVersion = $PSVersionTable.PSVersion.Major
$ModuleName = $ENV:BHProjectName
$ModulePath = Join-Path $ENV:BHProjectPath $ModuleName

# Verbose output for non-master builds on appveyor
# Handy for troubleshooting.
# Splat @Verbose against commands as needed (here or in pester tests)
$Verbose = @{}
if($ENV:BHBranchName -notlike "master" -or $env:BHCommitMessage -match "!verbose") {
    $Verbose.add("Verbose", $True)
}

Describe "IBMProductMedia Module PS$PSVersion" {
    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should load' {
            $Module = Get-Module $ModuleName
            $Module.Name | Should be $ModuleName
        }
        It 'Should allow to create instance of MediaFile class' {
            [MediaFile] $tempMedia = [MediaFile]::new()
            $tempMedia.SizeOnDisk -eq 0 | Should Be $True
        }
        It 'Should allow to create instance of IBMProductMedia class' {
            [IBMProductMedia] $tempProduct = [IBMProductMedia]::new()
            $tempProduct.Name = "TempProduct"
            $tempProduct.Name -eq "TempProduct" | Should Be $True
        }
    }

    InModuleScope $ModuleName {
        It 'Should be able to parse a media definition file' {
            $productMediaConfig = Import-Clixml "$PSScriptRoot\TestData\ND-8.5.5-plus-JAVA7.xml"
            $productMediaConfig.ShortName -eq "WASND855" | Should Be $True 
        }
    }
}