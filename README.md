# Set-TcpipNetbiosOption.ps1
Powershell script to change NetBIOS setting on all available adapters. This script filters network adapters by those without a null value for the TCP/IP NetBIOS option.

Syntax:

Will enable netbios:
<pre><code>Set-TcpipNetbiosOption -Enable</code></pre>

Will disable netbios:
<pre><code>Set-TcpipNetbiosOption -Disable</code></pre>

Will set network adapters to pull setting from DHCP:
<pre><code>Set-TcpipNetbiosOption -DHCPDefault</code></pre>
