# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
using module .\..\Common\Common.psm1
using module .\..\Rule\Rule.psm1
#using module .\..\Convert.RegistryRuleType\Convert.RegistryRuleType.psm1

$exclude = @($MyInvocation.MyCommand.Name,'Template.*.txt')
$supportFileList = Get-ChildItem -Path $PSScriptRoot -Exclude $exclude
Foreach ($supportFile in $supportFileList)
{
    Write-Verbose "Loading $($supportFile.FullName)"
    . $supportFile.FullName
}
# Header

<#
    .SYNOPSIS
        Convert the contents of an xccdf check-content element into a RegistryRule
    .DESCRIPTION
        The RegistryRule class is used to extract the registry settings
        from the check-content of the xccdf. Once a STIG rule is identified a
        registry rule, it is passed to the RegistryRule class for parsing
        and validation.
    .PARAMETER Key
        The registry key to be evaluated
    .PARAMETER ValueName
        The registry value name to be evaluated
    .PARAMETER ValueData
        The value data that should be appiled to the the ValueName
    .PARAMETER ValueType
        The type of registry value
    .PARAMETER Ensure
        A present or absent flag
#>
Class RegistryRule : Rule
{
    [string] $Key
    [string] $ValueName
    [string[]] $ValueData
    [string] $ValueType
    [ensure] $Ensure

    <#
        .SYNOPSIS
            Default constructor
        .DESCRIPTION
            Converts a xccdf stig rule element into a RegistryRule
        .PARAMETER StigRule
            The STIG rule to convert
    #>
    RegistryRule ( [xml.xmlelement] $StigRule )
    {
        $this.InvokeClass( $StigRule )
    }

    #region Methods

    <#
        .SYNOPSIS
            Extracts the registry key from the check-content and sets the value
        .DESCRIPTION
            Gets the registry key from the xccdf content and sets the value. If
            the registry key that is returned is not valid, the parser status is
            set to fail.
    #>
    [void] SetKey ()
    {
        $thisKey = Get-RegistryKey -CheckContent $this.SplitCheckContent

        if ( -not $this.SetStatus( $thisKey ) )
        {
            $this.set_Key( $thisKey )
        }
    }

    <#
        .SYNOPSIS
            Extracts the registry value name from the check-content and sets
            the value
        .DESCRIPTION
            Gets the registry value name from the xccdf content and sets the
            value. If the registry value name that is returned is not valid,
            the parser status is set to fail.
    #>
    [void] SetValueName ()
    {
        $thisValueName = Get-RegistryValueName -CheckContent $this.SplitCheckContent

        if ( -not $this.SetStatus( $thisValueName ) )
        {
            $this.set_ValueName( $thisValueName )
        }
    }

    <#
        .SYNOPSIS
            Extracts the registry value type from the check-content and sets
            the value
        .DESCRIPTION
            Gets the registry value type from the xccdf content and sets the
            value. If the registry value type that is returned is not valid,
            the parser status is set to fail.
    #>
    [void] SetValueType ()
    {
        $thisValueType = Get-RegistryValueType -CheckContent $this.SplitCheckContent

        if ($thisValueType -ne "Does Not Exist")
        {
            if ( -not $this.SetStatus( $thisValueType ) )
            {
                $this.set_ValueType( $thisValueType )
            }
        }
        else
        {
            $this.SetEnsureFlag([Ensure]::Absent)
        }
    }

    <#
        .SYNOPSIS
            Tests the value data for a range of valid values
        .DESCRIPTION
            Tests the value data string for text that describes a list of valid
            values
        .PARAMETER ValueDataString
            The text to test
    #>
    [bool] TestValueDataStringForRange ( [string] $ValueDataString )
    {
        return Test-RegistryValueDataContainsRange -ValueDataString $ValueDataString
    }

    <#
        .SYNOPSIS
            Extracts the registry value data from the check-content and sets
            the value
        .DESCRIPTION
            Gets the registry value data from the xccdf content and sets the
            value. If the registry value data that is returned is not valid,
            the parser status is set to fail.
    #>

    [string] GetValueData ()
    {
        return Get-RegistryValueData -CheckContent $this.SplitCheckContent
    }

    <#
        .SYNOPSIS
            Tests if the value data is supposed to be blank
        .DESCRIPTION
            Some stig settings state that a registry value, if it exists, is set
            to an empty value
        .PARAMETER ValueDataString
            The text to test
    #>
    [bool] IsDataBlank ( [string] $ValueDataString )
    {
        return Test-RegistryValueDataIsBlank -ValueDataString $ValueDataString
    }

    <#
        .SYNOPSIS
            Tests if the value data is an enabled or disabled
        .DESCRIPTION
            Checks if a string contains the literal word Enabled or Disabled
        .PARAMETER ValueDataString
            The text to test
    #>
    [bool] IsDataEnabledOrDisabled ( [string] $ValueDataString )
    {
        return Test-RegistryValueDataIsEnabledOrDisabled -ValueDataString $ValueDataString
    }

    <#
        .SYNOPSIS
            Get the valid version of the enabled or disabled
        .DESCRIPTION
            Get the valid version of the enabled or disabled, based on the the
            value type. A binary enabled, cannot accept the enabled string so
            the valid vaule needs to be returnd.
        .PARAMETER ValueType
            The value tyoe to evaluate
        .PARAMETER ValueData
            The value data to evaluate
    #>
    [string] GetValidEnabledOrDisabled ( [string] $ValueType, [string] $ValueData )
    {
        return Get-ValidEnabledOrDisabled -ValueType $ValueType -ValueData $ValueData
    }

    <#
        .SYNOPSIS
            Checks if a string contains a hexadecimal number
        .DESCRIPTION
            Checks if a string contains a hexadecimal number
        .PARAMETER ValueDataString
            The text to test
    #>
    [bool] IsDataHexCode ( [string] $ValueDataString )
    {
        return Test-RegistryValueDataIsHexCode -ValueDataString $ValueDataString
    }

    <#
        .SYNOPSIS
            Returns the integer of a hexadecimal number
        .DESCRIPTION
            Extracts the hex code if it exists, convert to int32 and set the
            output value. This ignores the int that usually accompanies the
            hex value in parentheses.
        .PARAMETER ValueDataString
            The text to test
    #>
    [int] GetIntegerFromHex ( [string] $ValueDataString )
    {
        return Get-IntegerFromHex -ValueDataString $ValueDataString
    }

    <#
        .SYNOPSIS
            Tests if the registry value is an integer
        .DESCRIPTION
            This will match any lines that start with an integer (of any length)
            as the value to be set
        .PARAMETER ValueDataString
            The text to test
    #>
    [bool] IsDataInteger ( [string] $ValueDataString )
    {
        return Test-RegistryValueDataIsInteger -ValueDataString $ValueDataString
    }

    <#
        .SYNOPSIS
            Returns the number from a string
        .DESCRIPTION
            Returns the number from a string
        .PARAMETER ValueDataString
            The text to test
    #>
    [string] GetNumberFromString ( [string] $ValueDataString )
    {
        return Get-NumberFromString -ValueDataString $ValueDataString
    }

    <#
        .SYNOPSIS
            Formats a string value into a multiline string
        .DESCRIPTION
            Formats a string value into a multiline string by spliting it on a
            space or comma space format
        .PARAMETER ValueDataString
            The text to test
    #>
    [string[]] FormatMultiStringRegistryData ( [string] $ValueDataString )
    {
        return Format-MultiStringRegistryData -ValueDataString $ValueDataString
    }

    <#
        .SYNOPSIS
            Get the multi-value string data
        .DESCRIPTION
            Get the multi-value string data
        .PARAMETER CheckStrings
            The rule text from the check-content element in the xccdf
    #>
    [string[]] GetMultiValueRegistryStringData ( [string[]] $CheckStrings )
    {
        return Get-MultiValueRegistryStringData -CheckStrings $CheckStrings
    }

    <#
        .SYNOPSIS
            Sets the ensure flag to the provided value
        .DESCRIPTION
            Sets the ensure flag to the provided value
        .PARAMETER EnsureFlag
            The value the Ensure flag should be set to
    #>
    [void] SetEnsureFlag ( [Ensure] $Ensure )
    {
        $this.Ensure = $Ensure
    }

    <#
        .SYNOPSIS
            Tests if a rule contains multiple checks
        .DESCRIPTION
            Search the rule text to determine if multiple registry paths are defined
        .PARAMETER CheckContent
            The rule text from the check-content element in the xccdf
    #>
    static [bool] HasMultipleRules ( [string] $CheckContent )
    {
        return Test-MultipleRegistryEntries -CheckContent ( [Rule]::SplitCheckContent( $CheckContent ) )
    }

    <#
        .SYNOPSIS
            Splits a rule into multiple checks
        .DESCRIPTION
            Once a rule has been found to have multiple checks, the rule needs
            to be split. This method splits registry paths into multiple rules.
            Each split rule id is appended with a dot and letter to keep reporting
            per the ID consistent. An example would be is V-1000 contained 2
            checks, then SplitMultipleRules would return 2 objects with rule ids
            V-1000.a and V-1000.b
        .PARAMETER CheckContent
            The rule text from the check-content element in the xccdf
    #>
    static [string[]] SplitMultipleRules ( [string] $CheckContent )
    {
        return ( Split-MultipleRegistryEntries -CheckContent ( [Rule]::SplitCheckContent( $CheckContent ) ) )
    }

    #endregion
}

