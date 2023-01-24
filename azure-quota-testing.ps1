<#
$Location = 'East US'
$VMSize = 'Standard_B2ms'
$SKU = Get-AzComputeResourceSku -Location $Location | where ResourceType -eq "virtualMachines" | select Name,Family
$VMFamily = ($SKU | where Name -eq $VMSize | select -Property Family).Family
$Usage = Get-AzVMUsage -Location $Location | Where-Object { $_.Name.Value -eq $VMFamily } 
$Usage = Get-AzVMUsage -Location $Location | Where-Object { $_.Name.Value -eq $VMFamily } | Select-Object @{label="Name";expression={$_.name.LocalizedValue}},currentvalue,limit, @{label="PercentageUsed";expression={[math]::Round(($_.currentvalue/$_.limit)*100,1)}}


$Usage = Get-AzVMUsage -Location $Location | select @{label="Name";expression={$_.name.LocalizedValue}},currentvalue,limit, @{label="PercentageUsed";expression={[math]::Round(($_.currentvalue/$_.limit)*100,1)}},@{label="Location";expression={$loc}}

Get-AzVMUsage -Location $Location | Select-Object @{Name = 'Name';Expression = {"$($_.Name.LocalizedValue)"}},CurrentValue,Limit,@{Name = 'PercentUsed';Expression = {"{0:P2}" -f ($_.CurrentValue / $_.Limit)}}  | sort-object  { [INT]($_.percentused -replace '%')  } -descending


Write-Output "$($Usage.Name.LocalizedValue): You have consumed Percentage: $($USage.PercentageUsed)% | $($Usage.CurrentValue) /$($Usage.Limit)  / available quota"

#>




#Working:

$QuotaPercentageThreshold = "5"

$Location = 'East US'
$VMSize = 'Standard_B2ms'
$SKU = Get-AzComputeResourceSku -Location $Location | where ResourceType -eq "virtualMachines" | select Name,Family
$VMFamily = ($SKU | where Name -eq $VMSize | select -Property Family).Family
$Usage = Get-AzVMUsage -Location $Location | Where-Object { $_.Name.Value -eq $VMFamily } | Select-Object @{label="Name";expression={$_.name.LocalizedValue}},currentvalue,limit, @{label="PercentageUsed";expression={[math]::Round(($_.currentvalue/$_.limit)*100,1)}}
Write-Output "$($Usage.Name.LocalizedValue): You have consumed Percentage: $($USage.PercentageUsed)% | $($Usage.CurrentValue) /$($Usage.Limit) of available quota"

if ($($USage.PercentageUsed) -gt $QuotaPercentageThreshold) {
    Write-Output "$($Usage.Name.LocalizedValue): You have consumed Percentage: $($USage.PercentageUsed)% | $($Usage.CurrentValue) /$($Usage.Limit) of available quota"
}