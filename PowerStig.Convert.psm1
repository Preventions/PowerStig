# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
#Requires -Version 5.1

<#
    A funny note if you have OCD. The order of the dot sourced files is important due to the way
    that PowerShell processes the files (Top/Down). The Classes in the module depend on the
    enumerations, so if you want to alphabetize this list, don't. PowerShell with throw an error
    indicating that the enumerations can't be found, if you try to load the classes before the
    enumerations.
#>
using module .\Module\Common\Common.psm1
using module .\Module\Convert\Convert.psm1
using module .\Module\AccountPolicyRule\AccountPolicyRule.psm1
using module .\Module\AuditPolicyRule\AuditPolicyRule.psm1
using module .\Module\DnsServerRootHintRule\DnsServerRootHintRule.psm1
using module .\Module\DnsServerSettingRule\DnsServerSettingRule.psm1
using module .\Module\DocumentRule\DocumentRule.psm1
using module .\Module\FileContentRule\FileContentRule.psm1
using module .\Module\GroupRule\GroupRule.psm1
using module .\Module\IISLoggingRule\IISLoggingRule.psm1
using module .\Module\ManualRule\ManualRule.psm1
using module .\Module\MimeTypeRule\MimeTypeRule.psm1
using module .\Module\PermissionRule\PermissionRule.psm1
using module .\Module\ProcessMitigationRule\ProcessMitigationRule.psm1
using module .\Module\RegistryRule\RegistryRule.psm1
using module .\Module\SecurityOptionRule\SecurityOptionRule.psm1
using module .\Module\ServiceRule\ServiceRule.psm1
using module .\Module\SqlScriptQueryRule\SqlScriptQueryRule.psm1
using module .\Module\Rule\Rule.psm1
using module .\Module\UserRightsAssignmentRule\UserRightsAssignmentRule.psm1
using module .\Module\WebAppPoolRule\WebAppPoolRule.psm1
using module .\Module\WebConfigurationPropertyRule\WebConfigurationPropertyRule.psm1
using module .\Module\WindowsFeatureRule\WindowsFeatureRule.psm1
using module .\Module\WinEventLogRule\WinEventLogRule.psm1
using module .\Module\WmiRule\WmiRule.psm1

# load the public functions
foreach ($supportFile in ( Get-ChildItem -Path "$PSScriptRoot\Module\Convert.Main" -Recurse -Filter '*.ps1' -Exclude 'Data.*.ps1' ) )
{
    Write-Verbose "Loading $($supportFile.FullName)"
    . $supportFile.FullName
}

Export-ModuleMember -Function @(
    'ConvertFrom-StigXccdf',
    'ConvertTo-PowerStigXml',
    'Compare-PowerStigXccdf',
    'Compare-PowerStigXml',
    'Get-ConversionReport',
    'Split-StigXccdf'
)
