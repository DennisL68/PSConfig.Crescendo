# PSConfig.Crescendo

A PowerShell wrapper for SharePoint Products Configuration Wizard, psconfig, created using MS Crescendo Framework.

Note: This project has been abandoned since `SharePoint Subscription Edition` no longer need `psconfig.exe`.

I.e. the following sequence

~~~
psconfig -cmd upgrade -inplace b2b -wait -force -cmd applicationcontent -install -cmd installfeatures -cmd secureresources -cmd services -install
~~~

can be replaced with

~~~
Upgrade-SPFarm -Force -Verbose            # Upgrade SharePoint databases and binaries

Install-SPApplicationContent              # Install application content

Install-SPFeature -AllExistingFeatures    # Install all features to all site collections

Initialize-SPResourceSecurity             # Apply necessary security settings

Install-SPService                         # Install and provision required services
~~~

## How to build the module

* Clone the repo to your local system
* Dot Source the output script to be able to build  
  `. .\src\Invoke-ParseConfig.ps1`
* Run the build script

## Requirements

* Connection to Internet or pre-download the modules needed
* PowerShell 7.2.x or higher

## References

* [MS Learn - Install a software update for SharePoint Server](https://learn.microsoft.com/en-us/sharepoint/upgrade-and-update/install-a-software-update)
