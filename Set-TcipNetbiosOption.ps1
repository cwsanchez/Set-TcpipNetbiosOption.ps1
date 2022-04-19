param (
	[Parameter(Mandatory = $true, ParameterSetName = 'EnableNetbios')]
	[switch]$Enable,
	[Parameter(Mandatory = $true, ParameterSetName = 'DisableNetbios')]
	[switch]$Disable,
	[Parameter(Mandatory = $true, ParameterSetName = 'SetDHCPDefault')]
	[switch]$DHCPDefault,

	[switch]$Silent
)

$netAdapters = Get-WmiObject -ClassName Win32_NetworkAdapterConfiguration | 
	Where-Object -Property 'TcpipNetbiosOptions' -ne $null

if ($netAdapters -eq $null) {
	Write-Host "Could not find valid network adapter!"
	exit
}

$changedAdapters = @()

if ($Enable) {
	foreach ($adapter in $netAdapters) {
		$adapter.SetTcpIpNetbios("1") | Out-Null
		$index = $adapter.Index
		$newAdapterSettings = Get-WmiObject -ClassName Win32_NetworkAdapterConfiguration | Where-Object -Property 'Index' -eq "$index"
		$changedAdapters += $newAdapterSettings
	}
}
elseif ($Disable) {
	foreach ($adapter in $netAdapters) {
		$adapter.SetTcpIpNetbios("2") | Out-Null
		$index = $adapter.Index
		$newAdapterSettings = Get-WmiObject -ClassName Win32_NetworkAdapterConfiguration | Where-Object -Property 'Index' -eq "$index"
		$changedAdapters += $newAdapterSettings
	}
}
elseif ($DHCPDefault) {
	foreach ($adapter in $netAdapters) {
		$adapter.SetTcpIpNetbios("0") | Out-Null
		$index = $adapter.Index
		$newAdapterSettings = Get-WmiObject -ClassName Win32_NetworkAdapterConfiguration | Where-Object -Property 'Index' -eq "$index"
		$changedAdapters += $newAdapterSettings
	}
}	

if ($Silent) {
	exit
}
else {
	foreach ($adapter in $changedAdapters) {
		$adapter | Select-Object -Property Index, Description, TcpIpNetbiosOptions, DHCPEnabled, IPAddress
	}
}