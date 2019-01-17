Configuration xRegistry_config
{
    param
    ( )

    Import-Module $PSScriptRoot\..\..\..\DscResources\helper.psm1 -Force
    Import-DscResource -ModuleName PSDscResources -ModuleVersion 2.9.0.0

    Node localhost
    {
        . $PSScriptRoot\..\..\..\DscResources\Resources\windows.xRegistry.ps1
    }
}
