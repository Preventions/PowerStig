# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

data xmlAttribute
{
    ConvertFrom-StringData -StringData @'
        stigId             = id
        stigVersion        = version
        stigConvertCreated = created

        ruleId                = id
        ruleSeverity          = severity
        ruleConversionStatus  = conversionstatus
        ruleTitle             = title
        ruleDscResource       = dscresource
        ruleDscResourceModule = dscresourcemodule

        organizationalSettingValue = value
'@
}

data xmlElement
{
    ConvertFrom-StringData -StringData @'
        stigConvertRoot = DISASTIG

        organizationalSettingRoot  = OrganizationalSettings
        organizationalSettingChild = OrganizationalSetting
'@
}

data dscResourceModule
{
    ConvertFrom-StringData -StringData @'
        AccountPolicyRule               = SecurityPolicyDsc
        AuditPolicyRule                 = AuditPolicyDsc
        DnsServerSettingRule            = xDnsServer
        DnsServerRootHintRule           = PSDesiredStateConfiguration
        DocumentRule                    = None
        GroupRule                       = PSDesiredStateConfiguration
        IisLoggingRule                  = xWebAdministration
        MimeTypeRule                    = xWebAdministration
        ManualRule                      = None
        PermissionRule                  = AccessControlDsc
        ProcessMitigationRule           = WindowsDefenderDsc
        RegistryRule                    = xPSDesiredStateConfiguration
        SecurityOptionRule              = SecurityPolicyDsc
        ServiceRule                     = xPSDesiredStateConfiguration
        SqlScriptQueryRule              = SqlServerDsc
        UserRightRule                   = SecurityPolicyDsc
        WebAppPoolRule                  = xWebAdministration
        WebConfigurationPropertyRule    = xWebAdministration
        WindowsFeatureRule              = PSDesiredStateConfiguration
        WinEventLogRule                 = xWinEventLog
        WmiRule                         = PSDesiredStateConfiguration
        FileContentRule                 = FileContentDsc
'@
}

data propertiesToRemove
{
    'id'
    'severity'
    'conversionstatus'
    'title'
    'dscresource'
    'dscresourcemodule'
    'RawString'
}