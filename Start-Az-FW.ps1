# // Start Azure Automation Login Using Service Principal
$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName
    "Logging in to Azure..."
    Add-AzAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}
# // AIRS STOP FW
$firewallRG = "RG-Hub-Core"
$firewallName = "AzFW-Hub-EastUS"
$subID = "1b233659-609f-49c0-bf59-f06289eb96e1"  #MS-XE-CSA-AIRS
Set-AzContext -subscriptionId $subID
$firewall=Get-AzFirewall -ResourceGroupName $firewallRG -Name $firewallName
# // Deallocate Firewall
$firewall.deallocate()
$firewall | Set-AzFirewall


# // VS STOP FW
$firewallRG = "RG-Connectivity-Core"
$firewallName = "AzFW-Hub-EastUS"
$subID = "af3717f4-48d1-42d5-8b79-453a28496737"  #MS-XE-CSA-AIA-Connectivity
Set-AzContext -subscriptionId $subID
$firewall=Get-AzFirewall -ResourceGroupName $firewallRG -Name $firewallName
# // Deallocate Firewall
$firewall.deallocate()
$firewall | Set-AzFirewall


# // AIRS Start FW
$firewallRG = "RG-Hub-Core"
$firewallName = "AzFW-Hub-EastUS"
$subID = "1b233659-609f-49c0-bf59-f06289eb96e1"  #MS-XE-CSA-AIRS
Set-AzContext -subscriptionId $subID
$firewall=Get-AzFirewall -ResourceGroupName $firewallRG -Name $firewallName
# // Allocate Firewall
$vnet = Get-AzVirtualNetwork -ResourceGroupName $firewallRG -Name "vNET-Hub"
$pip = Get-AzPublicIpAddress -ResourceGroupName $firewallRG -Name "pip-AzFW-HubEastUS"
$firewall.Allocate($vnet, $pip)
$firewall | Set-AzFirewall



# // VS START FW
$firewallRG = "RG-Connectivity-Core"
$firewallName = "AzFW-Hub-EastUS"
$subID = "af3717f4-48d1-42d5-8b79-453a28496737"  #MS-XE-CSA-AIA-Connectivity
Set-AzContext -subscriptionId $subID
$firewall=Get-AzFirewall -ResourceGroupName $firewallRG -Name $firewallName
# // Allocate Firewall
$vnet = Get-AzVirtualNetwork -ResourceGroupName $firewallRG -Name "vnet-connectivity-core-eastus"
$pip = Get-AzPublicIpAddress -ResourceGroupName $firewallRG -Name "pip-AzFW-HubEastUS"
$firewall.Allocate($vnet, $pip)
$firewall | Set-AzFirewall